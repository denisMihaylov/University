#include <monoid.h>
#include <iostream>

std::ostream& operator<<(std::ostream& os, const Monoid& transducer){
	os<<"("<<transducer.input<<", "<<transducer.output<<", "<<transducer.weight<<")";
	return os;
}