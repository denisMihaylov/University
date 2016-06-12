#include <bs_transducer.h>
#include <stdlib.h>
#include <pair.h>

#include <iostream>

typedef pair<std::vector<ui>, std::vector<ui> > pair_of_vectors;

BerrySethiTransducer::BerrySethiTransducer(const char* alphabet, Monoid* monoid, ui monoids_count) {
	this->init(alphabet);
	
	this->first->reserve(monoids_count);
	this->first->push_back(1);
	
	this->last->reserve(monoids_count);
	this->last->push_back(1);
	
	this->follow->reserve(monoids_count);
	
	this->q_map->reserve(monoids_count);
	this->q_map->push_back(monoid);
}

BerrySethiTransducer::BerrySethiTransducer(const char* alphabet, ui first_state, Monoid* monoid) {
	this->init(alphabet);
	this->first->push_back(first_state);
	this->last->push_back(first_state);
	this->q_map->push_back(monoid);
}

//This can be optimized because in most cases long structures will be added to not so big structures
void BerrySethiTransducer::bs_union(const BerrySethiTransducer* other) {
	// unite states
	this->states_count += other->states_count;
	this->resize_union(this->first, other->first);
	this->resize_union(this->last, other->last);
	this->resize_union(this->follow, other->follow);
	this->resize_union(this->q_map, other->q_map);
	
	this->is_first_final |= other->is_first_final;
}

void BerrySethiTransducer::concat(const BerrySethiTransducer* other) {
	// unite states
	this->states_count += other->states_count;
	
	this->resize_union(this->follow, other->follow);
	this->follow->push_back(new pair_of_vectors((*this->last), (*other->first)));
	this->resize_union(this->q_map, other->q_map);
	
	if (this->is_first_final) {
		this->resize_union(this->first, other->first);
	} else {
		delete other->first;
	}
	
	if (other->is_first_final) {
		this->resize_union(this->last, other->last);
	} else {
		std::vector<ui>* temp = this->last;
		this->last = other->last;
		delete temp;
	}
	
	this->is_first_final &= other->is_first_final;
}

void BerrySethiTransducer::star() {
	this->is_first_final = true;
	pair_of_vectors* last_to_first = new pair_of_vectors((*this->last), (*this->first));
	this->follow->push_back(last_to_first);
}

template <typename T>
void BerrySethiTransducer::resize_union(std::vector<T>* first, const std::vector<T>* second){
	ui new_size = first->size() + second->size();
	if (first->capacity() < new_size) {
		first->reserve(new_size);
	}
	first->insert(first->end(), second->begin(), second->end());
}

void BerrySethiTransducer::init(const char* alphabet) {
	this->alphabet = alphabet;
	this->states_count = 1;
	this->is_first_final = false;
	this->first = new std::vector<ui>();
	this->last = new std::vector<ui>();
	this->follow = new std::vector<pair<std::vector<ui>, std::vector<ui> >* >();
	this->q_map = new std::vector<Monoid*>();
}


std::ostream& operator<<(std::ostream& os, const BerrySethiTransducer& transducer) {
	os<<std::endl<<"States count: " << transducer.states_count << std::endl;
	os<<"First: [";
	for (ui out: (*transducer.first)) {
		os << out << " ,";
	}
	os<<"]"<<std::endl;
	
	os<<"Last: [";
	for (ui out: (*transducer.last)) {
		os << out << " ,";
	}
	os<<"]"<<std::endl;
	
	os<<"Follow: [";
	for (pair_of_vectors* vec: (*transducer.follow)) {
		std::cout<<"[";
		for (ui out: vec->first) {
			os << out << " ,";
		}
		os <<"] ,";
		os<<"[";
		for (ui out: vec->second) {
			os << out << " ,";
		}
		os <<"]"<<std::endl;
	}
	os<<"]"<<std::endl<<"Is Final: " << transducer.is_first_final << std::endl;
	os<<"Q MAP: [";
	for (Monoid* monoid: (*transducer.q_map)) {
		os<<(*monoid)<<", ";
	}
	os<<"]";
	os<<std::endl;
	return os;
}

Transducer& BerrySethiTransducer::to_transducer() {
	Transducer* result = new Transducer();
	return *result;
}

const char* BerrySethiTransducer::getAlphabet() const {
	return alphabet;
}

std::vector<ui>* BerrySethiTransducer::getFirst() const {
	return first;
}

std::vector<pair<std::vector<ui>, std::vector<ui> >*>* BerrySethiTransducer::getFollow() const {
	return follow;
}

bool BerrySethiTransducer::getIsFirstFinal() const {
	return is_first_final;
}

std::vector<ui>* BerrySethiTransducer::getLast() const {
	return last;
}
std::vector<Monoid*>* BerrySethiTransducer::getQMap() const {
	return q_map;
}
const ui& BerrySethiTransducer::getStatesCount() const {
	return states_count;
}