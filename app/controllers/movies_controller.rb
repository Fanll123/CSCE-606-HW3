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
    #redirect = false

    @all_ratings = Movie.pluck(:rating).uniq

    @sort = params[:sort_by] ? params[:sort_by] : session[:sort_by]
    session[:sort_by] = @sort

    @ratings_sel = params[:ratings] ? params[:ratings] : session[:ratings]
    session[:ratings] = @ratings_sel

    if @ratings_sel == nil
      @ratings_sel = @all_ratings
    else
      @ratings_sel = @ratings_sel.keys
    end
    
    if (params[:sort_by] != session[:sort_by]) || (params[:ratings] != session[:ratings])
      flash.keep
      redirect_to movies_path :sort_by=> session[:sort_by], :ratings=> session[:ratings]
      return
    end

    @movies = Movie.order(@sort).where(:rating => @ratings_sel)

#    session[:sort_by] = @sort
#    session[:ratings] = @ratings_sel
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
