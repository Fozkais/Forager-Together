#define OnStep
    UI_MenuStep();
    
    // Auto-disconnect when the player returns to the main menu
    if (instance_exists(objTransition)) {
        if (objTransition.target == rmInputSelect) {
            // Only trigger if we are currently in a network session
            if (global.is_host || global.is_connected) {
                NetDisconnect();
            }
        }
    }

#define OnDrawGUI
    UI_MenuDraw();

#define OnNetworkAsync(async_load)
    var _type = async_load[? "type"];

    switch (_type) {
        case network_type_connect:
            if (global.is_host) {
                global.net_socket = async_load[? "socket"];
                global.is_connected = true;
                Trace("A player has joined the session!");
            }
            break;

        case network_type_disconnect:
            Trace("Network connection lost.");
            NetDisconnect();
            break;

        case network_type_data:
            var _buffer = async_load[? "buffer"];
            NetHandlePacket(_buffer); 
            break;
    }