class Card
  attr_accessor :rank, :suit

  SUITS = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  BELOTE_RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    @rank.to_s.capitalize + ' of ' + @suit.to_s.capitalize
  end

  def ==(other)
    @rank == other.rank and @suit == other.suit
  end

  def compare_belote_cards_by_rank(other)
    first_card_index = Card::BELOTE_RANKS.index(self.rank)
    second_card_index = Card::BELOTE_RANKS.index(other.rank)
    first_card_index <=> second_card_index
  end

end

class Deck
  include Enumerable

  def initialize(cards = nil)
    @suits = Card::SUITS
    set_ranks
    set_cards(cards)
  end

  def each
    @cards.each {|card| yield card}
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards.first
  end

  def bottom_card
    @cards.last
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort! do |first_card, second_card|
      compare_cards(first_card, second_card)
    end
  end

  def to_s
    @cards.each {|card| puts card}
    nil
  end

  private

  def set_ranks
    case self
      when WarDeck then @ranks = Card::RANKS
      when BeloteDeck then @ranks = Card::BELOTE_RANKS
      when SixtySixDeck then @ranks = Card::BELOTE_RANKS.drop(2)
      else raise ArguementError, 'This is not a known game.'
    end
  end

  def set_cards(cards)
    if cards
      @cards = cards
    else
      @cards = @ranks.product(@suits).map {|rank, suit| Card.new(rank, suit)}
    end
  end

  def greater(first_card, second_card)
    @suits.index(first_card.suit) < @suits.index(second_card.suit) ||
    (first_card.suit == second_card.suit &&
    @ranks.index(first_card.rank) > @ranks.index(second_card.rank))
  end

  def compare_cards(first_card, second_card)
    first_card == second_card ? 0 : greater(first_card, second_card) ? -1 : 1
  end

end

class WarDeck < Deck

  def deal
    WarHand.new(@cards.shift(26))
  end

end

class BeloteDeck < Deck

  def deal
    BeloteHand.new(@cards.shift(8))
  end

end

class SixtySixDeck < Deck

  def deal
    SixtySixHand.new(@cards.shift(6))
  end

end

class Hand

  attr_accessor :cards
  def initialize(cards)
    @cards = cards
  end

  def size
    @cards.size
  end

  private

  def cards_by_suit(suit)
    @cards.select {|card| card.suit == suit}
  end

  def ranks_by_suit(suit)
    cards_by_suit(suit).map {|card| card.rank}
  end

  def has_king_and_queen_of_suit?(suit)
    (ranks_by_suit(suit) & [:king, :queen]).size == 2
  end

end

class BeloteHand < Hand

  def highest_of_suit(suit)
    cards = cards_by_suit(suit).max(&:compare_belote_cards_by_rank)
  end

  def belote?
    Card::SUITS.any? do |suit|
      has_king_and_queen_of_suit?(suit)
    end
  end

  def tierce?
    sequence?(3)
  end

  def quarte?
    sequence?(4)
  end

  def quint?
    sequence?(5)
  end

  def carre_of_jacks?
    four_of_a_kind?(:jack)
  end

  def carre_of_nines?
    four_of_a_kind?(9)
  end

  def carre_of_aces?
    four_of_a_kind?(:ace)
  end

  private

  def sequence?(number)
    Card::SUITS.any? do |suit|
      ranks = ranks_by_suit(suit)
      Card::BELOTE_RANKS.each_cons(number).any? do |consecutive_ranks|
        (consecutive_ranks & ranks).size == number
      end
    end
  end

  def four_of_a_kind?(rank)
    @cards.select {|card| card.rank == rank}.size == 4
  end
end

class WarHand < Hand

  def play_card
    played_card = @cards.sample
    @cards.delete(played_card)
  end

  def allow_face_up?
    @cards.size < 4
  end

end

class SixtySixHand < Hand

  def twenty?(trump_suit)
    Card::SUITS.reject {|suit| suit == trump_suit}.any? do |suit|
      has_king_and_queen_of_suit?(suit)
    end
  end

  def forty?(trump_suit)
    has_king_and_queen_of_suit?(trump_suit)
  end

end
