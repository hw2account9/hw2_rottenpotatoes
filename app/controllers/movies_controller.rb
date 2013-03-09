class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
# March 6 hw2 1.b

  def index

    @all_ratings=Movie.all_ratings
      bad_uri = false

# March 8 hw2 3
    if session[:sort] == nil then session[:sort] = 'title' end
    
    if params[:sort] == nil
     params[:sort] = session[:sort]
     bad_uri = true
    else 
      session[:sort] = params[:sort] 
    end


    @ratings = params[:ratings] || {}

    if session[:ratings] == nil 
      session[:ratings] ={}
      @all_ratings.each { |e| session[:ratings]='on' }
    end

    if @ratings == {}
     @ratings = session[:ratings] 
     bad_uri = true
    else
     session[:ratings] = params[:ratings] 
    end


    # if @ratings != nil
    #   movies = []
    #   @movies.each { |movie| if (@ratings[movie.rating]) then movies.push(movie) end }
    #   @movies = movies
    # end

    @movies = (Movie.where(:rating => @ratings.keys))
    @movies = @movies.order(params[:sort])


    if params[:sort]=="title"
      @titleclass = "hilite"
      @dateclass = nil
    else
      @titleclass = nil
      @dateclass = "hilite"
    end
    if bad_uri
      tmpsort =session[:sort]
      flash.keep
      redirect_to ratings: session[:ratings], sort: tmpsort && return
    end
    # @movies = Movie.all
  end



#-----------------
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
