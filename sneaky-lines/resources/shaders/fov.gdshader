shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_always;

uniform vec4 fov_color : source_color = vec4(1.0, 1.0, 0.0, 0.3);
uniform float fade_distance : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    float alpha = 1.0 - clamp(VERTEX.z / fade_distance, 0.0, 1.0);
    ALBEDO = fov_color.rgb;
    ALPHA = fov_color.a * alpha;
}
