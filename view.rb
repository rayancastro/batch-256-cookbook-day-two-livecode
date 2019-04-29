class View
  def display(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}. [#{recipe.done? ? 'X' : ' '}] #{recipe.name} (#{recipe.prep_time}): #{recipe.description}"
    end
  end

  def display_to_user(stuff)
    puts stuff
  end

  def ask_user_for(stuff)
    puts "#{stuff.capitalize}?"
    print "> "
    return gets.chomp
  end

  def ask_user_for_index
    puts "Index?"
    print "> "
    return gets.chomp.to_i - 1
  end
end
