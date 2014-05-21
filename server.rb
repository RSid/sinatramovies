require 'sinatra'
require 'uri'
require 'CSV'
require 'pry'
require 'shotgun'

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

  titles.uniq.sort
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


get '/movies' do
  @movies=movie_titles('movies.csv')

  erb :index
end

get '/movies/:movie_id' do
  #will want to somehow make this list be dictated by above
  #and have links created from @teams
  @movie_spec = params[:movie_id]

  @movie_info=movie_info('movies.csv',@movie_spec)

  erb :movie
end



