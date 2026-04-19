#define PlayerRenderPartner
    if (!global.is_connected || global.partner_sprite == -4) exit;
    
    if (instance_exists(objPlayer) && global.partner_room == objPlayer.room) {
        // 1. Dessiner le Sprite du partenaire
        draw_sprite_ext(
            global.partner_sprite, 
            global.partner_image_index, 
            global.partner_x, 
            global.partner_y, 
            1 * global.partner_facing, 
            1, 
            global.partner_angle, 
            c_white, 
            0.5
        );
        
        // 2. Dessiner l'étiquette du nom
        if (global.partner_name != "") {
            draw_set_font(-1);
            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            
            // Paramètres d'ajustement
            var _textX = global.partner_x;
            var _textY = global.partner_y - 16; // Valeur diminuée pour être plus proche de la tête
            var _scale = 0.5;                   // Taille réduite (0.7 = 70% de la taille originale)
            
            // Ombre (Noir) pour le contraste
            draw_set_color(c_black);
            draw_text_transformed(_textX + 1, _textY + 1, global.partner_name, _scale, _scale, 0);
            
            // Texte principal (Blanc)
            draw_set_color(c_white);
            draw_text_transformed(_textX, _textY, global.partner_name, _scale, _scale, 0);
            
            // Réinitialisation de l'alignement pour ne pas impacter les autres dessins
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    }