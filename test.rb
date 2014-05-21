require 'CSV'
require 'pry'
require 'pry'

#Gets all data from CSV file into array of hashes
def get_data(file_name)
  @all_data=[]

  CSV.foreach(file_name, :headers => true) do |row|
    id=row["id"]
    title=(row["title"]).tr(" ","_")
    year=row["year"]
    synopsis=row["synopsis"]
    rating=row["rating"]
    genre=row["genre"]
    studio=row["studio"]

    @all_data.push( {:ID => id, :Title => title, :Year => year, :Synopsis => synopsis, :Rating => rating, :Genre => genre, :Studio => studio} )
  end
  @all_data
end

def movie_titles (file_name)
  all_data=get_data(file_name)
  titles=[]

  all_data.each do |hash|
      titles<<hash[:Title]
    end

  titles
end

def movie_info (file_name,movie_name)

  all_data=get_data(file_name)
  @movie_info=[]

  all_data.each do |hash|

    if hash[:Title]==movie_name
      @movie_info<< "#{hash[:Title]}, #{hash[:Year]}, #{hash[:Rating]}, #{hash[:Genre]}, #{hash[:Studio]}, #{hash[:Synopsis]}"
    end
  end
  @movie_info
end

def get_search_results(array, search_term)
  @movies=[]
  array.each do |elem|
    elem=elem.split("^$")[0].downcase
    if elem.include? search_term.downcase
      @movies.push(elem)
    end
  end
  @movies
end

print get_search_results((movie_titles('movies.csv')),'fox')
