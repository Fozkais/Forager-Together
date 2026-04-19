#define Main
    NetInit();
    
    // Player Identity
    global.player_name = "Player"; // Nom par défaut
    global.partner_name = "";

    // Partner State Initialization
    global.partner_x = -4;
    global.partner_y = -4;
    global.partner_sprite = -4;
    global.partner_image_index = 0;
    global.partner_facing = 1;
    global.partner_angle = 0;
    global.partner_room = 8; // Default Forager room

    // UI Init (existing)
    global.menu_open = false;
    global.menu_alpha = 0;
    global.menu_target_alpha = 0;
    global.menu_state = "MAIN";
    
    global.input_ip = "127.0.0.1";
    global.input_active = false;
    
    global.col_ui_back = make_color_rgb(45, 45, 45);
    global.col_ui_accent = make_color_rgb(255, 215, 0);

    Trace("Together mod initialized.");