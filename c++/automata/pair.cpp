#include "pair.h"

template <class K, class V>
Pair<K, V>::Pair(K first, V second) {
	this->first = first;
	this->second = second;
}

template <class K, class V>
Pair<K, V>::Pair(const Pair<K, V> &other) {
	this->first = other.first;
	this->second = other.second;
}

template <class K, class V>
Pair<K, V>& Pair<K, V>::operator=(const Pair<K, V> &other) {
	if (this != &other) {
		this->first = other.first;
		this->second = other.second;
	}
	return *this;
}

template class Pair<unsigned int, unsigned int>;
template class Pair<char, unsigned int>;