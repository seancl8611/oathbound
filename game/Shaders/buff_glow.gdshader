shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.9, 0.2, 1.0); // Yellow glow
uniform bool is_buffed = false;
uniform float intensity = 0.3;
uniform float pulse_speed = 4.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if (is_buffed) {
		float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);
		tex.rgb += glow_color.rgb * intensity * pulse;
	}
	COLOR = tex;
}
