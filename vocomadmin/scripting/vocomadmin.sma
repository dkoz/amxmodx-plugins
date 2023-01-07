/*
*
*Plugin: VocomAdmin
*By: Nut (www.necrophix.com)
*
*
*Description:
*
*This plugin allows admins (who have the required access level) to bind a key to +adminvoice and chat via
*vocom to other admins, regular players (or admins who don't have the required listen level) can not hear the voice chat.
*
*This plugin is based off the idea by KCE (http://www.nsmod.org/forums/index.php?s=&showtopic=2172&view=findpost&p=23204)
*and Zor (http://forums.alliedmods.net/showthread.php?t=2400).
*
*The modified code snipplet comes from watch (http://forums.alliedmods.net/showpost.php?p=371898&postcount=9) who's idea on 
*how to get around the set_client_listening() bug, made this plugin possibe.
*
*Version:
*
*v0.1 - v0.8 - Basic plugin functionality coded.
*v0.9 - Added abilitiy to define what admin level you want for talk/listen
*v1.0 - inital release
*v1.1 - fixed non admins being able to see chat
*v1.2 - fixed people being able to see "is talking to admin" by non admins.
*v1.3 - fixed admin level problems by checking it once and storing it.
*v1.4 - removed some unneeded things (dont develop 2 plugins at the same time lol) cleaned up code
*/

#include <amxmodx>
#include <amxmisc>
#include <fakemeta>

#define PLUGIN "VocomAdmin"
#define VERSION "1.3"
#define AUTHOR "Nut"

//defines for speak flags, ADMIN helps tell speak apart easier
#define SPEAK_MUTED	0
#define SPEAK_NORMAL	1
#define SPEAK_ALL	2
#define SPEAK_ADMIN	5

//what admin level is required?
#define ADMIN_LEVEL ADMIN_BAN

new g_playerspk[33]
new g_admin[33]
new players[32]
new pCount

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_cvar(PLUGIN, VERSION, FCVAR_SERVER)
	register_forward(FM_Voice_SetClientListening, "fm_mute_forward")
	register_clcmd("+adminvoice", "vocomStart")
	register_clcmd("-adminvoice", "vocomStop")
}

public client_connect(id) {
	set_speak(id,SPEAK_NORMAL)
	g_admin[id] = 0				//just incase, but client_auth gets called after this anyway.
}

//this is called after client connect.  Caused problems with admin check because 
//AMXX doesnt authorize on client connect... hence this event.
public client_authorized(id) {  
	if (get_user_flags(id) & ADMIN_LEVEL) { 
		g_admin[id] = 1
	}
}

//player has left, lets reset this info for the next player
public client_disconnect(id) {
	if (g_admin[id]) {
		set_speak(id,SPEAK_NORMAL)
		g_admin[id] = 0
	}
}

public fm_mute_forward(receiver, sender, listen) {
	if (receiver == sender) return FMRES_IGNORED
	if (get_speak(sender) == SPEAK_ADMIN) {
		
		if (g_admin[receiver] == 1) {
			engfunc(EngFunc_SetClientListening, receiver, sender, SPEAK_NORMAL)
		}else{
			engfunc(EngFunc_SetClientListening, receiver, sender, SPEAK_MUTED)
		}

		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED
}

public set_speak(id,listen) {
	g_playerspk[id] = listen
}

public get_speak(id) {
	return g_playerspk[id]
}

public vocomStart(id) {
	if (!g_admin[id]) {
		client_print(id,print_chat,"[AMXX]: You have no access to this command.")
		return PLUGIN_HANDLED
	}

	client_cmd(id,"+voicerecord")
	set_speak(id,SPEAK_ADMIN)
	new name[33]
	get_user_name(id,name,32)

	get_players(players, pCount, "c") 
	for (new i = 0; i < pCount; i++) {
		if (g_admin[i]) {
			if (i != id) {
				client_print(i,print_chat,"[AMXX]: %s is speaking to the other admins.",name)
			}
		}	
	}
	
	client_print(id,print_chat,"[AMXX]: You are speaking to the admins.",name)
	return PLUGIN_HANDLED
}

public vocomStop(id) {
	if(is_user_connected(id)) { 			//people who are disconnected shouldn't get this far, but it might give a runtime error
		client_cmd(id,"-voicerecord")
		if(get_speak(id) == SPEAK_ADMIN) {
			set_speak(id,SPEAK_NORMAL)
		}
	}
	return PLUGIN_HANDLED
}
