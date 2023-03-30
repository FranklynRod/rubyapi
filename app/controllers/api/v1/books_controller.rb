module Api
  module V1
    class BooksController < ApplicationController
      
      # def index
      #   render json: Book.all
      # end

      def index
        title = allowed_params[:title]
        id = allowed_params[:id]
        if title.present? && id.present?
          render json: Book.find_by!(title: title, id: id)
        #   find_by returns nil
        #   find_by! throws a NotFound exception
        else
          render json: Book.all
        end
      rescue ActiveRecord::RecordNotFound => e
        head :not_found
      end
      
      def allowed_params
        params.permit(:title, :id)
      end

      def create
        # book= Book.new(title:params[:title],author:params[:author])
        book= Book.new(book_params)
        if book.save
          render json: book, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end

      def destroy
        Book.find(params[:id]).destroy!

        head :no_content
      end

      private

      def book_params
        params.require(:book).permit(:title, :author)
      end
    
    end
  end
end
