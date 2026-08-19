shader_type canvas_item;

uniform bool is_glowing = false;
uniform float glow_intensity = 1.0;
uniform vec4 glow_color = vec4(1.0, 0.0, 0.0, 1.0); // Default: Red Glow

void fragment() {
    COLOR = texture(TEXTURE, UV);

    if (is_glowing) {
        float glow = sin(TIME * 5.0) * 0.3 + 0.7; // Creates a smooth pulse effect
        COLOR.rgb += glow_color.rgb * glow * glow_intensity;
    }
}
