#ifndef PAIR_H
#define PAIR_H

template <class K, class V>
class Pair {
public:

	K first;
	V second;

	Pair<K, V>():first(-1), second(-1){};
	Pair<K, V>(K first, V second);
	Pair<K, V>(const Pair<K, V> &other);

	Pair<K, V>& operator=(const Pair<K, V> &other);
};

#endif