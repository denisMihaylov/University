def get_letters
  key_number = 1
  letters = ("a".."o").each_slice(3).map do |characters|
    key_number += 1
    characters << key_number.to_s
  end
  letters << (('p'..'s').to_a << '7')
  letters << (('t'..'v').to_a << '8') << (('w'..'z').to_a << '9')
end

CHARACTERS = [["1"], *get_letters, ["*"], [" ", "0"], ["#"]]

def presses_for_character(character)
  letters = CHARACTERS.find do |characters|
    characters.include?(character.downcase)
  end
  if letters.class.method_defined?(:find_index) then
    letters.find_index(character.downcase) + 1
  else
    0
  end
end

def button_presses(message)
  message.split("").reduce(0) do |presses, character|
    presses + presses_for_character(character)
  end
end
