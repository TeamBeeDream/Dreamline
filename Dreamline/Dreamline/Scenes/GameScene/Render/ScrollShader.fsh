

void main(void) {
    
    vec2 uv = v_tex_coord;
    
    float xScroll = uv.x;
    float yScroll = uv.y + (u_time * u_scroll_speed);
    vec2 scrolledUV = vec2(xScroll, mod(yScroll, 1.0));
    
    gl_FragColor = texture2D(u_texture, scrolledUV);
}
