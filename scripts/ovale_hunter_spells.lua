local _, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "ovale_hunter_spells"
	local desc = "[5.4.7] Ovale: Hunter spells"
	local code = [[
Define(a_murder_of_crows 131894)
	SpellInfo(a_murder_of_crows cd=120 focus=60)
	SpellInfo(a_murder_of_crows buff_focus_half=beast_within_buff mastery=beast_mastery)
	SpellAddTargetDebuff(a_murder_of_crows a_murder_of_crows_debuff=1)
Define(a_murder_of_crows_debuff 131894)
	SpellInfo(a_murder_of_crows duration=30)
Define(a_murder_of_crows_talent 13)
Define(aimed_shot 19434)
	SpellInfo(aimed_shot buff_focus_none=master_marksman_fire_buff focus=50)
	SpellAddBuff(aimed_shot master_marksman_fire_buff=0)
Define(arcane_shot 3044)
	SpellInfo(arcane_shot focus=30)
	SpellInfo(arcane_shot buff_focus_half=beast_within_buff mastery=beast_mastery)
	SpellInfo(arcane_shot buff_focus=thrill_of_the_hunt_buff buff_focus_amount=-20 talent=thrill_of_the_hunt_talent)
	SpellAddBuff(arcane_shot thrill_of_the_hunt_buff=-1)
	SpellAddTargetDebuff(arcane_shot hunters_mark_debuff=1)
Define(aspect_of_the_hawk 13165)
	SpellInfo(aspect_of_the_hawk cd=1)
Define(aspect_of_the_iron_hawk 109260)
	SpellInfo(aspect_of_the_iron_hawk cd=1)
Define(aspect_of_the_iron_hawk_talent 8)
Define(barrage 120360)
	SpellInfo(barrage cd=30 focus=30)
	SpellInfo(barrage buff_focus_half=beast_within_buff mastery=beast_mastery)
Define(barrage_talent 18)
Define(beast_within_buff 34471)
	SpellInfo(beast_within_buff duration=10)
	SpellInfo(beast_within_buff addduration=6 itemset=T14 itemcount=4)
Define(bestial_wrath 19574)
	SpellInfo(bestial_wrath cd=60)
	SpellAddBuff(bestial_wrath beast_within_buff=1)
Define(black_arrow 3674)
	SpellInfo(black_arrow cd=30 focus=35)
	SpellInfo(black_arrow addcd=-6 if_spell=trap_mastery)
	SpellAddTargetDebuff(black_arrow black_arrow_debuff=1)
Define(black_arrow_debuff 3674)
	SpellInfo(black_arrow_debuff duration=20 tick=2)
Define(bombardment_buff 82921)
	SpellInfo(bombardment_buff duration=5)
Define(chimera_shot 53209)
	SpellInfo(chimera_shot cd=9 focus=45)
	SpellAddTargetDebuff(chimera_shot serpent_sting_debuff=refresh)
	SpellAddTargetDebuff(chimera_shot hunters_mark_debuff=1)
Define(cobra_shot 77767)
	SpellInfo(cobra_shot focus=-14)
	SpellInfo(cobra_shot focus=-28 itemset=T13 itemcount=2)
Define(counter_shot 147362)
	SpellInfo(counter_shot cd=24)
Define(crouching_tiger_hidden_chimera_talent 3)
Define(deterrence 19263)
	SpellInfo(deterrence cd=180)
	SpellInfo(deterrence addcd=-60 talent=crouching_tiger_hidden_chimera_talent)
Define(dire_beast 120679)
	SpellInfo(dire_beast cd=30)
Define(dire_beast_talent 11)
Define(disengage 781)
	SpellInfo(disengage cd=20)
	SpellInfo(disengage addcd=-10 talent=crouching_tiger_hidden_chimera_talent)
Define(explosive_shot 53301)
	SpellInfo(explosive_shot buffnocd=lock_and_load_buff buff_focus_none=lock_and_load_buff cd=6 focus=25)
	SpellAddTargetDebuff(explosive_shot hunters_mark_debuff=1)
Define(explosive_trap 13813)
	SpellInfo(explosive_trap cd=30)
	SpellInfo(explosive_trap addcd=-6 if_spell=trap_mastery)
Define(fervor 82726)
	SpellInfo(fervor cd=30 focus=-50)
Define(fervor_talent 10)
Define(focus_fire 82692)
	SpellAddBuff(focus_fire frenzy_buff=0)
Define(glaive_toss 117050)
	SpellInfo(glaive_toss cd=15 focus=15)
	SpellInfo(glaive_toss buff_focus_half=beast_within_buff mastery=beast_mastery)
Define(glaive_toss_talent 16)
Define(hunters_mark 1130)
Define(hunters_mark_debuff 1130)
	SpellInfo(hunters_mark_debuff duration=300)
	SpellAddTargetDebuff(hunters_mark hunters_mark_debuff=1)
Define(kill_command 34026)
	SpellInfo(kill_command cd=6 focus=40)
	SpellInfo(kill_command buff_focus_half=beast_within_buff)
	SpellAddTargetDebuff(kill_command hunters_mark=1)
Define(kill_shot 53351)
	SpellInfo(kill_shot cd=10)
Define(lock_and_load_buff 56453)
	SpellInfo(lock_and_load_buff duration=12)
Define(lynx_rush 120697)
	SpellInfo(lynx_rush cd=90)
	SpellAddTargetDebuff(lynx_rush lynx_rush_debuff=1)
Define(lynx_rush_debuff 120699)
	SpellInfo(lynx_rush_debuff duration=15 tick=3)
Define(lynx_rush_talent 15)
Define(master_marksman_fire_buff 82926)
	SpellInfo(master_marksman_fire_buff duration=10)
Define(misdirection 34477)
	SpellInfo(misdirection cd=30)
Define(multi_shot 2643)
	SpellInfo(multi_shot focus=40)
	SpellInfo(multi_shot buff_focus=thrill_of_the_hunt_buff buff_focus_amount=-20 talent=thrill_of_the_hunt_talent)
	SpellInfo(multi_shot buff_focus_half=beast_within_buff mastery=beast_mastery)
	SpellInfo(multi_shot buff_focus=bombardment_buff buff_focus_amount=-20 mastery=marksmanship)
	SpellAddBuff(multi_shot thrill_of_the_hunt_buff=-1)
	SpellAddTargetDebuff(multi_shot serpent_sting_debuff=1 if_spell=serpent_spread)
Define(pet_beast_cleave_buff 118455)
	SpellInfo(pet_beast_cleave_buff duration=4)
Define(pet_frenzy_buff 19615)
	SpellInfo(pet_frenzy_buff duration=30)
Define(powershot 109259)
	SpellInfo(powershot cd=60 focus=15)
	SpellInfo(powershot buff_focus_half=beast_within_buff mastery=beast_mastery)
Define(powershot_talent 17)
Define(pre_steady_focus_buff 53224)
Define(rapid_fire 3045)
	SpellInfo(rapid_fire cd=180)
	SpellAddBuff(rapid_fire rapid_fire_buff=1)
Define(rapid_fire_buff 3045)
	SpellInfo(rapid_fire_buff duration=15)
Define(revive_pet 982)
	SpellInfo(revive_pet focus=35)
	SpellInfo(revive_pet buff_focus_half=beast_within_buff mastery=beast_mastery)
Define(serpent_spread 87935)
Define(serpent_sting 1978)
	SpellInfo(serpent_sting focus=15)
	SpellInfo(serpent_sting buff_focus_half=beast_within_buff mastery=beast_mastery)
	SpellAddTargetDebuff(serpent_sting serpent_sting_debuff=1)
Define(serpent_sting_debuff 118253)
	SpellInfo(serpent_sting_debuff duration=15 tick=3)
Define(silencing_shot 34490)
	SpellInfo(silencing_shot cd=24)
Define(stampede 121818)
	SpellInfo(stampede cd=300)
Define(stampede_buff 121818)
Define(steady_focus 53224)
Define(steady_focus_buff 53220)
	SpellInfo(steady_focus_buff duration=20)
Define(steady_shot 56641)
	SpellInfo(steady_shot focus=-14)
	SpellInfo(steady_shot focus=-28 itemset=T13 itemcount=2)
	SpellInfo(steady_shot buff_focus=steady_focus_buff buff_focus_amount=-3 if_spell=steady_focus)
Define(thrill_of_the_hunt_buff 34720)
	SpellInfo(thrill_of_the_hunt_buff duration=15)
Define(thrill_of_the_hunt_talent 12)

AddFunction Interrupt
{
	if not target.IsFriend() and target.IsInterruptible()
	{
		Spell(silencing_shot)
		Spell(counter_shot)
	}
}

AddFunction SummonPet
{
	if pet.Present(no) Texture(ability_hunter_beastcall)
	if pet.IsDead() Spell(revive_pet)
}
]]

	OvaleScripts:RegisterScript("HUNTER", name, desc, code, "include")
end
