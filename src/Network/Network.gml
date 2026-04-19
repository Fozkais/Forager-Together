#define NetInit
    global.net_port = 6511;
    global.net_server = -4;
    global.net_socket = -4;
    global.is_host = false;
    global.is_connected = false;
    
    enum NetCmd {
        PING,
        CHAT,
        PLAYER_DATA,
        DISCONNECT
    }

#define NetGetStatusString
    if (global.is_host && !global.is_connected) return "HOSTING...";
    if (global.is_connected) return "CONNECTED";
    return "OFFLINE";

#define NetHost
    if (global.is_host || global.is_connected) {
        Trace("Action impossible: Already connected or hosting.");
        exit;
    }

    global.net_server = network_create_server(network_socket_tcp, global.net_port, 1);
    
    if (global.net_server < 0) {
        Trace("Error: Could not create server on port " + string(global.net_port));
    } else {
        global.is_host = true;
        Trace("Server started on port " + string(global.net_port) + ". Waiting for player...");
    }

#define NetJoin(ip)
    if (global.is_host || global.is_connected) {
        Trace("Action impossible: Already connected or hosting.");
        exit;
    }

    if (ip == "") ip = "127.0.0.1";
    
    Trace("Connecting to: " + ip);
    global.net_socket = network_create_socket(network_socket_tcp);
    var _res = network_connect(global.net_socket, ip, global.net_port);

    if (_res < 0) {
        Trace("Connection failed to: " + ip);
        network_destroy(global.net_socket);
        global.net_socket = -4;
    } else {
        global.is_connected = true;
        Trace("Successfully connected to host!");
    }

#define NetDisconnect
    // 1. Notify partner before closing
    if (global.is_connected && global.net_socket != -4) {
        var _packet = buffer_create(1, buffer_grow, 1);
        buffer_write(_packet, buffer_u8, NetCmd.DISCONNECT);
        
        network_send_packet(global.net_socket, _packet, buffer_tell(_packet));
        buffer_delete(_packet);
        
        global.is_connected = false;
        Trace("Sent disconnect signal to partner.");
    }

    // 2. Shut down Host server
    if (global.is_host && global.net_server != -4) {
        network_destroy(global.net_server);
        global.net_server = -4;
        global.is_host = false;
        Trace("Server stopped.");
    }
    
    // 3. Clean up Connection socket
    if (global.net_socket != -4) {
        network_destroy(global.net_socket);
        global.net_socket = -4;
    }

    // Reset UI state
    global.is_connected = false;
    global.is_host = false;
    global.menu_state = "MAIN";
    Trace("Session cleanup complete.");

#define NetSendPacket(buffer)
    if (global.net_socket != -4) {
        network_send_packet(global.net_socket, buffer, buffer_tell(buffer));
    }
    buffer_delete(buffer);

#define NetHandlePacket(buffer)
	try {
        var _cmd = buffer_read(buffer, buffer_u8);
        switch (_cmd) {
            case NetCmd.PING:
                Trace("Ping received from player.");
                break;
                
            case NetCmd.CHAT:
                var _msg = buffer_read(buffer, buffer_string);
                Trace("Message received: " + _msg);
                break;

            case NetCmd.DISCONNECT:
                Trace("Player requested a clean disconnect.");
                NetDisconnect();
                break;
                
            default:
                Trace("Unknown packet received (ID: " + string(_cmd) + ")");
                break;
        }
    } catch (_error) {
         Trace("Network error or empty buffer: " + string(_error));
    }