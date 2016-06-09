#ifndef PAIR_H
#define PAIR_H

template <class K, class V>
class pair {
public:

	K first;
	V second;

	pair<K, V>():first(-1), second(-1){};
	pair<K, V>(K first, V second);
	pair<K, V>(const pair<K, V> &other);

	pair<K, V>& operator=(const pair<K, V> &other);
};

#endif