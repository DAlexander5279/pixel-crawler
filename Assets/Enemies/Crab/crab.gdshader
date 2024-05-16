shader_type canvas_item;
render_mode blend_mix;

uniform bool enabled = false;
uniform vec4 flash : source_color = vec4(1.000000, 1.000000, 1.000000, 1.000000);

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0, 10) = 1.0;

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1), 
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};

void fragment() {
	
	
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	float outline = 0.0;
	for (int i = 0; i < OFFSETS.length(); i++) {
		outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
	}
	outline = min(outline, 1.0);
	
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, line_color, outline - color.a);
// BooleanParameter:3
	bool n_out3p0 = enabled;


// ColorParameter:2
	vec4 n_out2p0 = flash;


// Input:5
	vec4 n_out5p0 = COLOR;


	vec3 n_out4p0;
// If:4
	float n_in4p1 = 1.00000;
	float n_in4p2 = 0.00001;
	if(abs((n_out3p0 ? 1.0 : 0.0) - n_in4p1) < n_in4p2)
	{
		n_out4p0 = vec3(n_out2p0.xyz);
	}
	else if((n_out3p0 ? 1.0 : 0.0) < n_in4p1)
	{
		n_out4p0 = vec3(n_out5p0.xyz);
	}
	else
	{
		n_out4p0 = vec3(n_out5p0.xyz);
	}


// Output:0
	COLOR.rgb = n_out4p0;


}

//}
