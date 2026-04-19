/* Forage Together - UI Elements
    Utility functions for drawing buttons and text inputs with safe font fallbacks.
*/

#define DrawButton(xx, yy, width, height, text, color)
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _hover = point_in_rectangle(_mx, _my, xx, yy, xx + width, yy + height);
var _click = _hover && mouse_check_button_pressed(mb_left);

// Click effect (2px offset)
var _off = (_hover && mouse_check_button(mb_left)) ? 2 : 0;

// Background with border
draw_set_color(c_black);
draw_roundrect_ext(xx, yy, xx + width, yy + height, 8, 8, false);
draw_set_color(_hover ? merge_color(color, c_white, 0.2) : color);
draw_roundrect_ext(xx + 2, yy + 2, xx + width - 2, yy + height - 2, 6, 6, false);

// Text - Using -1 as a safe font fallback for legibility
draw_set_font(-1); 
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Shadow
draw_set_color(c_black);
draw_text(xx + width/2 + 1 + _off, yy + height/2 + 1 + _off, text);

// Main text
draw_set_color(c_white);
draw_text(xx + width/2 + _off, yy + height/2 + _off, text);

return _click;

#define DrawInput(xx, yy, width, height, label, value, active)
var _hover = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), xx, yy, xx + width, yy + height);

// Box background
draw_set_color(c_black);
draw_roundrect_ext(xx, yy, xx + width, yy + height, 8, 8, false);
draw_set_color(active ? c_white : c_dkgray);
draw_roundrect_ext(xx + 2, yy + 2, xx + width - 2, yy + height - 2, 6, 6, false);

// Input text
draw_set_font(-1);
draw_set_color(c_black);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
var _str = label + ": " + value + (active && (current_time % 1000 < 500) ? "|" : "");
draw_text(xx + 15, yy + height/2, _str);

return (mouse_check_button_pressed(mb_left) && _hover);