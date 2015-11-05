class Card
  attr_accessor :rank, :suit
  
  SUITS = [:spades, :hearts, :diamonds, :clubs]
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]

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

  def <(other)
    SUITS.index(@suit) < SUITS.index(other.suit) ||
    @suit == other.suit && RANKS.index(@rank) > RANKS.index(other.rank)
  end

  def <=>(other)
    self == other ? 0 : self < other ? -1 : 1 
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

  def to_s
    @cards.each {|card| puts card}
    nil
  end

  def set_ranks
    case self
      when WarDeck then @ranks = Card::RANKS
      when BeloteDeck then @ranks = Card::RANKS.drop_while {|rank| rank != 7}
      else @ranks = Card::RANKS.drop_while {|rank| rank != 9}
    end
  end

  def set_cards(cards)
    if cards
      @cards = cards
    else
      @cards = @ranks.product(@suits).map {|rank, suit| Card.new(rank, suit)}
    end
  end

end

class WarDeck < Deck

  def deal
    WarHand.new(@cards.take(26))
  end

end

class BeloteDeck < Deck

end

class SixtySixDeck < Deck


end

class Hand

  def initialize(cards)
    @cards = cards
  end

  def size
    @cards.size
  end

  def cards_by_suit(suit)
    @cards.select {|card| card.suit = suit}
  end

end

class BeloteHand < Hand

  def highest_of_suit(suit)
    cards_by_suit(suit).max
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
    
  end

  def forty?(trump_suit)
    cards_by_suit(trump_suit).
  end

end
