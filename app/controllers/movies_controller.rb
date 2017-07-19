class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  #expose_decorated(:movies) { Movie.all }
  #expose(:movie)

  def index
    @movies = Movie.all
    @apiMovies = []
    @movies.each do |movie|
      @apiMovies.push(apiMovie movie.title)
    end
    binding.pry
  end

  def show
    @movie = movie
    @apiMovie = apiMovie @movie.title
    @poster = 'https://pairguru-api.herokuapp.com' + @apiMovie["poster"]
    @comments = @movie.comments
    @comment = Comment.new
  end

  def send_info
    #If I use deliver_later instead of deliver_now I send emails asynchronously
    # and user doesn't have to wait
    MovieInfoMailer.send_info(current_user, movie).deliver_later
    redirect_to :back, notice: "Email sent with movie info"
  end

  def export
    MovieExport.perform_async(current_user)
    redirect_to root_path, notice: "Movies exported"
  end

  private

  def movie
    Movie.find_by(id: params[:id])
  end

  def apiMovie title
    url = 'https://pairguru-api.herokuapp.com/api/v1/movies/' + title
    uri = URI(url.gsub(' ','%20'))
    response = Net::HTTP.get(uri)
    JSON.parse(response)["data"]["attributes"]
  end
end
