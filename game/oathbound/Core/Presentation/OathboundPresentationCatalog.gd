class_name OathboundPresentationCatalog
extends RefCounted

## Launch presentation content at first-playtest depth.
## Stable IDs are intentionally separate from English fallback text so every player-facing
## surface can migrate to TranslationServer catalogs without changing progression keys.

const STRAND_NPCS := ["keeper", "scribe", "raven", "undead_samurai", "smith", "peddler"]
const ENDING_CORE_MESSAGE := "The Heart survived. Its curse cannot spread."


static func shogun_states() -> Array[Dictionary]:
	return [
		{"id":"shogun_pre_awakened","speaker":"Eclipse Shogun","loc_key":"narrative.shogun.pre","lines":["Another sword from the shore. You have come farther than the others.","There is no Blood in you yet. I wonder whether discipline alone carried you here, or whether something older remembers the way."],"pre_awakened":true},
		{"id":"shogun_1_dismissal","speaker":"Eclipse Shogun","loc_key":"narrative.shogun.1","lines":["The Order still sends children to finish the work of dead men.","Kneel, and I will make this crossing brief."],"campaign_index":1},
		{"id":"shogun_2_fascination","speaker":"Eclipse Shogun","loc_key":"narrative.shogun.2","lines":["I watched you die. Now you stand before me carrying the wound as power.","Mine returns by appetite. Yours returns by refusal. That difference interests me."],"campaign_index":2},
		{"id":"shogun_3_recognition","speaker":"Eclipse Shogun","loc_key":"narrative.shogun.3","lines":["Now I see it. The line that escaped me did not end beyond the barrier.","You carry my house in your blood, Akio. Stand beside me. What survived in you can become the beginning of a kingdom without weakness."],"campaign_index":3},
		{"id":"shogun_4_possession","speaker":"Eclipse Shogun","loc_key":"narrative.shogun.4","lines":["You answer inheritance with a drawn blade.","Do not mistake silence for freedom. The Blood that restores you was born beneath my Court, and I will not watch my own bloodline squander it on the Order's fear."],"campaign_index":4},
		{"id":"shogun_5_fear","speaker":"Eclipse Shogun","loc_key":"narrative.shogun.5","lines":["You call this control because you can turn away from the Heart.","Look at what your restraint has purchased: broken seals, dying halls, a kingdom made smaller with every victory. You would rather inherit ashes than accept salvation."],"campaign_index":5},
		{"id":"shogun_6_desperation","speaker":"Eclipse Shogun","loc_key":"narrative.shogun.6","lines":["One restraint remains, and still you refuse to understand what you are destroying.","Break it, and every death we prevented becomes meaningless. I will tear Returning Blood from you before I permit that."],"campaign_index":6},
		{"id":"shogun_7_final","speaker":"Eclipse Shogun","loc_key":"narrative.shogun.7","lines":["The Heart is unbound. There is nothing left between your purpose and mine.","Come, heir. Let the last truth be decided without words."],"campaign_index":7},
	]


static func strand_major_conversations() -> Array[Dictionary]:
	return [
		{"id":"keeper_first_return","npc":"keeper","loc_key":"strand.keeper.first_return","requires_awakened":true,"min_bindings":0,"max_bindings":0,"lines":["I watched the mist take your body from the island. I marked you among the dead.","Yet the threshold opened inward, and the Blood rebuilt what should have been gone. Do not ask me for an explanation I do not possess. Not yet."]},
		{"id":"keeper_binding_one","npc":"keeper","loc_key":"strand.keeper.binding_one","requires_awakened":true,"min_bindings":1,"max_bindings":1,"lines":["So the chamber still holds six of the old restraints. I had believed the Court's first breach was the only wound that could never be closed.","Your Blood did not obey the Heart. It rejected reclamation and tore a Binding with it. That has never happened before."]},
		{"id":"keeper_bloodline","npc":"keeper","loc_key":"strand.keeper.bloodline","requires_awakened":true,"min_bindings":3,"max_bindings":3,"lines":["The Shogun spoke truth about the royal line. I knew the child was taken before the barrier closed. I did not know where the line survived.","You owe that blood no obedience. I served the man your ancestor fled. I know better than most what his claim of protection became."]},
		{"id":"keeper_five_bindings","npc":"keeper","loc_key":"strand.keeper.five_bindings","requires_awakened":true,"min_bindings":5,"max_bindings":5,"lines":["The passage shudders each time you return. The Heart is no longer merely hidden beneath the Court. It is pressing against what remains of its prison.","One more Binding after this, and my oldest warnings will no longer be enough. Be certain your purpose is stronger than your inheritance."]},
		{"id":"keeper_pre_heart","npc":"keeper","loc_key":"strand.keeper.pre_heart","requires_awakened":true,"min_bindings":6,"max_bindings":6,"pre_heart":true,"lines":["There are no Bindings left. On your next victory, the path beneath the Shogun will remain open.","I helped close this kingdom because I could not stop what we had become. You may now finish what all of us failed to do. I will keep the threshold open until you return, whatever form that return takes."]},

		{"id":"scribe_first_return","npc":"scribe","loc_key":"strand.scribe.first_return","requires_awakened":true,"min_bindings":0,"max_bindings":0,"lines":["Your death was recorded before the mist reached the water. I have crossed the entry out, but I have not destroyed it.","If this happens again, I need every detail we can observe. Not because I doubt you. Because no Order record says a dead warrior has ever come back human." ]},
		{"id":"scribe_binding_one","npc":"scribe","loc_key":"strand.scribe.binding_one","requires_awakened":true,"min_bindings":1,"max_bindings":1,"lines":["The recovered diagrams show seven restraints around the Heart. One was already broken when the Court began extraction. Six remained.","Your first ritual reduced that number to five. I am writing this as fact, not theory: Returning Blood can damage the prison permanently." ]},
		{"id":"scribe_bloodline","npc":"scribe","loc_key":"strand.scribe.bloodline","requires_awakened":true,"min_bindings":3,"max_bindings":3,"lines":["I found three independent references to a royal child removed before containment. None name the child, the route, or what became of the escort.","The dates fit the Shogun's claim. The gaps remain real, but the bloodline does not appear to be one of his inventions." ]},
		{"id":"scribe_five_bindings","npc":"scribe","loc_key":"strand.scribe.five_bindings","requires_awakened":true,"min_bindings":5,"max_bindings":5,"lines":["Every surviving extraction record assumes the Bindings would outlast the apparatus. There is no procedure for what you are doing.","That does not make it wrong. It means the people who built these records never imagined anyone could refuse the Heart from inside its own exchange." ]},
		{"id":"scribe_pre_heart","npc":"scribe","loc_key":"strand.scribe.pre_heart","requires_awakened":true,"min_bindings":6,"max_bindings":6,"pre_heart":true,"lines":["Bindings remaining: zero. I have checked the count until the ink tore the page.","There is no historical precedent for the next chamber. I can only give you what the evidence says: the Heart is exposed, Returning Blood still rejects it, and the Shogun is no longer the final barrier." ]},

		{"id":"raven_first_return","npc":"raven","loc_key":"strand.raven.first_return","requires_awakened":true,"min_bindings":0,"max_bindings":0,"notice":true,"lines":["ORDER NOTICE — Warrior Akio: status amended from fallen to active. Cause of return unknown.","Maintain containment priority. Observe all changes in body, memory, and allegiance. The courier will carry further instruction." ]},
		{"id":"raven_binding_one","npc":"raven","loc_key":"strand.raven.binding_one","requires_awakened":true,"min_bindings":1,"max_bindings":1,"notice":true,"lines":["ORDER NOTICE — Permanent damage to a Heart restraint is confirmed.","Continue the mission under Strand authority. No mainland transfer of Blood, tissue, or living specimen is permitted." ]},
		{"id":"raven_bloodline","npc":"raven","loc_key":"strand.raven.bloodline","requires_awakened":true,"min_bindings":3,"max_bindings":3,"notice":true,"lines":["ORDER NOTICE — The Shogun's bloodline claim has been reviewed against recovered records.","Ancestry does not alter your oath. The Order recognizes conduct, not royal inheritance." ]},
		{"id":"raven_five_bindings","npc":"raven","loc_key":"strand.raven.five_bindings","requires_awakened":true,"min_bindings":5,"max_bindings":5,"notice":true,"lines":["ORDER NOTICE — Containment instability has increased with each destroyed Binding.","The mainland remains secure. No withdrawal order has been issued. Complete the objective if the threshold remains viable." ]},
		{"id":"raven_pre_heart","npc":"raven","loc_key":"strand.raven.pre_heart","requires_awakened":true,"min_bindings":6,"max_bindings":6,"pre_heart":true,"notice":true,"lines":["FINAL CAMPAIGN NOTICE — All six remaining Heart Bindings are destroyed.","Defeat the Shogun and proceed to the source. Prevent Beast Blood from ever leaving this island again." ]},

		{"id":"samurai_first_return","npc":"undead_samurai","loc_key":"strand.samurai.first_return","requires_awakened":true,"min_bindings":0,"max_bindings":0,"lines":["Death changed your condition. It did not improve your form.","Draw. If the Blood returns you faster than discipline returns your judgment, it will own you before the Heart ever does." ]},
		{"id":"samurai_binding_one","npc":"undead_samurai","loc_key":"strand.samurai.binding_one","requires_awakened":true,"min_bindings":1,"max_bindings":1,"lines":["You entered the Heart's reach and came back yourself.","Remember the distinction. Power is not control. Refusal is control." ]},
		{"id":"samurai_bloodline","npc":"undead_samurai","loc_key":"strand.samurai.bloodline","requires_awakened":true,"min_bindings":3,"max_bindings":3,"lines":["Blood can name an ancestor. It cannot name your stance.","The Shogun wants inheritance to decide the fight for you. Do not grant him that convenience." ]},
		{"id":"samurai_five_bindings","npc":"undead_samurai","loc_key":"strand.samurai.five_bindings","requires_awakened":true,"min_bindings":5,"max_bindings":5,"lines":["You carry more Blood than the warrior who first stood here, yet your hand is quieter.","Good. Keep it that way when the source has nothing left to hide behind." ]},
		{"id":"samurai_pre_heart","npc":"undead_samurai","loc_key":"strand.samurai.pre_heart","requires_awakened":true,"min_bindings":6,"max_bindings":6,"pre_heart":true,"lines":["No lesson remains that the cavern can give you.","At the Heart, strength will ask to become purpose. Refuse it. Cut only what you chose to cut before the Blood began speaking through your body." ]},

		{"id":"smith_first_return","npc":"smith","loc_key":"strand.smith.first_return","requires_awakened":true,"min_bindings":0,"max_bindings":0,"lines":["Your blade came back with you. Same nick on the spine. Same wrap. Your body is harder to account for.","If the Blood insists on rebuilding you, give me anything it changes in the gear. Metal tells fewer lies than people." ]},
		{"id":"smith_binding_one","npc":"smith","loc_key":"strand.smith.binding_one","requires_awakened":true,"min_bindings":1,"max_bindings":1,"lines":["That fragment from below is old work. Older than the Court, and stressed fresh through the middle.","Whatever you broke down there was built to stay broken only once. Keep bringing me what survives the trip back." ]},
		{"id":"smith_bloodline","npc":"smith","loc_key":"strand.smith.bloodline","requires_awakened":true,"min_bindings":3,"max_bindings":3,"lines":["Royal blood, common blood. Doesn't change the edge angle.","The Shogun can keep the genealogy. You keep bringing back steel that works." ]},
		{"id":"smith_five_bindings","npc":"smith","loc_key":"strand.smith.five_bindings","requires_awakened":true,"min_bindings":5,"max_bindings":5,"lines":["The Court salvage is warming before it reaches the forge now. That's new.","Something below is pushing harder through everything tied to it. Check your fittings before you cross again." ]},
		{"id":"smith_pre_heart","npc":"smith","loc_key":"strand.smith.pre_heart","requires_awakened":true,"min_bindings":6,"max_bindings":6,"pre_heart":true,"lines":["I've checked the blade, the prosthetic, every buckle I can reach. Nothing else to tighten.","If you come back, I'll repair what can be repaired. If you don't, the work was sound when it left my bench." ]},

		{"id":"peddler_first_return","npc":"peddler","loc_key":"strand.peddler.first_return","requires_awakened":true,"min_bindings":0,"max_bindings":0,"lines":["I had already set aside a cloth for your effects. Wasteful of me, apparently.","No offense intended. The island has trained us to be practical about belongings whose owners stop needing them." ]},
		{"id":"peddler_binding_one","npc":"peddler","loc_key":"strand.peddler.binding_one","requires_awakened":true,"min_bindings":1,"max_bindings":1,"lines":["The Court once sold little devotional copies of those Binding marks. I have two, if you enjoy terrible irony.","The originals were not devotional at all, of course. People decorate what frightens them after enough generations." ]},
		{"id":"peddler_bloodline","npc":"peddler","loc_key":"strand.peddler.bloodline","requires_awakened":true,"min_bindings":3,"max_bindings":3,"lines":["Royal provenance does improve a price, though I suspect you would object to the listing.","Relax. I have no buyer for a bloodline. The island already tried turning people into inventory once." ]},
		{"id":"peddler_five_bindings","npc":"peddler","loc_key":"strand.peddler.five_bindings","requires_awakened":true,"min_bindings":5,"max_bindings":5,"lines":["More objects are washing up without owners, and fewer still feel entirely dead in the hand.","Catastrophe is very good for stock and very bad for business. Eventually there is nobody left to sell to." ]},
		{"id":"peddler_pre_heart","npc":"peddler","loc_key":"strand.peddler.pre_heart","requires_awakened":true,"min_bindings":6,"max_bindings":6,"pre_heart":true,"lines":["No sales pitch tonight. You already know what every useful thing here costs.","Bring yourself back if you can. The dead leave excellent merchandise, but I would prefer not to add yours to the table." ]},
	]


static func reactive_line_sets() -> Array[Dictionary]:
	return [
		{"id":"keeper_failed_hushiro","npc":"keeper","event":"failed_hushiro","lines":["The island does not measure resolve by distance. Cross again when your purpose is steady."]},
		{"id":"keeper_failed_late","npc":"keeper","event":"failed_late","lines":["You returned with the Court still ahead of you. The threshold remains. So does the work."]},
		{"id":"keeper_postgame","npc":"keeper","event":"story_complete","lines":["The pulse remains, faint but stubborn. What mattered is gone from it: the curse has no road to anyone new."]},
		{"id":"keeper_suppression","npc":"keeper","event":"suppression_clear","lines":["It regrew enough to threaten the island, and you cut it back again. That is containment now."]},
		{"id":"scribe_discovery","npc":"scribe","event":"discovery","lines":["Leave it with me. I will mark what is observed and keep the guesses separate."]},
		{"id":"scribe_boss","npc":"scribe","event":"boss_clear","lines":["Another account now has evidence behind it. I prefer corrections made by survivors."]},
		{"id":"scribe_postgame","npc":"scribe","event":"story_complete","lines":["The tissue regenerates. The exchange does not. No sample has produced new Beast Blood since the Heart was crippled."]},
		{"id":"scribe_record","npc":"scribe","event":"personal_best","lines":["A cleaner crossing than your last. I recorded the time, not because speed is the mission, but because mastery deserves evidence."]},
		{"id":"raven_failed","npc":"raven","event":"failed_run","notice":true,"lines":["ORDER NOTICE — Return confirmed. Mission remains active."]},
		{"id":"raven_reward","npc":"raven","event":"reward","notice":true,"lines":["ORDER NOTICE — Recovered service token attached. Receipt acknowledged by continued duty."]},
		{"id":"raven_postgame","npc":"raven","event":"story_complete","notice":true,"lines":["ORDER NOTICE — Mainland propagation threat: ended. Island containment watch: continuing."]},
		{"id":"raven_suppression","npc":"raven","event":"suppression_clear","notice":true,"lines":["ORDER NOTICE — Heart regrowth suppressed. No new bearer event detected."]},
		{"id":"samurai_failed","npc":"undead_samurai","event":"failed_run","lines":["You returned. Correct the mistake before memory turns it into habit."]},
		{"id":"samurai_mastery","npc":"undead_samurai","event":"mastery","lines":["Better. Do it again without needing praise to recognize the difference."]},
		{"id":"samurai_postgame","npc":"undead_samurai","event":"story_complete","lines":["The war changed shape. Discipline does not require the enemy to remain the same."]},
		{"id":"samurai_suppression","npc":"undead_samurai","event":"suppression_clear","lines":["A recurring enemy is still an enemy. Repetition is where poor form hides."]},
		{"id":"smith_prosthetic","npc":"smith","event":"prosthetic_upgrade","lines":["That will hold. Use it until the island proves me wrong."]},
		{"id":"smith_relic","npc":"smith","event":"relic_mastery","lines":["You've stopped carrying it like salvage. Good. Tools work better when the hand knows their weight."]},
		{"id":"smith_postgame","npc":"smith","event":"story_complete","lines":["Nothing in your gear lost its Blood when the Heart fell. Existing material stayed existing material. Useful distinction."]},
		{"id":"smith_suppression","npc":"smith","event":"suppression_clear","lines":["Same repairs as last time. That is better news than it sounds."]},
		{"id":"peddler_purchase","npc":"peddler","event":"purchase","lines":["A sensible choice. I say that about the things I would like you to buy, but this time it happens to be true."]},
		{"id":"peddler_discovery","npc":"peddler","event":"discovery","lines":["I have seen its kind before. Usually after the previous owner stopped objecting to the sale."]},
		{"id":"peddler_postgame","npc":"peddler","event":"story_complete","lines":["No new curse, but all the old cursed things remain. Fortunately, I already have a pricing system for that."]},
		{"id":"peddler_suppression","npc":"peddler","event":"suppression_clear","lines":["The Heart keeps growing back just enough to be troublesome. A remarkably poor sense of market demand."]},
	]


static func lore_records() -> Array[Dictionary]:
	return [
		{"id":"record_plague_year","title":"The Plague Year","loc_key":"records.plague_year","category":"History","body":"Court ledgers describe a sickness that crossed rank and district faster than ordinary medicine could answer. The Shogun's first authorization of Heart research came while the kingdom faced genuine extinction, before Beast Blood's long cost was understood."},
		{"id":"record_first_extraction","title":"First Extraction","loc_key":"records.first_extraction","category":"Heart","body":"Researchers breached the outermost of seven ancient restraints and built an exchange apparatus against the exposed Heart. Human blood was offered inward. Beast Blood returned outward. The apparatus belonged to the Court; the Heart and its prison did not."},
		{"id":"record_seven_bindings","title":"Seven Bindings","loc_key":"records.seven_bindings","category":"Heart","body":"The ancient complex held seven restraints around the Heart. The Court destroyed the first to begin extraction. Six survived into Akio's campaign, each older than the kingdom that mistook the prison for a resource."},
		{"id":"record_beast_blood_spread","title":"The Cure Spreads","loc_key":"records.cure_spreads","category":"History","body":"Beast Blood cured the plague quickly enough to become policy before corruption became undeniable. Once established inside a bearer, it no longer required fresh doses to sustain its healing, longevity, mutation, or regenerative effects."},
		{"id":"record_containment","title":"Containment","loc_key":"records.containment","category":"Order","body":"When the transformed kingdom became a threat beyond the island, survivors and outside allies built the containment tradition that later became the Order. The barrier controls passage. It does not cleanse the people trapped within it."},
		{"id":"record_keeper_oath","title":"The Keeper's Oath","loc_key":"records.keeper_oath","category":"Strand","body":"A noble of the old Court remained at the shoreline during containment and bound his spirit to the threshold rites. He does not power the whole barrier; he preserves the controlled crossing the Boat still uses beneath the Blood Moon."},
		{"id":"record_escaped_child","title":"The Escaped Child","loc_key":"records.escaped_child","category":"Bloodline","body":"Fragments agree that a royal child left the island before the barrier closed. The child's name, gender, escort, route, and later life are absent or contradictory. The surviving line eventually reached Akio."},
		{"id":"record_returning_blood","title":"Returning Blood","loc_key":"records.returning_blood","category":"Blood","body":"Akio's first death awakened an unprecedented Beast Blood expression. It reconstructs him while preserving the capacity to resist the Heart, change Blood expression, and return toward baseline. The Strand calls this Returning Blood."},
		{"id":"record_false_mastery","title":"False Mastery","loc_key":"records.false_mastery","category":"Shogun","body":"The Eclipse Shogun can direct mutation and retain intelligence, but his control has a boundary he refuses to see: he cannot willingly abandon the Heart, Beast Blood, his claim to rule, or the promise of escaping natural death."},
		{"id":"record_order_crossings","title":"One-Way Crossings","loc_key":"records.order_crossings","category":"Order","body":"Before Akio, Order warriors crossed expecting no return. The Strand kept names, equipment lists, and final notices because the barrier mission was built around sacrifice, not extraction or rescue."},
		{"id":"record_hushiro","title":"Hushiro Village","loc_key":"records.hushiro","category":"Region","body":"Hushiro preserves the shape of ordinary life more clearly than the deeper island. Homes, roads, kennels, and watch positions became a battlefield slowly enough that routine survived alongside corruption."},
		{"id":"record_yomori","title":"Yomori Grove","loc_key":"records.yomori","category":"Region","body":"The Hunting Grounds grew into a place where altered ecology and old ritual paths overlap. The region is not simply wilderness reclaimed from people; it is a landscape that learned to live around Beast Blood."},
		{"id":"record_kagutsuchi","title":"Kagutsuchi Court","loc_key":"records.kagutsuchi","category":"Region","body":"The Court remains organized because Beast Blood did not erase memory, hierarchy, or skill. Its surviving discipline is evidence against the comforting idea that every corrupted bearer became a mindless victim."},
		{"id":"record_keeper_gate","title":"Keeper of the Gate","loc_key":"records.keeper_gate","category":"Boss","body":"Hushiro's guardian still enforces a threshold long after the kingdom it served ceased to function normally. Defeating it opens the route deeper into the island; it does not end the systems that produced it."},
		{"id":"record_twin_maws","title":"Twin Maws","loc_key":"records.twin_maws","category":"Boss","body":"The Hunting Grounds culminate in a paired threat shaped by the region's predatory ecology. Their defeat marks passage from the altered wilds toward the political center that chose to preserve Beast Blood."},
		{"id":"record_eclipse_shogun","title":"Eclipse Shogun","loc_key":"records.eclipse_shogun","category":"Shogun","body":"The Shogun was once a capable ruler who used the Heart during a real plague. Understanding that origin does not absolve what followed: he continued extraction after the cost was clear and now intends to force his salvation beyond the island."},
		{"id":"record_blood_lotus","title":"Blood Lotus","loc_key":"records.blood_lotus","category":"Enemy","body":"Court growth and ritual practice meet in the Blood Lotus, a living defense whose beauty depends on the same Blood economy that transformed the kingdom. Destroying it reveals how thoroughly the Court made corruption ceremonial."},
		{"id":"record_eternal_swordsman","title":"Eternal Swordsman","loc_key":"records.eternal_swordsman","category":"Enemy","body":"Some warriors treated endless life as an extension of training rather than a cure. The Eternal Swordsman is what remains when discipline survives but no longer accepts death as the natural end of mastery."},
		{"id":"record_relic_provenance","title":"Relics and Owners","loc_key":"records.relic_provenance","category":"Artifacts","body":"Most Relics were not forged as abstract upgrades. They were possessions, tools, vows, trophies, or salvage before they became part of Akio's build. The Peddler remembers provenance more readily than reverence."},
		{"id":"record_prosthetic_craft","title":"Working Cursed Material","loc_key":"records.prosthetic_craft","category":"Artifacts","body":"The Smith treats Blood-reactive components as material rather than sacrament. His notes repeatedly favor reliable tolerances, replaceable parts, and observed behavior over theories about what an artifact wants."},
		{"id":"record_blood_aspects","title":"Blood Aspects","loc_key":"records.blood_aspects","category":"Blood","body":"Returning Blood can take distinct combat expressions without permanently fixing Akio into one form. Wolf, Wraith, and Ronin are controlled patterns of use, not separate bloodlines or personalities."},
		{"id":"record_heart_rejection","title":"Rejection","loc_key":"records.heart_rejection","category":"Heart","body":"When Akio offers Returning Blood to the Heart, the source attempts reclamation. Returning Blood rejects that authority. The conflict ruptures a Binding and destroys Akio's current body, but the permanent damage remains after reconstruction."},
		{"id":"record_unbound_heart","title":"The Unbound Heart","loc_key":"records.unbound_heart","category":"Heart","body":"After the sixth remaining Binding breaks, the Heart has no ancient restraint left between its manifested body and the Court. The next successful Shogun clear therefore continues below instead of ending at the throne."},
		{"id":"record_after_heart","title":"After the Heart","loc_key":"records.after_heart","category":"Postgame","body":"The canonical victory does not erase the Heart or existing Beast Blood. It permanently destroys the source's ability to create or release new Beast Blood. The remnant can regrow tissue, so Akio's postgame work becomes containment and suppression."},
	]


static func achievements() -> Array[Dictionary]:
	return [
		{"id":"first_return","name":"Returned","loc_key":"achievement.first_return","description":"Awaken Returning Blood for the first time.","trigger":"returning_blood_awakened"},
		{"id":"keeper_fallen","name":"Open the Way","loc_key":"achievement.keeper_fallen","description":"Defeat the Keeper of the Gate.","trigger":"boss_clear_1"},
		{"id":"twin_maws_fallen","name":"Through the Hunting Grounds","loc_key":"achievement.twin_maws_fallen","description":"Defeat Twin Maws.","trigger":"boss_clear_2"},
		{"id":"shogun_fallen","name":"The Throne Bleeds","loc_key":"achievement.shogun_fallen","description":"Defeat the Eclipse Shogun.","trigger":"boss_clear_3"},
		{"id":"binding_one","name":"First Rupture","loc_key":"achievement.binding_one","description":"Destroy your first remaining Heart Binding.","trigger":"bindings_1"},
		{"id":"binding_three","name":"Half Unbound","loc_key":"achievement.binding_three","description":"Destroy three remaining Heart Bindings.","trigger":"bindings_3"},
		{"id":"binding_six","name":"Nothing Left to Hold It","loc_key":"achievement.binding_six","description":"Destroy all six remaining Heart Bindings.","trigger":"bindings_6"},
		{"id":"story_complete","name":"Oathbound","loc_key":"achievement.story_complete","description":"Cripple the Heart and complete the main story.","trigger":"story_complete"},
		{"id":"first_standard","name":"Another Crossing","loc_key":"achievement.first_standard","description":"Complete a postgame Standard Expedition.","trigger":"standard_clears_1"},
		{"id":"first_suppression","name":"Containment","loc_key":"achievement.first_suppression","description":"Complete a Heart Suppression run.","trigger":"suppression_clears_1"},
		{"id":"wolf_heart","name":"Wolf at the Heart","loc_key":"achievement.wolf_heart","description":"Defeat the Heart with Wolf selected.","trigger":"heart_clear_wolf"},
		{"id":"wraith_heart","name":"Wraith at the Heart","loc_key":"achievement.wraith_heart","description":"Defeat the Heart with Wraith selected.","trigger":"heart_clear_wraith"},
		{"id":"ronin_heart","name":"Ronin at the Heart","loc_key":"achievement.ronin_heart","description":"Defeat the Heart with Ronin selected.","trigger":"heart_clear_ronin"},
		{"id":"three_aspects_heart","name":"Three Ways to Refuse","loc_key":"achievement.three_aspects_heart","description":"Defeat the Heart with Wolf, Wraith, and Ronin.","trigger":"heart_clear_all_aspects"},
		{"id":"bloodwell_first","name":"Permanent Mark","loc_key":"achievement.bloodwell_first","description":"Purchase your first Bloodwell node.","trigger":"bloodwell_nodes_1"},
		{"id":"bloodwell_all","name":"Well Prepared","loc_key":"achievement.bloodwell_all","description":"Purchase all 18 Bloodwell nodes.","trigger":"bloodwell_nodes_18"},
		{"id":"mirror_first","name":"Know Your Blood","loc_key":"achievement.mirror_first","description":"Complete your first Blood Mirror node.","trigger":"mirror_nodes_1"},
		{"id":"mirror_all","name":"Every Reflection","loc_key":"achievement.mirror_all","description":"Complete all 9 Blood Mirror nodes.","trigger":"mirror_nodes_9"},
		{"id":"prosthetics_all","name":"Eight Answers","loc_key":"achievement.prosthetics_all","description":"Unlock all 8 Prosthetics.","trigger":"prosthetics_8"},
		{"id":"prosthetic_upgrades_all","name":"Nothing Wasted","loc_key":"achievement.prosthetic_upgrades_all","description":"Purchase all 19 Prosthetic upgrades.","trigger":"prosthetic_upgrades_19"},
		{"id":"relics_all","name":"What the Island Left","loc_key":"achievement.relics_all","description":"Collect all 9 currently obtainable Relics.","trigger":"relics_9"},
		{"id":"relic_mastery_first","name":"Familiar Weight","loc_key":"achievement.relic_mastery_first","description":"Complete a Relic mastery milestone.","trigger":"relic_masteries_1"},
		{"id":"relic_mastery_all","name":"Nine Histories, Mastered","loc_key":"achievement.relic_mastery_all","description":"Complete all 18 mastery milestones for currently obtainable Relics.","trigger":"relic_masteries_18"},
		{"id":"techniques_ten","name":"A Growing Vocabulary","loc_key":"achievement.techniques_ten","description":"Discover 10 Techniques or refinements.","trigger":"technique_records_10"},
		{"id":"techniques_all","name":"Complete Vocabulary","loc_key":"achievement.techniques_all","description":"Record all 50 Techniques and 10 refinements.","trigger":"technique_records_60"},
		{"id":"trial_first","name":"Tested","loc_key":"achievement.trial_first","description":"Complete a required Blood Cavern or Blood Mirror trial.","trigger":"trials_1"},
		{"id":"trials_all","name":"No Lesson Left","loc_key":"achievement.trials_all","description":"Complete all required launch trials.","trigger":"trials_all"},
		{"id":"records_all","name":"What Remains Written","loc_key":"achievement.records_all","description":"Complete the required Discovery Board collection.","trigger":"records_all"},
		{"id":"miniboss_hunter","name":"Named Threats","loc_key":"achievement.miniboss_hunter","description":"Defeat every launch miniboss at least once.","trigger":"miniboss_roster_clear"},
		{"id":"completion_100","name":"The Whole Oath","loc_key":"achievement.completion_100","description":"Reach 100% Completion.","trigger":"completion_100"},
	]


static func help_topics() -> Array[Dictionary]:
	return [
		{"id":"combat_basics","title":"Combat","loc_key":"help.combat","body":"Attack to pressure Health and Posture. Deflect enemy attacks with precise parry timing, or hold your guard when certainty matters more than momentum. Full enemy Posture creates a stagger and then a brief Deathblow opportunity."},
		{"id":"perilous_attacks","title":"Perilous Attacks","loc_key":"help.perilous","body":"Red perilous warnings identify attacks that should not be treated like ordinary blockable strikes. Read the enemy's motion and use the appropriate movement, spacing, or response instead of relying on guard."},
		{"id":"dash","title":"Dash","loc_key":"help.dash","body":"Dash is a positioning tool, not a replacement for reading attacks. Use it to clear dangerous space, reposition around enemy pressure, or create the angle your current build needs."},
		{"id":"posture_deathblow","title":"Posture and Deathblow","loc_key":"help.posture","body":"Enemy Posture rises through pressure and successful defensive reads. When it fills, the enemy visibly staggers before Deathblow readiness arms. Use that beat to confirm the break and execute cleanly."},
		{"id":"spirit_prosthetic","title":"Spirit and Prosthetics","loc_key":"help.spirit","body":"Your equipped Prosthetic spends Spirit. Different tools solve different combat problems, and permanent Forge upgrades improve them across future crossings."},
		{"id":"returning_blood","title":"Returning Blood","loc_key":"help.returning_blood","body":"After the first death, Returning Blood allows Akio to reconstruct at the Strand and wield controlled Blood Aspects. It also enables the campaign's permanent Heart Binding progress."},
		{"id":"blood_aspects","title":"Blood Aspects","loc_key":"help.aspects","body":"Wolf, Wraith, and Ronin are three controlled expressions of Returning Blood. Choose one before an awakened run and build around its weapon identity, Blood generation, and Blood Art."},
		{"id":"techniques","title":"Techniques","loc_key":"help.techniques","body":"Techniques modify attacks, defense, movement, Prosthetic use, and build interactions. Major combat-action labels describe triggers, not equipment slots. Your run Technique collection has no global slot cap, and multiple Techniques can respond to the same action."},
		{"id":"corruption_shrines","title":"Corruption and Shrines","loc_key":"help.corruption","body":"Corruption rises through the run after Returning Blood awakens. Shrines let you Resist, Embrace deeper Aspect expression, Stabilize at the appropriate tier, or take support according to the current Shrine state."},
		{"id":"run_structure","title":"The Crossing","loc_key":"help.run_structure","body":"A full route travels Hushiro, Yomori, then Kagutsuchi. Room choices shape rewards and risk. Successful campaign clears progress Heart Bindings; after Story Complete, the Boat offers Standard Expedition and Heart Suppression goals."},
		{"id":"persistent_progress","title":"The Strand","loc_key":"help.strand","body":"Mist, Scrolls, and regional boss materials persist between runs. The Bloodwell, Forge Bench, and Blood Mirror own permanent progression. The Discovery Board records what Akio and the Strand have learned."},
		{"id":"heart_postgame","title":"After Story Complete","loc_key":"help.postgame","body":"The Heart survives only as a contained regenerating remnant. It cannot create or spread new Beast Blood. Standard Expedition ends at the Shogun; Heart Suppression continues below to destroy dangerous regrowth."},
	]


static func ending_sequence() -> Array[Dictionary]:
	return [
		{"id":"ending_heart_falls","speaker":"","loc_key":"ending.heart_falls","text":"The manifested Heart collapses. The extraction apparatus fails with it, and the exchange that once released Beast Blood goes silent."},
		{"id":"ending_influence_contracts","speaker":"","loc_key":"ending.influence_contracts","text":"Its wider influence contracts toward a faint surviving pulse. The island is not cleansed. The source is crippled."},
		{"id":"ending_blood_remains","speaker":"","loc_key":"ending.blood_remains","text":"Returning Blood still moves through Akio. Existing bearers remain what they have become. No new bearer can ever be made."},
		{"id":"ending_core","speaker":"","loc_key":"ending.core","text":ENDING_CORE_MESSAGE},
	]


static func postgame_explanation() -> Array[Dictionary]:
	return [
		{"id":"postgame_keeper","speaker":"Keeper","loc_key":"postgame.keeper","lines":["The Heart still pulses beneath the Court. Faintly. Enough to regrow flesh, never enough to spread its old curse.","The barrier now contains what already exists. Your crossings are no longer a race against a new kingdom. They are the work of keeping this one from becoming dangerous again."]},
		{"id":"postgame_scribe","speaker":"Scribe","loc_key":"postgame.scribe","lines":["I have compared every sample we can safely observe. Existing Beast Blood still heals and reconstructs its bearers.","But the Heart has produced nothing new since you crippled it. Tissue returns. Propagation does not. That distinction is the ending we needed."]},
	]
