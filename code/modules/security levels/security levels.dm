GLOBAL_VAR_INIT(security_level, SEC_LEVEL_GREEN)
//0 = code green
//1 = code blue
//2 = code yellow
//3 = code violet
//4 = code orange
//5 = code red
//6 = code delta

//config_legacy.alert_desc_blue_downto
/var/datum/legacy_announcement/priority/security/security_announcement_up = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/effects/alert_levels/alert_raise.ogg'))
/var/datum/legacy_announcement/priority/security/security_announcement_down = new(do_log = 0, do_newscast = 1)

/proc/set_security_level(var/level)
	switch(level)
		if("green")
			level = SEC_LEVEL_GREEN
		if("blue")
			level = SEC_LEVEL_BLUE
		if("yellow")
			level = SEC_LEVEL_YELLOW
		if("violet")
			level = SEC_LEVEL_VIOLET
		if("orange")
			level = SEC_LEVEL_ORANGE
		if("red")
			level = SEC_LEVEL_RED
		if("delta")
			level = SEC_LEVEL_DELTA

	//Will not be announced if you try to set to the same level as it already is. Also To-Do. Add multi sound support for alerts..
	if(level >= SEC_LEVEL_GREEN && level <= SEC_LEVEL_DELTA && level != GLOB.security_level)
		switch(level)
			if(SEC_LEVEL_GREEN)
				security_announcement_down.Announce("[CONFIG_GET(string/alert_desc_green)]", "Attention! Alert level lowered to code green.")
				GLOB.security_level = SEC_LEVEL_GREEN
			if(SEC_LEVEL_BLUE)
				if(GLOB.security_level < SEC_LEVEL_BLUE)
					security_announcement_up.Announce("[CONFIG_GET(string/alert_desc_blue_upto)]", "Attention! Alert level elevated to blue", new_sound = 'sound/misc/voybluealert.ogg')
				else
					security_announcement_down.Announce("[CONFIG_GET(string/alert_desc_blue_downto)]", "Attention! Alert level lowered to blue", new_sound = 'sound/misc/voybluealert.ogg')
				GLOB.security_level = SEC_LEVEL_BLUE
			if(SEC_LEVEL_YELLOW)
				if(GLOB.security_level < SEC_LEVEL_YELLOW)
					security_announcement_up.Announce("[CONFIG_GET(string/alert_desc_yellow_upto)]", "Attention! Alert level elevated to yellow")
				else
					security_announcement_down.Announce("[CONFIG_GET(string/alert_desc_yellow_downto)]", "Attention! Alert level lowered to yellow")
				GLOB.security_level = SEC_LEVEL_YELLOW
			if(SEC_LEVEL_VIOLET)
				if(GLOB.security_level < SEC_LEVEL_VIOLET)
					security_announcement_up.Announce("[CONFIG_GET(string/alert_desc_violet_upto)]", "Attention! Alert level elevated to violet")
				else
					security_announcement_down.Announce("[CONFIG_GET(string/alert_desc_violet_downto)]", "Attention! Alert level lowered to violet")
				GLOB.security_level = SEC_LEVEL_VIOLET
			if(SEC_LEVEL_ORANGE)
				if(GLOB.security_level < SEC_LEVEL_ORANGE)
					security_announcement_up.Announce("[CONFIG_GET(string/alert_desc_orange_upto)]", "Attention! Alert level elevated to orange")
				else
					security_announcement_down.Announce("[CONFIG_GET(string/alert_desc_orange_downto)]", "Attention! Alert level lowered to orange")
				GLOB.security_level = SEC_LEVEL_ORANGE
			if(SEC_LEVEL_RED)
				if(GLOB.security_level < SEC_LEVEL_RED)
					security_announcement_up.Announce("[CONFIG_GET(string/alert_desc_red_upto)]", "Attention! Code red!", new_sound = 'sound/effects/alert_levels/red_alert.ogg')
				else
					security_announcement_down.Announce("[CONFIG_GET(string/alert_desc_red_downto)]", "Attention! Code red!", new_sound = 'sound/misc/voyalert.ogg')
				GLOB.security_level = SEC_LEVEL_RED
			if(SEC_LEVEL_DELTA)
				security_announcement_up.Announce("[CONFIG_GET(string/alert_desc_delta)]", "Attention! Delta alert level reached!", new_sound = 'sound/effects/alert_levels/deltaklaxon.ogg')
				GLOB.security_level = SEC_LEVEL_DELTA

		var/newlevel = get_security_level()
		for(var/obj/machinery/firealarm/FA in GLOB.machines)
			if(FA.z in (LEGACY_MAP_DATUM).contact_levels)
				FA.set_security_level(newlevel)
		for(var/obj/machinery/status_display/FA in GLOB.machines)
			if(FA.z in (LEGACY_MAP_DATUM).contact_levels)
				FA.display_alert(newlevel)
				FA.mode = 3

		if(level >= SEC_LEVEL_RED)
			if(SSlegacy_atc.squelched == FALSE) // Do nothing, ATC relay is already off
				SSlegacy_atc.toggle_broadcast()

		spawn()
			SSnightshift.check_nightshift()

		admin_chat_message(message = "Security level is now: [uppertext(get_security_level())]", color = "#CC2222")

/proc/get_security_level()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_YELLOW)
			return "yellow"
		if(SEC_LEVEL_VIOLET)
			return "violet"
		if(SEC_LEVEL_ORANGE)
			return "orange"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/num2seclevel(var/num)
	switch(num)
		if(SEC_LEVEL_GREEN)
			return "green"
		if(SEC_LEVEL_BLUE)
			return "blue"
		if(SEC_LEVEL_YELLOW)
			return "yellow"
		if(SEC_LEVEL_VIOLET)
			return "violet"
		if(SEC_LEVEL_ORANGE)
			return "orange"
		if(SEC_LEVEL_RED)
			return "red"
		if(SEC_LEVEL_DELTA)
			return "delta"

/proc/seclevel2num(var/seclevel)
	switch( lowertext(seclevel) )
		if("green")
			return SEC_LEVEL_GREEN
		if("blue")
			return SEC_LEVEL_BLUE
		if("yellow")
			return SEC_LEVEL_YELLOW
		if("violet")
			return SEC_LEVEL_VIOLET
		if("orange")
			return SEC_LEVEL_ORANGE
		if("red")
			return SEC_LEVEL_RED
		if("delta")
			return SEC_LEVEL_DELTA


/*DEBUG
/mob/verb/set_thing0()
	set_security_level(0)
/mob/verb/set_thing1()
	set_security_level(1)
/mob/verb/set_thing2()
	set_security_level(2)
/mob/verb/set_thing3()
	set_security_level(3)
/mob/verb/set_thing4()
	set_security_level(4)
/mob/verb/set_thing5()
	set_security_level(5)
/mob/verb/set_thing6()
	set_security_level(6)
*/
