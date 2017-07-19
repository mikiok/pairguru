module Api
  module V1
    class MoviesController < ApplicationController

      def index
        if params[:genre_id] != nil
          movies = Movie.where(genre_id: params[:genre_id])
        else
          movies = Movie.all
        end
        render json: movies
      end

      def show
        render json: Movie.find(params[:id])
      end

    end
  end
end