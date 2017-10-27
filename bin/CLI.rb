require_relative '../config/environment.rb'
require_relative 'api_communicator.rb'

 def welcome
   puts centralize_text("Welcome Art Fan!")
   divisor
   puts ""
   puts ""
 end

def get_user
   input= get_user_input("Please enter your name to log in")
   User.find_or_create_by(name: input)
 end

 def get_user_input(message="Please make your selection",echo = true)
   puts message
  echo == true ? input = gets.chomp : STDIN.noecho(&:gets).chomp
 end

def prints_menu(array,message = "Please make your selection")
  divisor
  puts ""
  puts ""
  puts message
  array.each_with_index {|memo,index| puts "#{index + 1} - #{memo}"}
  puts ""
  puts ""
  divisor
  puts ""
  puts ""
end

def prints_menu_horizontal(array,message = "")
  puts ""
  puts ""
  puts centralize_text(message)
  divisor
  menu = []
  array.each_with_index {|memo,index| menu << "#{index + 1} - #{memo}"}
  puts centralize_text(menu.join('          '))
  divisor
end

def create_collection(user)
  user.create_collection
end


def list_collections(user)
  clear_terminal
  user.collections.each_with_index{|x,index| puts "#{index +1} - #{x.name}"}
end

def get_collection(user)
  user_input = nil
  # binding.pry
  until (0..list_collections(user).length) === user_input.to_i
    puts "Please choose a collection or type 0 to go back"
    list_collections(user)
    user_input = get_user_input
  end
  if user_input != "0"
    list_collections(user)[(user_input.to_i) -1]
  end
end

def gallery_menu(user)
  counter = 0
  response = 0
  viewed_pages=[]
  pieces = get_pieces
  # add "self" hrefs to new array of past pages (use .pop to delete and return)
    until response == 4
      piece = pieces[:pieces][counter]
      piece.print
      prints_menu_horizontal(["Back","Next","Save","Exit"])
      response = get_user_input
      case response
      when "1"
        counter = pieces[:pieces].find_index(piece) -1
      when "2"
        counter = pieces[:pieces].find_index(piece) +1
      when "3"
        collection = select_collections(user)
        collection.pieces << piece
        collection.save
        puts "Saved To Your Collection"
        genes = pieces[:genes].select {|gene|gene == piece.to_s}.values[0]
        genes.each {|gene|piece.genes << Gene.new(name: gene)}
        piece.save
        counter = pieces[:pieces].find_index(piece) +1
      when "4"
        clear_terminal
        break
      end
      if counter < 0
          previous_page = viewed_pages.pop
          previous_page ? pieces = get_pieces(previous_page): nil
          counter = 4
      elsif counter > 4
        viewed_pages << pieces[:self]
        pieces = get_pieces(pieces[:next])
        counter = 0
      end
    end
end

def menu_1(user)
  loop do
  prints_menu(Menu_1)
  response = get_user_input
  case response
    when "1"
      menu_2(user)
    when "2"#{search gallery}
      gallery_menu(user)
    when "3"
      clear_terminal
      prints_menu([], centralize_text("Good Bye, #{user.name}"))
      good_bye = Piece.new(name: "good bye", img_url: "http://blog.monitis.com/wp-content/uploads/2012/02/ruby.jpeg")
      good_bye.print
      puts centralize_text("\\Learn---------------Love---------------Code\\")
      break
    end
  end
end


def menu_2(user)
  list_collections(user)
  prints_menu(Menu_2)
  user_input = get_user_input
  case user_input
  when "1"
    clear_terminal
    collection = select_collections(user)
    clear_terminal
    menu_3(user,collection)
  when "2"
    create_collection(user)
  else
    clear_terminal
  end
end

def menu_3(user,collection)
  clear_terminal
  puts collection.name
  prints_menu(Menu_3)
  case user_input = get_user_input
    when "1"
      new_name = get_user_input("Please type the new name for your collection")
      collection.name = new_name
      collection.save
    when "2"
        confirm = get_user_input("Are you sure you want to remove this collection? Yes/No")
        if confirm == "Yes"
          collection.destroy
          collection.save
          # had to include this, when item was destroyed it still persisted as an instance,
          # even though it was no longer existent on the database, this line deletes the instance
          user.collections.delete(collection)
          puts "The #{collection.name}, has been removed from your profile"
        end
     when "3"
      clear_terminal
      divisor
      pieces = collection.pieces.all.each_with_index {|piece,index| puts "#{index + 1} - #{piece.name}"}
      divisor
      if pieces.empty?
        print_menu([],"This collection is empty")
      else
        piece_input = get_user_input("Choose the Piece to see more options or type any other key to go back")
        piece_menu(collection.pieces.all[(piece_input.to_i) -1],collection,user)
     end
     when "4"
      search_for_pieces(user,collection)
    else
      clear_terminal
    end
end

def piece_menu(piece,collection,user)
  clear_terminal
  piece.print
  puts ""
  puts "====================================================================================================="
  puts centralize_text("General Information")
  Piece.local_methods.each {|keys| puts  "#{keys}: #{piece[keys]}"}
  puts ""
  puts ""
  divisor
  puts centralize_text("Genes")
  piece.genes.each {|gene| puts "#{gene.name}"}
  puts ""
  puts ""
  prints_menu_horizontal(["Remove From Collection","Go Back"])
  case  user_input = get_user_input
    when "1"
        confirm = get_user_input("Are you sure you want to remove the item from your collection? Yes/No")
        if confirm == "Yes"
          collection.pieces.find(piece.id).destroy
          puts "The #{piece.name}, has been removed from your collection"
        end
      else
        clear_terminal
  end

end



def exit
  puts "Thank you visiting us!!!"
end

def divisor
  puts "====================================================================================================="
end

def clear_terminal
  Gem.win_platform? ? (system "cls") : (system "clear")
end
def search_for_pieces(user,collection)
  clear_terminal
  prints_menu_horizontal(Piece.local_methods,"Search by")
  user_input = get_user_input
  if (1..5) === user_input.to_i
    search_string = get_user_input("Please enter the search value")
    if user_input == 1
      piece = collection.pieces.find_by(Piece.local_methods[(user_input.to_i) -1] => search_string.to_i)
    else
      piece = collection.pieces.find_by(Piece.local_methods[(user_input.to_i) -1] => search_string)
    end
    if piece
      piece_menu(piece,collection,user)
    else
      prints_menu([],"Sorry, but no match was found")
    end
  else
    prints_menu([],"Sorry, but that was an invalid entry, please try again!")
  end

end

def select_collections(user)
  clear_terminal
  prints_menu(user.collections.map{|collection|collection.name},"")
  selection = get_user_input(["Select Your Collection"])
  clear_terminal
  user.collections[(selection.to_i)- 1]
end

def centralize_text(string)
  base = "====================================================================================================="
  margin = (base.length - string.length) /2
  filler = ""
  margin.times{filler += " "}
  filler + string
end
