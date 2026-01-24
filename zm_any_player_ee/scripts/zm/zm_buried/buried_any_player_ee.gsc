#include common_scripts\utility;
#include maps\mp\zm_buried_sq_ip;
#include maps\mp\zombies\_zm_utility;

init()
{
	if ( maps\mp\zombies\_zm_sidequests::is_sidequest_allowed( "zclassic" ) )
	{
		thread onPlayerConnect();
		thread sidequest_main();
	}
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill( "connected", player );
		player thread msg();
	}
}

msg()
{
	self endon( "disconnect" );
	flag_wait( "initial_players_connected" );
	self iPrintLn( "^2Any Player EE Mod ^5Buried" );
}

sidequest_main()
{
	flag_wait( "start_zombie_round_logic" );
	waittillframeend;

	if ( level.maxcompleted && level.richcompleted )
	{
		return;
	}

	level waittill( "sq" + "_" + "ts" + "_started" );
	ctw();
	thread tpo();
	level waittill( "sq" + "_" + "ip" + "_started" );
	thread ip();
	level waittill( "sq" + "_" + "ows" + "_started" );
	thread ows();
}

ctw()
{
	while ( !flag( "sq_wisp_success" ) )
	{
		level waittill( "sq" + "_" + "ctw" + "_started" );
		thread ctw_max_wisp_enery_watch();
		level waittill( "sq_ctw_over" );
	}
}

ctw_max_wisp_enery_watch()
{
	waittillframeend;
	level endon( "sq_wisp_failed" );

	if ( flag( "sq_is_max_tower_built" ) )
	{
		while ( !isdefined( level.vh_wisp ) )
		{
			wait 1;
		}

		level.vh_wisp thread health_add();
	}
}

health_add()
{
	self endon( "death" );

	if ( level.players.size < 3 )
	{
		for (;;)
		{
			if ( self.n_sq_energy <= 20 )
			{
				self.n_sq_energy += 10;
			}

			wait 1;
		}
	}
}

tpo()
{
	if ( flag( "sq_is_ric_tower_built" ) )
	{
		level endon( "sq_tpo_generator_powered" );
		e_time_bomb_volume = getent( "sq_tpo_timebomb_volume", "targetname" );

		for (;;)
		{
			flag_wait( "sq_tpo_time_bomb_in_valid_location" );
			thread sq_tpo_check_players_in_time_bomb_volume( e_time_bomb_volume );
			level waittill( "sq_tpo_stop_checking_time_bomb_volume" );

			if ( flag( "time_bomb_restore_active" ) && flag( "sq_tpo_players_in_position_for_time_warp" ) )
			{
				level waittill( "sq_tpo_special_round_ended" );
			}

			wait_network_frame();
			waittillframeend;
		}
	}
	else if ( flag( "sq_is_max_tower_built" ) )
	{
		flag_wait( "sq_wisp_saved_with_time_bomb" );
		ctw();
	}
}

sq_tpo_check_players_in_time_bomb_volume( e_volume )
{
	level endon( "sq_tpo_stop_checking_time_bomb_volume" );

	for (;;)
	{
		flag_waitopen( "sq_tpo_players_in_position_for_time_warp" );

		if ( get_players().size < 4 && _are_all_players_in_time_bomb_volume( e_volume ) )
		{
			level._time_bomb.functionality_override = 1;
			flag_set( "sq_tpo_players_in_position_for_time_warp" );
		}
		else
		{
			wait 0.25;
		}
	}
}

_are_all_players_in_time_bomb_volume( e_volume )
{
	n_required_players = get_players().size;
	n_players_in_position = 0;

	foreach ( player in get_players() )
	{
		if ( player istouching( e_volume ) )
			n_players_in_position++;
	}

	return n_players_in_position == n_required_players;
}

ip()
{
	level endon( "sq_ip_over" );

	if ( flag( "sq_is_max_tower_built" ) )
	{
		while ( !flag( "sq_ip_puzzle_complete" ) )
		{
			sq_bp_start_puzzle_lights();
		}
	}
}

sq_bp_start_puzzle_lights()
{
	level endon( "sq_ip_over" );
	level endon( "sq_bp_wrong_button" );
	a_button_structs = getstructarray( "sq_bp_button", "targetname" );
	a_tags = [];

	foreach ( m_button in a_button_structs )
		a_tags[a_tags.size] = m_button.script_string;

	a_tags = array_randomize( a_tags );

	while ( !isdefined( level.t_start ) )
	{
		waittillframeend;
	}

	level.t_start waittill( "trigger" );

	if ( level.players.size < 3 )
	{
		level delay_notify( "sq_bp_timeout", 0.05 );
	}
	else
	{
		return;
	}

	foreach ( str_tag in a_tags )
	{
		wait_network_frame();
		wait_network_frame();
		level thread sq_bp_set_current_bulb( str_tag );
		level waittill( "sq_bp_correct_button" );
	}

	flag_set( "sq_ip_puzzle_complete" );
	a_button_structs = getstructarray( "sq_bp_button", "targetname" );

	foreach ( s_button in a_button_structs )
	{
		if ( isdefined( s_button.trig ) )
			s_button.trig delete();
	}

	if ( isdefined( level.t_start ) )
	{
		level.t_start delete();
		level notify( "sq_bp_timeout" );
	}
}

sq_bp_set_current_bulb( str_tag )
{
	level endon( "sq_bp_correct_button" );
	level endon( "sq_bp_wrong_button" );
	level endon( "sq_bp_timeout" );

	if ( isdefined( level.m_sq_bp_active_light ) )
		level.str_sq_bp_active_light = "";

	level.m_sq_bp_active_light = sq_bp_light_on( str_tag, "yellow" );
	level.str_sq_bp_active_light = str_tag;
}

ows()
{
	while ( !flag( "sq_ows_success" ) )
	{
		flag_wait( "sq_ows_start" );
		ows_target_delete_timer();
		flag_waitopen( "sq_ows_start" );
	}
}

ows_target_delete_timer()
{
	level endon( "sndEndOWSMusic" );

	switch ( level.players.size )
	{
		case 1:
			zmb_sq_target_flip = 64; // Total (84) - ( Candy Shop (20) )
			break;
		case 2:
			zmb_sq_target_flip = 45; // Total (84) - ( Candy Shop (20) + Saloon (19) )
			break;
		default: //All 4 areas of the map
			zmb_sq_target_flip = 0;
			break;
	}

	while ( zmb_sq_target_flip > 0 )
	{
		flag_wait( "sq_ows_target_missed" );
		flag_clear( "sq_ows_target_missed" );
		zmb_sq_target_flip--;
	}
}
