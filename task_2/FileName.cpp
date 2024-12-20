#include <cmath>
#include <stdio.h>

extern "C" bool access5(float a1, int a2, double a3, float a4)
{
	bool v5;

	v5 = (float)(a1 - std::trunc(a1)) == 0.2f && (double)a2 / a3 > a4;
	return v5;
}

int main() {
	bool result = access5(0.2f, 10, 1.0, 1.0);

	if (result) {
		printf("Access granted\n");
	}
	else {
		printf("Access denied\n");
	}
}