#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_buried_sq;
#include maps\mp\zm_buried_sq_ip;
#include maps\mp\zombies\_zm_utility;

init()
{
	if ( maps\mp\zombies\_zm_sidequests::is_sidequest_allowed( "zclassic" ) )
	{
		thread onPlayerConnect();
		thread sidequest_main();
		thread sq_metagame_on_player_connect();
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

sq_metagame_on_player_connect()
{
	for (;;)
	{
		if ( get_players().size != 4 )
		{
			thread sq_metagame();
		}

		level waittill( "sq_metagame_player_connected" );
	}
}

sq_metagame()
{
	level endon( "sq_metagame_player_connected" );
	flag_wait( "sq_intro_vo_done" );

	if ( flag( "sq_started" ) )
		level waittill( "buried_sidequest_achieved" );

	is_blue_on = 0;
	is_orange_on = 0;
	m_endgame_machine = getstruct( "sq_endgame_machine", "targetname" );
	a_stat = [];
	a_stat[0] = "sq_transit_last_completed";
	a_stat[1] = "sq_highrise_last_completed";
	a_stat[2] = "sq_buried_last_completed";
	a_stat_nav = [];
	a_stat_nav[0] = "navcard_applied_zm_transit";
	a_stat_nav[1] = "navcard_applied_zm_highrise";
	a_stat_nav[2] = "navcard_applied_zm_buried";
	bulb_on = [];
	bulb_on[0] = 0;
	bulb_on[1] = 0;
	bulb_on[2] = 0;
	flag_wait( "start_zombie_round_logic" );
	players = get_players();
	player_count = min( players.size, 4 ); //in case of more than 4 players, only checks the progress of 4 players

	for ( n_player = 0; n_player < player_count; n_player++ )
	{
		for ( n_stat = 0; n_stat < a_stat.size; n_stat++ )
		{
			if ( isdefined( players[n_player] ) )
			{
				n_stat_value = players[n_player] maps\mp\zombies\_zm_stats::get_global_stat( a_stat[n_stat] );
				n_stat_nav_value = players[n_player] maps\mp\zombies\_zm_stats::get_global_stat( a_stat_nav[n_stat] );
			}

			if ( n_stat_value == 1 )
			{
				is_blue_on = 1;
			}
			else if ( n_stat_value == 2 )
			{
				is_orange_on = 1;
			}

			if ( n_stat_nav_value )
			{
				bulb_on[n_stat] = 1;
			}
		}
	}

	if ( level.n_metagame_machine_lights_on != 12 && level.n_metagame_machine_lights_on == player_count * 3 ) //changed to adapt to the number of players
	{
		if ( is_blue_on && is_orange_on )
			return;
		else if ( !bulb_on[0] || !bulb_on[1] || !bulb_on[2] )
			return;
	}
	else
		return;

	m_endgame_machine.activate_trig = spawn( "trigger_radius", m_endgame_machine.origin, 0, 128, 72 );
	m_endgame_machine.activate_trig waittill( "trigger" );
	m_endgame_machine.activate_trig delete();
	m_endgame_machine.activate_trig = undefined;
	level setclientfield( "buried_sq_egm_animate", 1 );
	m_endgame_machine.endgame_trig = spawn( "trigger_radius_use", m_endgame_machine.origin, 0, 16, 16 );
	m_endgame_machine.endgame_trig setcursorhint( "HINT_NOICON" );
	m_endgame_machine.endgame_trig sethintstring( &"ZM_BURIED_SQ_EGM_BUT" );
	m_endgame_machine.endgame_trig triggerignoreteam();
	m_endgame_machine.endgame_trig usetriggerrequirelookat();
	m_endgame_machine.endgame_trig waittill( "trigger" );
	m_endgame_machine.endgame_trig delete();
	m_endgame_machine.endgame_trig = undefined;
	level thread sq_metagame_clear_tower_pieces();
	playsoundatposition( "zmb_endgame_mach_button", m_endgame_machine.origin );
	players = get_players();

	foreach ( player in players )
	{
		for ( i = 0; i < a_stat.size; i++ )
		{
			player maps\mp\zombies\_zm_stats::set_global_stat( a_stat[i], 0 );
			player maps\mp\zombies\_zm_stats::set_global_stat( a_stat_nav[i], 0 );
		}
	}

	sq_metagame_clear_lights();

	if ( is_orange_on )
		level notify( "end_game_reward_starts_maxis" );
	else
		level notify( "end_game_reward_starts_richtofen" );
}
