#include common_scripts\utility;

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
	self iPrintLn( "^2Any Player EE Mod ^5TranZit Maxis" );
}

sidequest_main()
{
	flag_wait( "start_zombie_round_logic" );
	waittillframeend;

	if ( level.richcompleted && level.maxcompleted )
	{
		return;
	}

	for (;;)
	{
		thread maxis_sidequest();
		flag_wait( "power_on" );
		flag_waitopen( "power_on" );
	}
}

maxis_sidequest()
{
	if ( flag( "power_on" ) || level.maxcompleted )
	{
		return;
	}

	thread maxis_sidequest_a();
	thread maxis_sidequest_c();
}

maxis_sidequest_a()
{
	level endon( "power_on" );
	level endon( "end_avogadro_turbines" );

	for (;;)
	{
		level waittill( "turbine_deployed" );

		if ( level.players.size == 1 )
		{
			waittillframeend;
			level notify( "turbine_deployed" );
		}
	}
}

maxis_sidequest_c()
{
	flag_wait( "power_on" );
	flag_waitopen( "power_on" );
	level endon( "power_on" );
	level endon( "transit_sidequest_achieved" );
	screech_zones = getstructarray( "screecher_escape", "targetname" );

	for (;;)
	{
		level maps\mp\_utility::waittill_either( "turbine_deployed", "connected" );
		waittillframeend;

		if ( level.players.size == 1 )
		{
			if ( isdefined( level.players[0].buildableturbine ) )
			{
				for ( x = 0; x < screech_zones.size; x++ )
				{
					zone = screech_zones[x];

					if ( distancesquared( level.players[0].buildableturbine.origin, zone.origin ) < zone.radius * zone.radius )
					{
						if ( !isdefined( level.sq_progress["maxis"]["C_turbine_1"] ) )
						{
							level.sq_progress["maxis"]["C_turbine_1"] = 1;
						}
						else
						{
							level.sq_progress["maxis"]["C_turbine_2"] = 1;
						}

						level notify( "turbine_deployed" );
					}
				}
			}
		}
		else
		{
			if ( isdefined( level.sq_progress["maxis"]["C_turbine_1"] ) && !isdefined( level.sq_progress["maxis"]["C_turbine_1"].turbine_watch_cleanup ) )
			{
				level.sq_progress["maxis"]["C_turbine_1"] = undefined;
			}
			else if ( isdefined( level.sq_progress["maxis"]["C_turbine_2"] ) && !isdefined( level.sq_progress["maxis"]["C_turbine_2"].turbine_watch_cleanup ) )
			{
				level.sq_progress["maxis"]["C_turbine_2"] = undefined;
			}
		}
	}
}
