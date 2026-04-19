#define PlayerRenderPartner
    if (!global.is_connected || global.partner_sprite == -4) exit;

    if (instance_exists(objPlayer) && global.partner_room == objPlayer.room) {
        
        draw_sprite_ext(
            global.partner_sprite, 
            global.partner_image_index, 
            global.partner_x, 
            global.partner_y, 
            1 * global.partner_facing, 
            1, 
            global.partner_angle, 
            c_white, 
            0.75
        );

        if (global.partner_hold != -4) {
            var _itemSprite = ItemGet(global.partner_hold, ItemData.Sprite);
            
            if (_itemSprite != undefined && _itemSprite >= 0) {
                var _toolX = global.partner_x - (5 * global.partner_facing);
                var _toolY = global.partner_y - 2;
                
                var _toolRot = 90 * global.partner_facing;
                if (global.partner_hold >= 114 && global.partner_hold <= 129) {
                    _toolRot = (global.partner_facing == 1) ? 90 : 0;
                }

                draw_sprite_ext(
                    _itemSprite, 0, 
                    _toolX, _toolY, 
                    1.0, 1.0,
                    _toolRot, 
                    c_white, 0.75
                );
            }
        }

        // 3. Étiquette du nom (Scale ajustée pour plus de netteté)
        if (global.partner_name != "") {
            draw_set_font(-1);
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            var _scale = 0.5;
            draw_set_color(c_black);
            draw_text_transformed(global.partner_x + 1, global.partner_y - 25, global.partner_name, _scale, _scale, 0);
            draw_set_color(c_white);
            draw_text_transformed(global.partner_x, global.partner_y - 26, global.partner_name, _scale, _scale, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }