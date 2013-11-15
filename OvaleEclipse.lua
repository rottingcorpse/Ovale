--[[--------------------------------------------------------------------
    Ovale Spell Priority
    Copyright (C) 2013 Johnny C. Lam

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License in the LICENSE
    file accompanying this program.
--]]--------------------------------------------------------------------

--[[
	This addon tracks Eclipse energy information on druids.
--]]

local _, Ovale = ...
local OvaleEclipse = Ovale:NewModule("OvaleEclipse", "AceEvent-3.0")
Ovale.OvaleEclipse = OvaleEclipse

--<private-static-properties>
local OvaleData = Ovale.OvaleData
local OvaleGUID = Ovale.OvaleGUID
local OvaleSpellBook = Ovale.OvaleSpellBook
local OvaleState = Ovale.OvaleState
local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE

local select = select
local API_GetEclipseDirection = GetEclipseDirection
local API_UnitClass = UnitClass
local API_UnitPower = UnitPower

-- Player's GUID.
local self_guid = nil
-- Player's class.
local self_class = select(2, API_UnitClass("player"))

local LUNAR_ECLIPSE = ECLIPSE_BAR_LUNAR_BUFF_ID
local SOLAR_ECLIPSE = ECLIPSE_BAR_SOLAR_BUFF_ID
local CELESTIAL_ALIGNMENT = 112071
local EUPHORIA = 81062
local STARFALL = 48505
--</private-static-properties>

--<public-static-properties>
-- Direction that the eclipse status is moving: -1 = "lunar", 0 = "none", 1 = "solar".
OvaleEclipse.eclipse = 0
OvaleEclipse.eclipseDirection = 0
--<public-static-properties>

--<public-static-methods>
function OvaleEclipse:OnEnable()
	if self_class == "DRUID" then
		self_guid = OvaleGUID:GetGUID("player")
		self:RegisterEvent("ECLIPSE_DIRECTION_CHANGE", "UpdateEclipseDirection")
		self:RegisterEvent("UNIT_POWER")
		self:RegisterEvent("UNIT_POWER_FREQUENT", "UNIT_POWER")
		self:RegisterMessage("Ovale_SpecializationChanged", "UpdateEclipseDirection")
		self:RegisterMessage("Ovale_StanceChanged", "Update")
		self:RegisterMessage("Ovale_AuraAdded")
		OvaleState:RegisterState(self, self.statePrototype)
	end
end

function OvaleEclipse:OnDisable()
	if self_class == "DRUID" then
		OvaleState:UnregisterState(self)
		self:UnregisterEvent("ECLIPSE_DIRECTION_CHANGE")
		self:UnregisterEvent("UNIT_POWER")
		self:UnregisterEvent("UNIT_POWER_FREQUENT")
		self:UnregisterMessage("Ovale_AuraAdded")
		self:UnregisterMessage("Ovale_SpecializationChanged")
		self:UnregisterMessage("Ovale_StanceChanged")
	end
end

function OvaleEclipse:UNIT_POWER(event, unitId, powerToken)
	if unitId == "player" and powerToken == "ECLIPSE" then
		self:Update()
	end
end

function OvaleEclipse:Ovale_AuraAdded(event, timestamp, guid, spellId, caster)
	if guid == self_guid then
		if spellId == LUNAR_ECLIPSE or spellId == SOLAR_ECLIPSE then
			self:UpdateEclipseDirection()
		end
	end
end

function OvaleEclipse:Update()
	self:UpdateEclipse()
	self:UpdateEclipseDirection()
end

function OvaleEclipse:UpdateEclipse()
	self.eclipse = API_UnitPower("player", SPELL_POWER_ECLIPSE)
end

function OvaleEclipse:UpdateEclipseDirection()
	local direction = API_GetEclipseDirection()
	if direction == "moon" then
		self.eclipseDirection = -1
	elseif direction == "sun" then
		self.eclipseDirection = 1
	else -- if direction == "none" then
		if self.eclipse < 0 then
			self.eclipseDirection = -1
		elseif self.eclipse > 0 then
			self.eclipseDirection = 1
		else -- if self.eclipse == 0 then
			self.eclipseDirection = 0
		end
	end
end
--</public-static-methods>

--[[----------------------------------------------------------------------------
	State machine for simulator.

	AFTER: OvalePower
--]]----------------------------------------------------------------------------

--<public-static-properties>
OvaleEclipse.statePrototype = {
	eclipseDirection = nil,
}
--</public-static-properties>

--<public-static-methods>
-- Initialize the state.
function OvaleEclipse:InitializeState(state)
	state.eclipseDirection = 0
end

-- Reset the state to the current conditions.
function OvaleEclipse:ResetState(state)
	state.eclipseDirection = self.eclipseDirection
end

-- Apply the effects of the spell on the player's state, assuming the spellcast completes.
function OvaleEclipse:ApplySpellAfterCast(state, spellId, startCast, endCast, nextCast, nocd, targetGUID, spellcast)
	-- If the spellcast has already ended, then the effects on the player have already occurred.
	if endCast <= OvaleState.now then
		return
	end

	local si = OvaleData.spellInfo[spellId]
	if si and si.eclipse then
		local eclipse = state.eclipse
		local direction = state.eclipseDirection
		local energy = si.eclipse

		if energy == 0 then
			-- Spell resets Eclipse energy to zero, but leaves the Eclipse direction intact.
			eclipse = 0
		else -- if energy ~= 0 then
			-- If there is no Eclipse direction yet, then start moving in the direction generated
			-- by the energy of the spellcast.
			if direction == 0 then
				direction = (energy < 0) and -1 or 1
			end
			if si.eclipsedir then
				energy = energy * direction
			end
			if state:GetAura("player", CELESTIAL_ALIGNMENT, "HELPFUL", true) then
				-- Celestial Alignment prevents gaining Eclipse energy during its duration.
				energy = 0
			elseif OvaleSpellBook:IsKnownSpell(EUPHORIA)
						and not state:GetAura("player", LUNAR_ECLIPSE, "HELPFUL", true)
						and not state:GetAura("player", SOLAR_ECLIPSE, "HELPFUL", true) then
				-- Euphoria: While not in an Eclipse state, your spells generate double the normal
				-- amount of Solar or Lunar energy.
				energy = energy * 2
			end
			-- Only adjust Eclipse energy if the spell moves the Eclipse bar in the right direction.
			if (direction <= 0 and energy < 0) or (direction >= 0 and energy > 0) then
				eclipse = eclipse + energy
			end
			-- Clamp Eclipse energy to min/max values and note that an Eclipse state will be reached after the spellcast.
			if eclipse <= -100 then
				eclipse = -100
				direction = 1
				state:AddAuraToGUID(self_guid, LUNAR_ECLIPSE, "HELPFUL", true, endCast, math.huge)
				-- Reaching Lunar Eclipse resets the cooldown of Starfall.
				state:ResetSpellCooldown(LUNAR_ECLIPSE, endCast)
			elseif eclipse >= 100 then
				eclipse = 100
				direction = -1
				state:AddAuraToGUID(self_guid, SOLAR_ECLIPSE, "HELPFUL", true, endCast, math.huge)
			end
		end
		state.eclipse = eclipse
		state.eclipseDirection = direction
	end
end
--</public-static-methods>
