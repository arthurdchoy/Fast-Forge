shader_type canvas_item;

uniform vec4 origin1:source_color;
uniform vec4 new1:source_color;

uniform vec4 origin2:source_color;
uniform vec4 new2:source_color;

uniform vec4 origin3:source_color;
uniform vec4 new3:source_color;

uniform vec4 origin4:source_color;
uniform vec4 new4:source_color;

uniform vec4 defaultColor:source_color;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	
	if(distance(current_pixel, origin1) < 0.1)
		COLOR = new1;
	else if(distance(current_pixel, origin2) < 0.1)
		COLOR = new2;
	else if(distance(current_pixel, origin3) < 0.1)
		COLOR = new3;
	else if(distance(current_pixel, origin4) < 0.1)
		COLOR = new4;
	else if(current_pixel.a < 0.5)
		COLOR = current_pixel;
	else
		COLOR = defaultColor;
}
