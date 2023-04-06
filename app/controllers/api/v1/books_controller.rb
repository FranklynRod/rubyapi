module Api
  module V1
    class BooksController < ApplicationController
      
      def index
        title = allowed_params[:title]
        id = allowed_params[:id]
        
        if title.present? && id.present?
          render json: Book.find_by!(title: title, id: id)
        elsif title.present? 
          render json: Book.find_by!(title: title)
        elsif id.present? 
          render json: Book.find_by!(id: id)
        else
          render json: Book.all 
        end
      rescue ActiveRecord::RecordNotFound => e
        render json: {errors: true, errors: [e.message]}, status: :not_found

      rescue ActiveRecord::ConnectionNotEstablished => e
        render json: {errors: true, errors: [e.message]}, status: :internal_server_error
      end

      def allowed_params
        params.permit(:title, :id)
      end

      def create
        book= Book.new(book_params)
        if book.save
          render json: book, status: :created
        else
          render json: book.errors, status: :unprocessable_entity
        end
      end

      def destroy
        Book.find(params[:id]).destroy!
        render body: nil, status: :no_content
      # rescue ActiveRecord::ConnectionNotEstablished => e
      #   render json: {errors: true, errors: [e.message]}, status: :internal_server_error
        # render json: {result: true, status: :no_content}
        # head :no_content
        # head :ok
      end

      private

      def book_params
        params.require(:book).permit(:title, :author)
      end
    
    end
  end
end
