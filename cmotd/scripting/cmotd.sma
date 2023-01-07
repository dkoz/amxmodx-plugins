/*
	Custom Motd Beta by KoZ
*/

#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Custom Motd"
#define VERSION "1.0"
#define AUTHOR "KoZ"

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_clcmd("say","say_handle")
}

public say_handle(id)
{
	new buffer[256], buffer1[33]
	read_argv(1,buffer,255)
	parse(buffer, buffer1, 32)
	if(equali(buffer1,"/motd"))
	{
		show_motd(id,"motd.txt","Message of the Day")
		return PLUGIN_HANDLED
	}
	if(equali(buffer1,"/rules"))
	{
		motd_show(id,"rules")
		return PLUGIN_HANDLED
	}
	if(equali(buffer1,"/help"))
	{
		motd_show(id,"help")
		return PLUGIN_HANDLED
	}
	return PLUGIN_CONTINUE 
}

public motd_show(id,file[])
{
	new dir[256], addon[32]
	get_configsdir(dir,255)
	format(addon,31,"/cmotd/%s.txt",file)
	add(dir,255,addon)
	show_motd(id,dir,"Message of the Day")
}