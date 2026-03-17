#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_highrise_sq_pts;

init()
{
	if ( maps\mp\zombies\_zm_sidequests::is_sidequest_allowed( "zclassic" ) )
	{
		thread onPlayerConnect();

		if ( set_dvar_int_if_unset( "any_player_ee_highrise_nav", "1" ) )
		{
			thread spawn_navcomputer();
		}

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
	self iPrintLn( "^2Any Player EE Mod ^5Die Rise" );
}

//Force build navcard table
spawn_navcomputer()
{
	level.navcomputer_spawned = true;
	flag_wait( "start_zombie_round_logic" );
	waittillframeend;
	spawn_navcomputer = false;
	players = get_players();

	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] maps\mp\zombies\_zm_stats::get_global_stat( "sq_highrise_started" ) )
		{
			spawn_navcomputer = true;
			break;
		}
	}

	if ( !spawn_navcomputer )
		return;

	get_players()[0] maps\mp\zombies\_zm_buildables::player_finish_buildable( level.sq_buildable.buildablezone );

	if ( isdefined( level.sq_buildable ) && isdefined( level.sq_buildable.model ) )
	{
		buildable = level.sq_buildable.buildablezone;

		for ( i = 0; i < buildable.pieces.size; i++ )
		{
			if ( isdefined( buildable.pieces[i].model ) )
			{
				buildable.pieces[i].model delete();
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( buildable.pieces[i].unitrigger );
			}

			if ( isdefined( buildable.pieces[i].part_name ) )
			{
				buildable.stub.model notsolid();
				buildable.stub.model show();
				buildable.stub.model showpart( buildable.pieces[i].part_name );
			}
		}
	}
}

sidequest_main()
{
	flag_wait( "start_zombie_round_logic" );
	waittillframeend;

	if ( level.maxcompleted && level.richcompleted )
	{
		return;
	}

	flag_wait( "power_on" );
	flag_wait( "sq_nav_built" );
	thread atd();
	level waittill( "sq_slb_over" );

	if ( !level.richcompleted )
	{
		thread sq_1();
	}

	if ( !level.maxcompleted )
	{
		thread sq_2();
	}
}

//returns either the number of players or the number 4, whichever is less. Used for specific steps
num_player_valid( is_generator )
{
	n_players = level.players.size;

	if ( isdefined( is_generator ) && !is_generator && isdefined( level.pts_ghoul ) )
	{
		n_players = level.pts_ghoul;
	}

	return int( min( n_players, 4 ) );
}

atd()
{
	sq_atd_elevators();
	flag_wait( "sq_atd_elevator_activated" );

	while ( !isdefined( level.sq_atd_cur_drg ) )
	{
		wait 0.25;
		waittillframeend;
	}

	sq_atd_drg_puzzle();

	if ( num_player_valid() != 4 )
	{
		remove = false;

		if ( !flag( "sq_atd_drg_puzzle_1st_error" ) )
		{
			flag_set( "sq_atd_drg_puzzle_1st_error" );
			remove = true;
		}

		a_puzzle_trigs = getentarray( "trig_atd_drg_puzzle", "targetname" );

		for ( i = 0; i < a_puzzle_trigs.size; i++ )
		{
			if ( !a_puzzle_trigs[i].drg_active )
			{
				m_unlit = getent( a_puzzle_trigs[i].target, "targetname" );
				v_hidden = m_unlit.lit_icon.origin;
				m_unlit.lit_icon.origin = m_unlit.origin;
				m_unlit.origin = v_hidden;
				a_puzzle_trigs[i] notify( "trigger", level.players[0] );
				waittillframeend;
				level.sq_atd_cur_drg = 4;
			}
		}

		if ( remove )
		{
			flag_clear( "sq_atd_drg_puzzle_1st_error" );
		}
	}
}

//Elevator Stand step

//makes elevator symbols require as many symbols as players
sq_atd_elevators()
{
	a_elevator_flags = array( "sq_atd_elevator0", "sq_atd_elevator1", "sq_atd_elevator2", "sq_atd_elevator3" );

	while ( flag( a_elevator_flags[0] ) + flag( a_elevator_flags[1] ) + flag( a_elevator_flags[2] ) + flag( a_elevator_flags[3] ) < num_player_valid() ) //checks if the players are standing on enough elevators
	{
		flag_wait_any_array( a_elevator_flags );
		wait 0.5;
	}

	for ( i = 0; i < a_elevator_flags.size; i++ )
	{
		if ( !flag( a_elevator_flags[i] ) )
		{
			flag_set( a_elevator_flags[i] );
		}
	}
}

//Dragon Puzzle step

//initialises the floor symbols to require as many symbols as players
//when floor symbols reset, they reset back to require as many symbols as players
sq_atd_drg_puzzle()
{
	level endon( "sq_atd_drg_puzzle_complete" );

	for (;;)
	{
		level.sq_atd_cur_drg = 4 - num_player_valid();
		level waittill( "drg_puzzle_reset" );
	}
}

// Trample Steam steps

#define NOOP(__a,__b)
#define SQ_2_PLACE_BALL_TRIGGER_CLEANUP(__s_lion_spot) \
	if ( isdefined( __s_lion_spot.pts_putdown_trigs ) && __s_lion_spot.pts_putdown_trigs.size > 0 ) \
	{ \
		foreach ( t_putdown in __s_lion_spot.pts_putdown_trigs ) \
		{ \
			t_putdown notify( "delete" ); \
		} \
		\
		pts_putdown_trigs_remove_for_spot( __s_lion_spot ); \
	}

#define SQ_2_PLACE_BALL_THINK(__player,__s_lion_spot) \
	__player thread place_ball_think( __s_lion_spot.pts_putdown_trigs[__player.characterindex], __s_lion_spot );

#define SQ_2_TRAMPLE_STEAM_CREATE_TRIGS(__player,__s_lion_spot) \
	pts_putdown_trigs_create_for_spot( __s_lion_spot, __player ); \
	SQ_2_PLACE_BALL_THINK( __player, __s_lion_spot );

#define SQ_2_TRAMPLE_STEAM_BUDDY_ELSE_LOGIC(__player,__s_lion_spot_buddy) \
	else \
	{ \
		SQ_2_TRAMPLE_STEAM_CREATE_TRIGS( __player, __s_lion_spot_buddy ) \
	}

#define SQ_2_TRAMPLE_STEAM_CHECKS(__player,__s_lion_spot,__buddy_else_logic,__buddy_place_ball_think) \
	if ( isdefined( level.pts_lion ) && level.pts_lion < 4 ) \
	{ \
		if ( isdefined( __s_lion_spot.springpad_buddy.springpad ) || level.pts_lion == 1 || ( level.pts_lion == 3 && flag( "pts_2_generator_1_started" ) && !isdefined( __s_lion_spot.which_ball ) && !isdefined( __s_lion_spot.springpad_buddy.which_ball ) ) ) \
		{ \
			if ( !isdefined( __s_lion_spot.springpad_buddy.springpad ) ) \
			{ \
				maps\mp\zm_highrise_sq_pts::pts_putdown_trigs_create_for_spot( __s_lion_spot, __player ); \
			} \
			__buddy_else_logic( __player, __s_lion_spot.springpad_buddy ); \
			\
			SQ_2_TRAMPLE_STEAM_CREATE_TRIGS( __player, __s_lion_spot ); \
		} \
	} \
	else if ( isdefined( __s_lion_spot.springpad_buddy.springpad ) && !isdefined( __s_lion_spot.which_ball ) && !isdefined( __s_lion_spot.springpad_buddy.which_ball ) ) \
	{ \
		SQ_2_PLACE_BALL_THINK( __player, __s_lion_spot ); \
		__buddy_place_ball_think( __player, __s_lion_spot.springpad_buddy ); \
	}

sq_1()
{
	level endon( "sq_ball_picked_up" );
	level waittill( "sq_1" + "_" + "pts_1" + "_started" );
	players = get_players();
	level.pts_ghoul = players.size;

	for ( i = 0; i < players.size; i++ )
	{
		players[i] thread onPlayerDisconnect( 0 );
	}

	wait_for_all_springpads_placed();
	level.pts_ghoul = undefined;
}

sq_2()
{
	level waittill( "sq_2" + "_" + "pts_2" + "_started" );
	players = get_players();
	level.pts_lion = players.size;

	for ( i = 0; i < players.size; i++ )
	{
		players[i] thread onPlayerDisconnect( 1 );
		players[i] thread pts_watch_springpad_use();
	}

	thread onPickUp();
}

onPlayerDisconnect( is_generator )
{
	if ( !is_generator )
	{
		level endon( "pts_1_springpads_placed" );
	}

	self waittill( "disconnect" );

	if ( is_generator )
	{
		if ( isdefined( level.pts_lion ) )
		{
			level.pts_lion--;
		}
	}
	else
	{
		if ( isdefined( level.pts_ghoul ) )
		{
			level.pts_ghoul--;
		}
	}
}

//if the number of players is less than or equal to 3 and a ball is placed for the Maxis Trample Steam step, keeps the trigger to place a new ball for the Trample Steam it was placed on and the one opposite from it
//if the number of players is 3, creates trigs for each player already carrying a ball to enable them to place the ball on the lone Trample Steam if the Trample Steam was correctly placed before the 1st ball is launched.
place_ball_think( t_place_ball, s_lion_spot )
{
	t_place_ball endon( "delete" );
	t_place_ball waittill( "trigger" );
	remove = false;

	if ( !isdefined( s_lion_spot.springpad_buddy.springpad ) )
	{
		s_lion_spot.springpad_buddy.springpad = s_lion_spot.springpad;
		remove = true;
	}

	waittillframeend;

	if ( remove )
	{
		s_lion_spot.springpad_buddy.springpad = undefined;

		if ( !isdefined( s_lion_spot.springpad_buddy.which_ball ) )
		{
			s_lion_spot.springpad_buddy.which_ball = s_lion_spot.which_ball;
			s_lion_spot.which_ball = undefined;
			s_lion_spot.springpad_buddy.which_generator = s_lion_spot.which_generator;
			s_lion_spot.which_generator = undefined;
			m_ball_anim = getEnt( "trample_gen_" + s_lion_spot.script_noteworthy, "targetname" );
			m_ball_anim.targetname = "trample_gen_" + s_lion_spot.springpad_buddy.script_noteworthy;
		}
	}

	pts_should_springpad_create_trigs( s_lion_spot );

	//once a player flings a ball, gives each player already carrying a ball the ability to place it on the Trample Steam(s) placed on the other set of symbols than the ones on which the ball was flung.
	if ( isdefined( level.pts_lion ) && level.pts_lion == 3 )
	{
		a_lion_spots = getstructarray( "pts_lion", "targetname" );

		for ( i = 0; i < a_lion_spots.size; i++ )
		{
			if ( a_lion_spots[i] != s_lion_spot && a_lion_spots[i].springpad_buddy != s_lion_spot )
			{
				if ( !isdefined( a_lion_spots[i].springpad_buddy.springpad ) )
				{
					SQ_2_PLACE_BALL_TRIGGER_CLEANUP( a_lion_spots[i] );
				}
				else if ( !isdefined( a_lion_spots[i].springpad ) )
				{
					SQ_2_PLACE_BALL_TRIGGER_CLEANUP( a_lion_spots[i].springpad_buddy );
				}

				pts_should_springpad_create_trigs( a_lion_spots[i] );
				break;
			}
		}
	}
}

//makes Richtofen Trample Steam step require as many as players
wait_for_all_springpads_placed()
{
	a_spots = getstructarray( "pts_ghoul", "targetname" );

	while ( !flag( "pts_1_springpads_placed" ) )
	{
		is_clear = 0;

		for ( i = 0; i < a_spots.size; i++ )
		{
			if ( !isdefined( a_spots[i].springpad ) )
				is_clear++;
		}

		if ( is_clear <= 4 - num_player_valid( 0 ) )
			flag_set( "pts_1_springpads_placed" );

		wait 1;
	}
}

pts_watch_springpad_use()
{
	self endon( "death" );
	self endon( "disconnect" );

	while ( !flag( "sq_branch_complete" ) )
	{
		self waittill( "equipment_placed", weapon, weapname );

		if ( weapname == level.springpad_name )
		{
			self is_springpad_in_place( weapon );
		}
	}
}

is_springpad_in_place( m_springpad )
{
	a_lion_spots = getstructarray( "pts_lion", "targetname" );

	for ( i = 0; i < a_lion_spots.size; i++ )
	{
		if ( distance2dsquared( m_springpad.origin, a_lion_spots[i].origin ) < 1024 )
		{
			v_spot_forward = vectornormalize( anglestoforward( a_lion_spots[i].angles ) );
			v_pad_forward = vectornormalize( anglestoforward( m_springpad.angles ) );
			n_dot = vectordot( v_spot_forward, v_pad_forward );

			if ( n_dot > 0.98 )
			{
				SQ_2_PLACE_BALL_TRIGGER_CLEANUP( a_lion_spots[i] );
				SQ_2_PLACE_BALL_TRIGGER_CLEANUP( a_lion_spots[i].springpad_buddy );
				wait 0.1;
				level thread pts_should_springpad_create_trigs( a_lion_spots[i] );
				break;
			}
		}
	}
}

onPickUp()
{
	for (;;)
	{
		level waittill( "zm_ball_picked_up", player );
		thread pts_should_player_create_trigs( player );
	}
}

/*
#define NOOP(__a,__b)
#define SQ_2_PLACE_BALL_THINK(__player,__s_lion_spot) \
	__player thread place_ball_think( __s_lion_spot.pts_putdown_trigs[__player.characterindex], __s_lion_spot );

#define SQ_2_TRAMPLE_STEAM_CREATE_TRIGS(__player,__s_lion_spot) \
	pts_putdown_trigs_create_for_spot( __s_lion_spot, __player ); \
	SQ_2_PLACE_BALL_THINK( __player, __s_lion_spot );

#define SQ_2_TRAMPLE_STEAM_BUDDY_ELSE_LOGIC(__player,__s_lion_spot_buddy) \
	else \
	{ \
		SQ_2_TRAMPLE_STEAM_CREATE_TRIGS( __player, __s_lion_spot_buddy ) \
	}

#define SQ_2_TRAMPLE_STEAM_CHECKS(__player,__s_lion_spot,__buddy_else_logic,__buddy_place_ball_think) \
	if ( isdefined( level.pts_lion ) && level.pts_lion < 4 ) \
	{ \
		if ( isdefined( __s_lion_spot.springpad_buddy.springpad ) || level.pts_lion == 1 || ( level.pts_lion == 3 && flag( "pts_2_generator_1_started" ) && !isdefined( __s_lion_spot.which_ball ) && !isdefined( __s_lion_spot.springpad_buddy.which_ball ) ) ) \
		{ \
			if ( !isdefined( __s_lion_spot.springpad_buddy.springpad ) ) \
			{ \
				maps\mp\zm_highrise_sq_pts::pts_putdown_trigs_create_for_spot( __s_lion_spot, __player ); \
			} \
			__buddy_else_logic( __player, __s_lion_spot.springpad_buddy ); \
			\
			SQ_2_TRAMPLE_STEAM_CREATE_TRIGS( __player, __s_lion_spot ); \
		} \
	} \
	else if ( isdefined( __s_lion_spot.springpad_buddy.springpad ) && !isdefined( __s_lion_spot.which_ball ) && !isdefined( __s_lion_spot.springpad_buddy.which_ball ) ) \
	{ \
		SQ_2_PLACE_BALL_THINK( __player, __s_lion_spot ); \
		__buddy_place_ball_think( __player, __s_lion_spot.springpad_buddy ); \
	}
*/
//on the Maxis side if the player is playing solo or 3p, once the player picks up a ball, gives the player the ability to place the ball on an already correctly placed Trample Steam without needing a Trample Steam on the opposite end. On 3p, this is executed if the ball is picked up while there's already a ball flinging.
pts_should_player_create_trigs( player )
{
	waittillframeend;
	a_lion_spots = getstructarray( "pts_lion", "targetname" );

	for ( i = 0; i < a_lion_spots.size; i++ )
	{
		if ( isdefined( a_lion_spots[i].springpad ) )
		{
			SQ_2_TRAMPLE_STEAM_CHECKS( player, a_lion_spots[i], NOOP, NOOP );
		}
	}
}

//on the Maxis side if the player is playing solo or 3p, once a player places a Trample Steam correctly, gives each player already carrying a ball the ability to place it without needing a Trample Steam on the opposite end. On 3p, this is executed if the Trample Steam is placed while there's already a ball flinging.
pts_should_springpad_create_trigs( s_lion_spot )
{
	waittillframeend;

	if ( isdefined( s_lion_spot.springpad ) && isdefined( s_lion_spot.springpad_buddy ) )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( isdefined( level.players[i].zm_sq_has_ball ) && level.players[i].zm_sq_has_ball )
			{
				SQ_2_TRAMPLE_STEAM_CHECKS( level.players[i], s_lion_spot, SQ_2_TRAMPLE_STEAM_BUDDY_ELSE_LOGIC, SQ_2_PLACE_BALL_THINK );
			}
		}
	}
}

//if the number of players is 3 or less, once a ball is picked up, gives the ability to place a 2nd ball on a set of Trample Steams that already has a ball flinging from them for the Maxis Trample Steam step
pts_putdown_trigs_create_for_spot( s_lion_spot, player )
{
	if ( !( isdefined( s_lion_spot.which_ball ) || isdefined( s_lion_spot.springpad_buddy ) && isdefined( s_lion_spot.springpad_buddy.which_ball ) ) )
		return;

	t_place_ball = sq_pts_create_use_trigger( s_lion_spot.origin, 16, 70, &"ZM_HIGHRISE_SQ_PUTDOWN_BALL" );
	player clientclaimtrigger( t_place_ball );
	t_place_ball.owner = player;
	player thread maps\mp\zm_highrise_sq_pts::place_ball_think( t_place_ball, s_lion_spot );

	if ( !isdefined( s_lion_spot.pts_putdown_trigs ) )
		s_lion_spot.pts_putdown_trigs = [];

	s_lion_spot.pts_putdown_trigs[player.characterindex] = t_place_ball;
	level thread pts_putdown_trigs_springpad_delete_watcher( player, s_lion_spot );
}
