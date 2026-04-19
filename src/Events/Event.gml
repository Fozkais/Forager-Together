#define OnStep
    UI_MenuStep();

#define OnDrawGUI
    UI_MenuDraw();

#define OnNetworkAsync(async_load)
    var _type = async_load[? "type"];

    switch (_type) {
        case network_type_connect:
            if (global.is_host) {
                global.net_socket = async_load[? "socket"];
                global.is_connected = true;
                Trace("Un PenPal s'est connecté !");
            }
            break;

        case network_type_disconnect:
            Trace("Partenaire déconnecté.");
            NetDisconnect();
            break;

        case network_type_data:
            var _buffer = async_load[? "buffer"];
            NetHandlePacket(_buffer); 
            break;
    }