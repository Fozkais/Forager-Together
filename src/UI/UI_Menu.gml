#define UI_MenuStep
if (!instance_exists(objPlayer)) exit;

// Toggle Menu (F1)
if (keyboard_check_pressed(vk_f1)) {
    global.menu_open = !global.menu_open;
    global.menu_target_alpha = global.menu_open ? 1 : 0;
    objPlayer.movementOverride = global.menu_open;
}

global.menu_alpha = lerp(global.menu_alpha, global.menu_target_alpha, 0.2);

// Handle Keyboard Input
if (global.menu_open) {
    if (keyboard_check_pressed(vk_anykey)) {
        var _char = keyboard_lastchar;
        var _back = keyboard_check_pressed(vk_backspace);
        var _enter = keyboard_check_pressed(13); // Fix: Use 13 instead of vk_enter

        // 1. Name Input Logic
        if (global.menu_state == "EDIT_NAME") {
            if (_back) {
                global.player_name = string_delete(global.player_name, string_length(global.player_name), 1);
            } else if (_enter) {
                global.menu_state = "MAIN";
            } else if (string_length(global.player_name) < 12 && _char != "") {
                global.player_name += _char;
            }
        }

        // 2. IP Input Logic
        if (global.menu_state == "JOIN" && global.input_active) {
            if (_back) {
                global.input_ip = string_delete(global.input_ip, string_length(global.input_ip), 1);
            } else if (_enter) {
                global.input_active = false;
            } else if (string_length(global.input_ip) < 15 && _char != "") {
                if (string_pos(_char, "0123456789.") > 0) {
                    global.input_ip += _char;
                }
            }
        }
        keyboard_lastchar = "";
    }
}

#define UI_MenuDraw
if (global.menu_alpha < 0.05) exit;

draw_set_font(-1); 
var _mw = 600; 
var _mh = 450;
var _mx = (1280 - _mw) / 2;
var _my = (720 - _mh) / 2;

draw_set_alpha(global.menu_alpha);
draw_set_color(global.col_ui_back);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, false);
draw_set_color(c_black);
draw_roundrect_ext(_mx, _my, _mx + _mw, _my + _mh, 12, 12, true);

draw_set_halign(fa_center);
draw_text_transformed(_mx + _mw/2 + 2, _my + 42, "FORAGE TOGETHER", 1.5, 1.5, 0);
draw_set_color(global.col_ui_accent);
draw_text_transformed(_mx + _mw/2, _my + 40, "FORAGE TOGETHER", 1.5, 1.5, 0);

draw_set_halign(fa_right);
draw_set_color(c_white);
draw_text(_mx + _mw - 20, _my + 80, "STATUS: " + NetGetStatusString());

switch (global.menu_state) {
    case "MAIN": 
    case "EDIT_NAME": UI_DrawMainSection(_mx, _my, _mw, _mh); break;
    case "JOIN": UI_DrawJoinSection(_mx, _my, _mw, _mh); break;
}
draw_set_alpha(1);

#define UI_DrawMainSection(_mx, _my, _mw, _mh)
var _btnW = 240;
var _btnH = 60;
var _cx = _mx + _mw/2 - _btnW/2;

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(_mx + _mw/2, _my + 110, "YOUR NAME:");

// Input Field for Name
if (DrawInput(_mx + 150, _my + 130, 300, 40, "NAME", global.player_name, (global.menu_state == "EDIT_NAME"))) {
    global.menu_state = "EDIT_NAME";
    global.input_active = false; // Disable IP input when editing name
    keyboard_lastchar = "";
}

if (!global.is_connected) {
    if (DrawButton(_cx, _my + 200, _btnW, _btnH, "HOST GAME", make_color_rgb(70, 150, 70))) {
        NetHost();
    }
    if (DrawButton(_cx, _my + 300, _btnW, _btnH, "JOIN PLAYER", make_color_rgb(70, 70, 150))) {
        global.menu_state = "JOIN";
    }
} else {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_mx + _mw/2, _my + 230, "CONNECTED!");
    if (DrawButton(_cx, _my + 280, _btnW, _btnH, "DISCONNECT", make_color_rgb(150, 70, 70))) {
        NetDisconnect();
    }
}

#define UI_DrawJoinSection(_mx, _my, _mw, _mh)
var _btnW = 200;
var _btnH = 50;
var _cx = _mx + _mw/2 - _btnW/2;

draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(_mx + _mw/2, _my + 130, "ENTER PLAYER IP ADDRESS:");

if (DrawInput(_mx + 100, _my + 160, 400, 50, "IP", global.input_ip, global.input_active)) {
    global.input_active = true;
    keyboard_lastchar = "";
}

if (DrawButton(_cx, _my + 250, _btnW, _btnH, "CONNECT", c_green)) {
    NetJoin(global.input_ip);
    global.menu_state = "MAIN";
    global.input_active = false;
}

if (DrawButton(_cx, _my + 320, _btnW, _btnH, "BACK", c_gray)) {
    global.menu_state = "MAIN";
    global.input_active = false;
}