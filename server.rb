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

def get_search_results(array, search_term)
  @movies=[]
  array.each do |elem|
    new_elem=elem.split("^$")[0].downcase
    if new_elem.include? search_term.downcase
      @movies.push(elem)
    end
  end
  @movies
end


get '/movies' do
  @movies_all=movie_titles('movies.csv')
  @page=params[:page].to_i
  @index= @page*20

  @movies=@movies_all.slice(@index,20)

  @query=params[:query]


  if @query != nil
    if @movies_all.any? { |elem| elem.include? @query }
      @movies=get_search_results(@movies_all,@query)
      #@movies=@movies_all.slice(0,5)
    else
      @message="Search did not match any results."
    end

  end

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



