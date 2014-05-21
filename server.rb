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
      titles<<"#{hash[:Title]}^$#{hash[:ID]}"
    end

  titles.uniq.sort
end

def movie_info (file_name,movie_name,movie_id)

  all_data=get_data(file_name)
  @movie_info=[]

  all_data.each do |hash|

    if hash[:Title]==movie_name && hash[:ID]==movie_id
      @movie_info<< "Title: #{hash[:Title]}^$ Year: #{hash[:Year]}^$ Rating: #{hash[:Rating]}^$ Genre: #{hash[:Genre]}^$ Studio: #{hash[:Studio]}^$ Synopsis: #{hash[:Synopsis]}"
    end
  end
  @movie_info
end


get '/movies' do
  @movies=movie_titles('movies.csv')

  erb :index
end

get '/movies/:movie_id/:id_num' do
  #will want to somehow make this list be dictated by above
  #and have links created from @teams
  @movie_spec = params[:movie_id]
  @id_num=params[:id_num]

  @movie_info=movie_info('movies.csv',@movie_spec,@id_num)

  erb :movie
end



