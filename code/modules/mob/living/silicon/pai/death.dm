/mob/living/silicon/pai/death(gibbed)
	if(card)
		card.removePersonality()
		src.loc = get_turf(card)
		qdel(card)
	if(mind)
		qdel(mind)
	..(gibbed)
	ghostize()
	qdel(src)
