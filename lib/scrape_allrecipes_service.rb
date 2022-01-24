require "open-uri"
require "nokogiri"

class ScrapeAllRecipesService
  def initialize(keyword, number_of_results)
    @keyword = keyword
    @number_of_results = number_of_results
  end

  def create_html_doc(url)
    Nokogiri::HTML(URI.open(url).read, nil, "utf-8")
  end

  def call
  url = "https://www.allrecipes.com/search/results/?search=#{@keyword}"
  html_doc = create_html_doc(url)

  search_results = html_doc.search(".card__detailsContainer")[..@number_of_results - 1].map do |element|
    title = element.search("h3").text.strip
    description = element.search(".card__summary").text.strip
    author = element.search(".card__authorName").text.strip
    recipe_url = element.search(".card__titleLink.manual-link-behavior")[0]["href"]
    rating = element.search(".review-star-text").text.strip.scan(/\d\.?\d?\d?/)[0]
    prep_time = create_html_doc(recipe_url).search(".recipe-meta-item-body")[0].text.strip
    { title: title, description: description, author: author, url: recipe_url, rating: rating, prep_time: prep_time }
  end
end
end
