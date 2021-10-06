// Calculate Logarithmic Brightness Change
//   Penn Bauman <me@pennbauman.com>
#include "stdio.h"
#include "stdlib.h"

int main(int argc, char **argv) {
	if (argc < 2) {
		printf("Use: brightcalc <current> [change +/-]\n");
		return 1;
	}

	float b = atof(argv[1]);
	if (argc == 3) {
		if (argv[2][0] == '+') {
			b *= 1.5;
		} else if (argv[2][0] == '-') {
			b /= 1.5;
		}

		if (b > 1.0) {
			b = 1.0;
		} else if (b < 0.1) {
			b = 0.1;
		}
	}

	printf("%f\n", b);
	return 0;
}
