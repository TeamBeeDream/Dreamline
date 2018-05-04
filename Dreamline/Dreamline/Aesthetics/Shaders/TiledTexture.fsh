// u_alpha
// u_scale_x
// u_scale_y
// u_scroll_speed_x
// u_scroll_speed_y

void main(void) {
    vec2 uv = v_tex_coord;
    float posX = (uv.x + (u_time * u_scroll_speed_x)) * u_scale_x;
    float posY = (uv.y + (u_time * u_scroll_speed_y)) * u_scale_y;
    float tiledX = mod(posX, 1.0);
    float tiledY = mod(posY, 1.0);
    vec2 tiledUV = vec2(tiledX, tiledY);
    
    vec4 color = texture2D(u_texture, tiledUV);
    gl_FragColor = color * color.a * u_alpha;
}
