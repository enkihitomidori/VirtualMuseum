shader_type spatial;

 // Fresnel lens shading test

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment()
{
	vec3 base_color = vec3(0.0);
	// Control float
	float basic_fresnel = fresnel(3.2, NORMAL, VIEW);
	ALBEDO = base_color + basic_fresnel;
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
