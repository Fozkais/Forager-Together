#define Main
    NetInit();
    
    global.menu_open = false;
    global.menu_alpha = 0;
    global.menu_target_alpha = 0;
    global.menu_state = "MAIN";
    
    global.input_ip = "127.0.0.1";
    global.input_active = false;
    
    global.col_ui_back = make_color_rgb(45, 45, 45);
    global.col_ui_accent = make_color_rgb(255, 215, 0);

    Trace("Mod initialisé : Prêt pour le multijoueur.");