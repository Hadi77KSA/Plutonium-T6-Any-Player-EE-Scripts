#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	if ( maps\mp\zombies\_zm_sidequests::is_sidequest_allowed( "zclassic" ) )
	{
		precachestring( &"ZM_TOMB_PERK_ONEINCH" );
		thread onPlayerConnect();
		thread box_footprint_think();
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
	self iPrintLn( "^2Any Player EE Mod ^5Origins" );
}

box_footprint_think()
{
	array_wait( getentarray( "foot_box", "script_noteworthy" ), "death" );

	for ( i = 0; i < level.a_uts_challenge_boxes.size; i++ )
	{
		s_unitrigger_stub = spawnstruct();
		s_unitrigger_stub.origin = level.a_uts_challenge_boxes[i].origin + ( -72, 72, 50 );
		s_unitrigger_stub.angles = level.a_uts_challenge_boxes[i].angles;
		m_reward = spawn( "script_model", s_unitrigger_stub.origin );
		m_reward.angles = s_unitrigger_stub.angles + vectorscale( ( 0, 1, 0 ), 180.0 );
		m_reward setmodel( "p6_zm_tm_tablet_muddy" );
		playfx( level._effect["staff_soul"], m_reward.origin );
		m_reward playsound( "zmb_spawn_powerup" );
		s_unitrigger_stub.radius = 64;
		s_unitrigger_stub.script_length = 64;
		s_unitrigger_stub.script_width = 64;
		s_unitrigger_stub.script_height = 64;
		s_unitrigger_stub.cursor_hint = "HINT_NOICON";
		s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
		unitrigger_force_per_player_triggers( s_unitrigger_stub, 1 );
		s_unitrigger_stub.prompt_and_visibility_func = ::prompt_and_visibility_func;
		s_unitrigger_stub.require_look_at = 1;
		maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( s_unitrigger_stub, ::trigger_func );
	}
}

prompt_and_visibility_func( player )
{
	if ( maps\mp\zombies\_zm_challenges::stat_reward_available( "zc_boxes_filled", player ) || isdefined( player.b_reward_claimed ) )
	{
		self sethintstring( "" );
		return false;
	}

	self sethintstring( &"ZM_TOMB_PERK_ONEINCH", 0 );
	return true;
}

trigger_func()
{
	self endon( "kill_trigger" );

	for (;;)
	{
		self waittill( "trigger", player );

		if ( !is_player_valid( player ) )
			continue;

		current_weapon = player getcurrentweapon();

		if ( isdefined( player.intermission ) && player.intermission || is_placeable_mine( current_weapon ) || is_equipment_that_blocks_purchase( current_weapon ) || current_weapon == "none" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || player isthrowinggrenade() || player in_revive_trigger() || player isswitchingweapons() || player.is_drinking > 0 )
		{
			wait 0.1;
			continue;
		}

		reward_one_inch_punch( player );
		self setinvisibletoplayer( player );
		wait 0.05;
	}
}

reward_one_inch_punch( player )
{
	player thread maps\mp\zombies\_zm_weap_one_inch_punch::one_inch_punch_melee_attack();
	player playsound( "zmb_powerup_grabbed" );
	player.b_reward_claimed = true;
	player thread one_inch_punch_watch_for_death();
}

one_inch_punch_watch_for_death()
{
	self endon( "disconnect" );
	self waittill( "bled_out" );
	self.b_reward_claimed = undefined;
}
