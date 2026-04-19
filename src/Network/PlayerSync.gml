#define PlayerSyncSend
    if (!global.is_connected || !instance_exists(objPlayer)) exit;

    var _packet = buffer_create(1, buffer_grow, 1);
    buffer_write(_packet, buffer_u8, NetCmd.PLAYER_DATA);
    
	buffer_write(_packet, buffer_string, global.player_name);
    // Write local player data
    buffer_write(_packet, buffer_u8, objPlayer.sprite_index);
    buffer_write(_packet, buffer_u8, floor(objPlayer.image_index));
    buffer_write(_packet, buffer_s8, objPlayer.facing);
    buffer_write(_packet, buffer_s32, floor(objPlayer.x));
    buffer_write(_packet, buffer_s32, floor(objPlayer.y));
    buffer_write(_packet, buffer_u16, floor(objPlayer.angle));
    buffer_write(_packet, buffer_u8, objPlayer.room);

    NetSendPacket(_packet);

#define PlayerSyncReceive(buffer)
    // Read and update global state
	global.partner_name        = buffer_read(buffer, buffer_string);

    global.partner_sprite      = buffer_read(buffer, buffer_u8);
    global.partner_image_index = buffer_read(buffer, buffer_u8);
    global.partner_facing      = buffer_read(buffer, buffer_s8);
    global.partner_x           = buffer_read(buffer, buffer_s32);
    global.partner_y           = buffer_read(buffer, buffer_s32);
    global.partner_angle       = buffer_read(buffer, buffer_u16);
    global.partner_room        = buffer_read(buffer, buffer_u8);