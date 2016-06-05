#include <stdio.h>
#include <regular_exp.h>
#include <transducer.h>

char alphabet[50];
int alphabet_size;

void read_alphabet();

int main(int argc, char **argv) {
	//read_alphabet();
	
	char * expression = (char*)"<awe, bfc, 132>*";
	RegExp reg_exp(expression);
	return 0;
}

void read_alphabet() {
	scanf("%d\n", &alphabet_size);
	for (int i = 0; i < alphabet_size; i++) {
		scanf(" %c", alphabet + i);
	}
}
