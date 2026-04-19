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
    if (global.is_host && !global.is_connected) return "HEBERGEMENT EN COURS...";
    if (global.is_connected) return "CONNECTE";
    return "HORS-LIGNE";

#define NetHost
    if (global.is_host || global.is_connected) {
        Trace("Action impossible : Déjà connecté ou hébergeur.");
        exit;
    }

    // Création du serveur TCP
    global.net_server = network_create_server(network_socket_tcp, global.net_port, 1);
    
    if (global.net_server < 0) {
        Trace("Erreur : Impossible de créer le serveur sur le port " + string(global.net_port));
    } else {
        global.is_host = true;
        Trace("Serveur lancé sur le port " + string(global.net_port) + ". En attente d'un PenPal...");
    }

#define NetJoin(ip)
    if (global.is_host || global.is_connected) {
        Trace("Action impossible : Déjà connecté ou hébergeur.");
        exit;
    }

    if (ip == "") ip = "127.0.0.1";

    // Création du socket client
    global.net_socket = network_create_socket(network_socket_tcp);
    var _res = network_connect(global.net_socket, ip, global.net_port);

    if (_res < 0) {
        Trace("Échec de la connexion à l'adresse : " + ip);
        network_destroy(global.net_socket);
        global.net_socket = -4;
    } else {
        global.is_connected = true;
        Trace("Connexion réussie avec l'hôte !");
    }

#define NetDisconnect
    if (global.is_host) {
        if (global.net_server != -4) network_destroy(global.net_server);
        global.net_server = -4;
        Trace("Serveur arrêté.");
    }
    
    if (global.net_socket != -4) {
        // Optionnel : Envoyer un paquet de déconnexion propre ici
        network_destroy(global.net_socket);
        global.net_socket = -4;
    }

    global.is_host = false;
    global.is_connected = false;
    global.menu_state = "MAIN";
    Trace("Déconnecté.");

#define NetSendPacket(buffer)
    // Utilitaire pour envoyer un paquet au partenaire
    if (global.net_socket != -4) {
        network_send_packet(global.net_socket, buffer, buffer_tell(buffer));
    }
    buffer_delete(buffer);

#define NetHandlePacket(buffer)
	try {
        var _cmd = buffer_read(buffer, buffer_u8);
        
        switch (_cmd) {
            case NetCmd.PING:
                Trace("Ping reçu du partenaire.");
                break;
                
            case NetCmd.CHAT:
                var _msg = buffer_read(buffer, buffer_string);
                Trace("Message reçu : " + _msg);
                break;

            case NetCmd.DISCONNECT:
                Trace("Le partenaire a fermé la connexion.");
                NetDisconnect();
                break;
                
            default:
                Trace("Paquet inconnu reçu (ID: " + string(_cmd) + ")");
                break;
        }
    } catch (_error) {
         Trace("Erreur réseau (Buffer vide) : " + string(_error));
    }