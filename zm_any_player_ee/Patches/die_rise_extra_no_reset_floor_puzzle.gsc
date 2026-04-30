#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_highrise_sq_atd;

main()
{
	replaceFunc( maps\mp\zm_highrise_sq_atd::drg_puzzle_trig_think, ::drg_puzzle_trig_think, 1 );
}

drg_puzzle_trig_think( n_order_id )
{
	self.drg_active = 0;
	m_unlit = getent( self.target, "targetname" );
	m_lit = m_unlit.lit_icon;
	v_top = m_unlit.origin;
	v_hidden = m_lit.origin;

	while ( !flag( "sq_atd_drg_puzzle_complete" ) )
	{
		if ( self.drg_active )
		{
			level waittill_either( "sq_atd_drg_puzzle_complete", "drg_puzzle_reset" );

			if ( flag( "sq_atd_drg_puzzle_complete" ) )
				continue;
		}

		self waittill( "trigger", e_who );

		if ( level.sq_atd_cur_drg == n_order_id )
		{
			m_lit.origin = v_top;
			m_unlit.origin = v_hidden;
			m_lit playsound( "zmb_sq_symbol_light" );
			self.drg_active = 1;
			level thread vo_richtofen_atd_order( level.sq_atd_cur_drg );
			level.sq_atd_cur_drg++;
/#
			iprintlnbold( "Dragon " + n_order_id + " Correct" );
#/
			self thread drg_puzzle_trig_watch_fade( m_lit, m_unlit, v_top, v_hidden );
		}
/*
		else
		{
			if ( !flag( "sq_atd_drg_puzzle_1st_error" ) )
				level thread vo_maxis_atd_order_error();

			level.sq_atd_cur_drg = 0;
			level notify( "drg_puzzle_reset" );
/#
			iprintlnbold( "INCORRECT DRAGON" );
#/
			wait 0.5;
		}
*/

		while ( e_who istouching( self ) )
			wait 0.5;
	}
}
