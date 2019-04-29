require 'open-uri'
require 'nokogiri'

class ScrapeFrenchService
  def initialize(ingredient)
    @ingredient = ingredient
  end

  def call
    # 1. Open URL using keyword
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{@ingredient}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    # 2. Parse the HTML document to extract the first 5 recipes
    # and store them in a list
    result = []
    html_doc.search('.m_contenu_resultat').first(5).each do |recipe_div|
      # 2.1 Scrape the name of the recipe from the website
      name = recipe_div.search('.m_titre_resultat a').text.strip
      # 2.2 Scrape the description of the recipe from the website
      description = recipe_div.search('.m_texte_resultat').text.strip
      # 2.3 Scrape the prep_time of the recipe from the website
      prep_time = recipe_div.search('.m_prep_time')
      prep_time = (prep_time.empty? ? "" : prep_time.first.parent.text.strip)

      result << Recipe.new(name: name, description: description,
        prep_time: prep_time)
    end

    return result
  end
end
