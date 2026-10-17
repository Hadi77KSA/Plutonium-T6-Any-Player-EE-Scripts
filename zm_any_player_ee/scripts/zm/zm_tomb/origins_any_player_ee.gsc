#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	func = getFunction( "maps/mp/zombies/_zm_challenges", "open_box" );

	if ( isdefined( func ) )
	{
		replaceFunc( func, ::open_box );
	}
}

init()
{
	thread onPlayerConnect();
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill( "connected", player );
		player thread msg();
		player = undefined;
	}
}

msg()
{
	self endon( "disconnect" );
	flag_wait( "initial_players_connected" );
	self iPrintLn( "^2Any Player EE Mod ^5Origins" );
}

open_box( player, ut_stub, fp_reward_override, param1 )
{
	if ( isdefined( player ) )
	{
		s_category = [[ getFunction( "maps/mp/zombies/_zm_challenges", "get_reward_category" ) ]]( player, player.s_lookat_stat );

		if ( !isdefined( s_category ) || s_category == level._challenges.s_team )
		{
			if ( isdefined( player.b_reward_claimed ) )
			{
				fp_reward_override = ::empty;
			}
			else
			{
				characterindex = player.characterindex; //store value in case the player disconnects immediately after claiming reward
			}
		}

		s_category = undefined;
	}

	func = getFunction( "maps/mp/zombies/_zm_challenges", "open_box" );
	disableDetourOnce( func );
	[[ func ]]( player, ut_stub, fp_reward_override, param1 );

	if ( isdefined( characterindex ) )
	{
		ut_stub = undefined;
		func = undefined;

		if ( isdefined( player ) && level._challenges.s_team.a_stats["zc_boxes_filled"].a_b_player_rewarded[player.characterindex] )
		{
			player.b_reward_claimed = true;
			player thread one_inch_punch_watch_for_death();
		}

		level._challenges.s_team.a_stats["zc_boxes_filled"].b_reward_claimed = false;
		level._challenges.s_team.a_stats["zc_boxes_filled"].a_b_player_rewarded[characterindex] = false;
	}
}

one_inch_punch_watch_for_death()
{
	self endon( "disconnect" );
	self waittill( "bled_out" );
	self.b_reward_claimed = undefined;
}
