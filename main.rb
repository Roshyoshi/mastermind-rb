require 'colorize'
$colors = {
    "o" => :light_red,
    "b" => :blue,
    "g" => :green,
    "r" => :red,
    "v" => :magenta,
    "y" => :light_yellow
  }

class Text
   attr_reader :text, :content
   def initialize(text)
    @content = text.chars.map { |char| ColoredChar.new(char) }
    @text = text
    end

  def p
    @content.each do |char|
      char.cprint
    end
    puts "\n"
  end

end 


class ColoredChar 
  attr_accessor :char, :color
  def initialize(char)
    @char = char
    @color = $colors[char]
  end 

  def cprint
    print(@char.colorize(:color => :black, :mode => :bold, :background => @color))
  end 
end

module GameTools
  def feedback(guess, curr)
    win = true
    guess.text.chars.each_with_index do |char, index|
      if curr.text[index] == char
        print("#{index + 1}".colorize(:color => :black, :background => :green, :mode => :bold))
      elsif curr.text.include?(char)
        print("#{index + 1}".colorize(:mode => :bold, :color => :black, :background => :light_yellow))
        win = false
      else
        print("#{index + 1}".colorize(:mode => :bold, :color => :black, :background => :red))
        win = false
      end
    end
    
    puts "\n\n"
    if win
      puts "You have cracked the code!"
      exit 0
    end
  end

  def computer_guess
    guess = $colors.keys.shuffle.slice(0, 4).join("")
    return guess
  end
  
  def usr_input
    invalid = true
    print_colors()
    while invalid
      puts "Enter a valid character guess based on the available colors above. Duplicates are not allowed!"
      guess = gets.chomp.downcase
      if guess == guess.squeeze && guess.length == 4
        invalid = false
      else 
        puts "You have entered more than 4 characters, or duplicate colors. Please try again."
      end
    end
    return guess
  end

  def print_colors
    c = Text.new($colors.keys.join(""))
    c.p
  end
end

class Mastermind
  include GameTools
  attr_accessor :key
  def initialize(guess=nil)
    if guess == nil
      @key = Text.new(computer_guess())
    else
      @key = Text.new(guess)
    end
    @curr_code = nil
    
  end
  
  def turn
    @curr_code = Text.new(usr_input())
    print "You entered: "
    @curr_code.p
    
    print("This is how your code compares to the secret code. Green is correct, yellow is in the wrong spot, and red is incorrect.\n")
    feedback(@key, @curr_code)
  end
end

puts "Welcome to Mastermind!"
game = Mastermind.new()
12.times { game.turn }

print "You lose!"
