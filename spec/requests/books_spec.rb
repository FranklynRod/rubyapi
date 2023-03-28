require 'rails_helper'

describe 'Books API', type: :request do

    describe 'GET /books', appmap: true do
        it "return all books" do 
            get '/api/v1/books'
            res = JSON.parse(response.body)
            p res
            expect(response).to have_http_status(:ok)
            expect(res).not_to be(nil)
        end
    end

    describe 'GET /books/:title/:id', appmap: true do
        let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        context 'when we get a book by title and ID' do
            it "returns a book by title and ID" do
                get "/api/v1/books?title=#{book.title}&id=#{book.id}"
                res = JSON.parse(response.body)

                expect(response).to have_http_status(:ok)
                expect(response.body).to include("The Martian")
                expect(response.body).to include("1")
            end
        end
    end

    describe 'POST /books', appmap: true do
        context 'when create a book' do
            it 'creates a new book' do
                
                post '/api/v1/books', params: {book: {title: 'Lady Joker', author: 'Kaoru Takamura'}, headers: {"Content-Type" => "application/json"}}
                res = JSON.parse(response.body)
                expect(res).not_to be(nil)
                expect(response).to have_http_status(:created)
            end
        end
    end

    describe 'DELETE /books/:id', appmap: true do
        let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        context 'when delete a book' do
            it 'deletes a book' do
                delete "/api/v1/books/#{book.id}", params: {}

                expect(response).to have_http_status(:no_content)
            end
        end
    end
end