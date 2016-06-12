#ifndef BS_TRANSDUCER
#define BS_TRANSDUCER

#include <monoid.h>
#include <vector>
#include <pair.h>
#include <transducer.h>

#include <iostream>

typedef unsigned int ui;

class BerrySethiTransducer
{
    const char* alphabet;
    ui states_count;
    std::vector<ui>* first;
    std::vector<ui>* last;
    // There has to be a better solution for the Cartesian product
    std::vector<pair<std::vector<ui>, std::vector<ui> >*>* follow;
    bool is_first_final;
    std::vector<Monoid*>* q_map;

public:
    BerrySethiTransducer(const char* alphabet, Monoid* monoid, ui monoids_count);
    BerrySethiTransducer(const char* alphabet, ui first_state, Monoid* monoid);
    Transducer& to_transducer();

    void bs_union(const BerrySethiTransducer* other);
    void concat(const BerrySethiTransducer* other);
    void star();

    // getters

    const char* getAlphabet() const;
    std::vector<ui>* getFirst() const;
    std::vector<pair<std::vector<ui>, std::vector<ui> >*>* getFollow() const;
    bool getIsFirstFinal() const;
    std::vector<ui>* getLast() const;
    std::vector<Monoid*>* getQMap() const;
    const ui& getStatesCount() const;

    friend std::ostream& operator<<(std::ostream& os, const BerrySethiTransducer& transducer);

private:
    template <typename T> void resize_union(std::vector<T>* first, const std::vector<T>* second);
    void init(const char* alphabet);
};

#endif