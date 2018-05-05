// u_scroll_speed_x
// u_scroll_speed_y
// u_tint_color

void main(void) {
    vec2 uv = v_tex_coord;

    float xScroll = (uv.x + (u_time * u_scroll_speed_x));
    float yScroll = (uv.y + (u_time * u_scroll_speed_y));
    vec2 scrolledUV = vec2(mod(xScroll, 1.0), mod(yScroll, 1.0));

    vec4 color = texture2D(u_texture, scrolledUV) * vec4(u_tint_color.rgb, 1.0);
    gl_FragColor = vec4(color.rgb, color.a) * color.a * u_tint_color.a;
}
