class MoviesController < ApplicationController

  # See Section 4.5: Strong Parameters below for an explanation of this method:
  # http://guides.rubyonrails.org/action_controller_overview.html
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_ratings ||= {}
    params[:sort]||= nil
    if params[:ratings] != session[:ratings] and @selected_ratings != {}
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    if params[:sort] != nil
      session[:sort] = params[:sort]
    end
    @movies = Movie.order(session[:sort]) 
    @movies = @movies.where(:rating => params[:ratings].keys) if params[:ratings].present?
    @all = Movie.all_ratings
    sort = session[:sort]
    if sort == "title" 
      @title_sorted = "hilite"
    end
    if sort == "release_date"
      @date_sorted = "hilite"
    end
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

  private :movie_params
  
end
