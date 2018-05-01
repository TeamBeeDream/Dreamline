void main(void) {
    vec2 uv = v_tex_coord;
    float tiledX = mod(uv.x * u_scale, 1.0);
    float tiledY = mod(uv.y * u_scale, 1.0);
    vec2 tiledUV = vec2(tiledX, tiledY);
    
    gl_FragColor = texture2D(u_texture, tiledUV);
}
