#include "pair.h"

template <class K, class V>
pair<K, V>::pair(K first, V second) {
	this->first = first;
	this->second = second;
}

template <class K, class V>
pair<K, V>::pair(const pair<K, V> &other) {
	this->first = other.first;
	this->second = other.second;
}

template <class K, class V>
pair<K, V>& pair<K, V>::operator=(const pair<K, V> &other) {
	if (this != &other) {
		this->first = other.first;
		this->second = other.second;
	}
	return *this;
}

template class pair<unsigned int, unsigned int>;
template class pair<char, unsigned int>;