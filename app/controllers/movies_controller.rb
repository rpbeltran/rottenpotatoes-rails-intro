class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings   = Movie.ratings
    @ratings       = params.key?("ratings") ? params[:ratings].keys : ( session.key?("ratings") ? session["ratings"] : @all_ratings )
    @ratings_query = @ratings.length == 0 ? "" : ( "ratings[" + @ratings.join( "]=1&ratings[" ) + "]=1&" )
    @sort_by       = params.key?("sort_by") ? params[:sort_by] : ( session.key?("sort_by") ? session["sort_by"] : "title" )
    @movies        = Movie.where( rating: @ratings ).order( @sort_by )

    session["ratings"] = @ratings
    session["sort_by"] = @sort_by

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
