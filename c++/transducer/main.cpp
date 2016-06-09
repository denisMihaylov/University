#include <stdio.h>
#include <regular_exp.h>
#include <transducer.h>
#include <bs_transducer.h>

const char* read_alphabet();

int main(int argc, char **argv) {
	//const char* alphabet = read_alphabet();
	const char* alphabet = "abcd";
	const char * expression = "<awe, bfc, 132>*";
	RegExp reg_exp(alphabet, expression);
	BerrySethiTransducer* transducer = reg_exp.to_transducer();
	return 0;
}

const char* read_alphabet() {
	ui alphabet_size;
	scanf("%d\n", &alphabet_size);
	char* alphabet = new char[alphabet_size + 1];
	for (ui i = 0; i < alphabet_size; i++) {
		scanf(" %c", alphabet + i);
	}
	alphabet[alphabet_size] = '\0';
	return alphabet;
}
