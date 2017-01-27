varying lowp vec2 vTex;

uniform lowp sampler2D samplerFront;
uniform lowp float alphaDither;

const lowp mat4 ptn1 = mat4(0.0, 0.0, 0.0, 0.0,    0.0, 0.0, 1.0, 0.0,    0.0, 0.0, 0.0, 0.0,    1.0, 0.0, 0.0, 0.0);
const lowp mat4 ptn2 = mat4(1.0, 0.0, 1.0, 0.0,    0.0, 0.0, 0.0, 0.0,    1.0, 0.0, 1.0, 0.0,    0.0, 0.0, 0.0, 0.0);
const lowp mat4 ptn3 = mat4(0.0, 0.0, 1.0, 0.0,    0.0, 1.0, 0.0, 1.0,    1.0, 0.0, 0.0, 0.0,    0.0, 1.0, 0.0, 1.0);
const lowp mat4 ptn5 = mat4(1.0, 1.0, 0.0, 1.0,    1.0, 0.0, 1.0, 0.0,    0.0, 1.0, 1.0, 1.0,    1.0, 0.0, 1.0, 0.0);
const lowp mat4 ptn6 = mat4(0.0, 1.0, 0.0, 1.0,    1.0, 1.0, 1.0, 1.0,    0.0, 1.0, 0.0, 1.0,    1.0, 1.0, 1.0, 1.0);
const lowp mat4 ptn7 = mat4(1.0, 1.0, 1.0, 1.0,    1.0, 1.0, 0.0, 1.0,    1.0, 1.0, 1.0, 1.0,    0.0, 1.0, 1.0, 1.0);

float fetchFactor(mat4 matrix, int x, int y)
{
	if (x == 0)
	{
		if (y == 0) return matrix[0][0];
		if (y == 1) return matrix[0][1];
		if (y == 2) return matrix[0][2];
		if (y == 3) return matrix[0][3];
	}
	if (x == 1)
	{
		if (y == 0) return matrix[1][0];
		if (y == 1) return matrix[1][1];
		if (y == 2) return matrix[1][2];
		if (y == 3) return matrix[1][3];
	}
	if (x == 2)
	{
		if (y == 0) return matrix[2][0];
		if (y == 1) return matrix[2][1];
		if (y == 2) return matrix[2][2];
		if (y == 3) return matrix[2][3];
	}
	if (x == 3)
	{
		if (y == 0) return matrix[3][0];
		if (y == 1) return matrix[3][1];
		if (y == 2) return matrix[3][2];
		if (y == 3) return matrix[3][3];
	}
}

void main(void)
{
	vec4 front = texture2D(samplerFront, vTex);

	vec2 xy = gl_FragCoord.xy;
	float xf = mod(xy.x, 4.0);
	float yf = mod(xy.y, 4.0);
	int x = int(xf);
	int y = int(yf);

	float factor = 0.0;
	int pattern = int(8.0 * alphaDither);

	if (pattern == 0) factor = 0.0;
	if (pattern == 1) factor = fetchFactor(ptn1, x, y);
	if (pattern == 2) factor = fetchFactor(ptn2, x, y);
	if (pattern == 3) factor = fetchFactor(ptn3, x, y);
	if (pattern == 4) factor = abs(mod(xf, 2.0) - mod(yf, 2.0));
	if (pattern == 5) factor = fetchFactor(ptn5, x, y);
	if (pattern == 6) factor = fetchFactor(ptn6, x, y);
	if (pattern == 7) factor = fetchFactor(ptn7, x, y);
	if (pattern == 8) factor = 1.0;

	front *= factor;

	gl_FragColor = front;
}