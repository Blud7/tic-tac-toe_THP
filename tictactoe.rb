require 'pry'
require 'colorize'


class BoardCase
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end


class Player
  attr_accessor :firstname, :type

  def initialize(firstname, type)
    @firstname = firstname
    @type = type
    puts "#{@firstname}, tu joueras avec les #{@type}".green
  end
end


class Board
	
  attr_accessor :case_number

  def initialize
  
    @case_number = []
    for i in (1..9) 
      @case_number << BoardCase.new(i.to_s)
    end
    print_board
  end

  def print_board

    system 'clear'
    puts "|      |     |     |\n|  #{@case_number[0].value}   |  #{@case_number[1].value}  |  #{@case_number[2].value}  |\n|______|_____|_____|\n|      |     |     |\n|  #{@case_number[3].value}   |  #{@case_number[4].value}  |  #{@case_number[5].value}  |\n|______|_____|_____|\n|      |     |     |\n|  #{@case_number[6].value}   |  #{@case_number[7].value}  |  #{@case_number[8].value}  |\n|______|_____|_____|"

  end


  def play(choice, result)

    @case_number[choice - 1].value = result

  end

  def already_played?(choice)
    if @case_number[choice - 1].value == 'X'.green.bold || @case_number[choice - 1].value == 'O'.magenta.bold
      true
    else
      false
    end
  end

  def victory?
  
    win_combos = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    victory = 0
    win_combos.each do |combo|
      if @case_number[combo[0]].value == 'X'.green.bold && @case_number[combo[1]].value == 'X'.green.bold && @case_number[combo[2]].value == 'X'.green.bold
        victory = 1
      elsif @case_number[combo[0]].value == 'O'.magenta.bold && @case_number[combo[1]].value == 'O'.magenta.bold && @case_number[combo[2]].value == 'O'.magenta.bold
        victory = 2
      end
    end
    victory
  end
end



class Game
  attr_accessor :players, :board

  def initialize
   
    puts 'Quel est le nom du premier joueur ?'.yellow.underline

    player1_name = gets.chomp
    player1 = Player.new(player1_name, 'X'.green.bold)


    puts 'Quel est le nom du deuxième joueur ?'.yellow.underline

    player2_name = gets.chomp
    player2 = Player.new(player2_name, 'O'.magenta.bold)

    @players = [player1, player2]
    @board = Board.new

  end

  def go
 
     9.times do |i|

      if @board.victory? == 0
        turn(i)
      else
        if @board.victory? == 1 
          puts "#{@players[0].firstname} wins !".green.underline

        else 
          puts "#{@players[1].firstname} wins !".magenta.underline
        end
        exit
      end
    end
  end


  def turn(i)
    n = i % 2 
    puts "#{@players[n].firstname}, sur quelle case souhaites-tu jouer (entre 1 et 9) ?".yellow
    choice = gets.chomp.to_i

      if @board.already_played?(choice) == true
        puts " |©| Cette case est déjà prise ! |©| ".red.blink
        puts "#{@players[n].firstname}, choisis une nouvelle case entre 1 et 9 qui n'a pas été prise.".yellow
        choice = gets.chomp.to_i
      end

    @board.play(choice, @players[n].type)
    @board.print_board
  end
end

binding.pry

Game.new.go
