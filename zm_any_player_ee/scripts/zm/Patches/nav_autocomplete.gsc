init()
{
	switch ( getdvar( #"mapname" ) )
	{
		case "zm_transit":
		case "zm_highrise":
		case "zm_buried":
			thread func();
			break;
	}
}

func()
{
	common_scripts\utility::flag_wait( "initial_players_connected" );
	stat_names = array( "sq_transit_started", "sq_highrise_started", "sq_buried_started", "navcard_applied_zm_transit", "navcard_applied_zm_highrise", "navcard_applied_zm_buried" );

	for ( i = 0; i < level.players.size; i++ )
	{
		// Handles building the NAV Tables and applying the Navcards
		for ( j = 0; j < stat_names.size; j++ )
		{
			if ( !level.players[i] maps\mp\zombies\_zm_stats::get_global_stat( stat_names[j] ) )
			{
				level.players[i] maps\mp\gametypes_zm\_globallogic_score::initPersStat( stat_names[j], 0 );
				level.players[i] maps\mp\zombies\_zm_stats::increment_client_stat( stat_names[j], 0 );
			}
		}
	}
}
