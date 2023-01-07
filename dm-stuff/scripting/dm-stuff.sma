/*
	This plugin overwrites the default CS:DM Advertisement.
*/

#include < amxmodx >
#include < csdm >

#define WELCOMEMSG_1    "[CSDM] This server is using CSDM, Have fun!"
#define WELCOMEMSG_2    "[CSDM] Visit www.yourwebsite.com!"

public plugin_init( ) csdm_set_intromsg( 0 );
public client_putinserver( id ) set_task( 15.0, "WelcomeMsg", id );

public WelcomeMsg( id ) {
    if( is_user_connected( id ) ) {
        client_print( id, print_chat, "%s", WELCOMEMSG_1 );
        client_print( id, print_chat, "%s", WELCOMEMSG_2 );
    }
} 