require 'rails_helper'

describe 'Books API', type: :request do
    let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }

    describe 'GET /books', appmap: true do
        let!(:book1) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        let!(:book2) { FactoryBot.create(:book, title:'Night', author: 'Elie Wiesel') }
        context 'when we get a book' do
            it "returns internal server error with cannot connect to the db" do
                ActiveRecord::Base.remove_connection
                get "/api/v1/books"
                expect(response).to have_http_status(:internal_server_error)
                ActiveRecord::Base.establish_connection 
            end
            it "return all books" do 
                # binding.pry 
                get '/api/v1/books'
                res = JSON.parse(response.body)
                expect(response).to have_http_status(:ok)
                expect(res.length).to eq(Book.count) 
                expect(res[0]).to eq(book.as_json)
                expect(res[1]).to eq(book1.as_json)
                expect(res[2]).to eq(book2.as_json)
            end
        end
    end

    describe 'GET /books?title&id', appmap: true do
        let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        let!(:book1) { FactoryBot.create(:book, title:'Night', author: 'Elie Wiesel') }
        context 'when we get a book by title and ID' do
            it "returns internal server error with cannot connect to the db" do
                ActiveRecord::Base.remove_connection
                get "/api/v1/books?title=#{book.title}&id=#{book.id}"
                expect(response).to have_http_status(:internal_server_error)
                ActiveRecord::Base.establish_connection 
            end
            it "returns not found with a missing title or ID" do
                get "/api/v1/books?title=Hello&id=9999"
                expect(response).to have_http_status(:not_found)
            end
            it "returns a book by title and ID" do
                get "/api/v1/books?title=#{book.title}&id=#{book.id}"
                res = JSON.parse(response.body)
                expect(response).to have_http_status(:ok)
                expect(res).to eq(book.as_json)
            end
        end
    end

    describe 'GET /books?title', appmap: true do
        let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        let!(:book1) { FactoryBot.create(:book, title:'Night', author: 'Elie Wiesel') }
        context 'when we get a book by title' do
            it "returns internal server error with cannot connect to the db" do
                ActiveRecord::Base.remove_connection
                get "/api/v1/books?title=#{book.title}"
                expect(response).to have_http_status(:internal_server_error)
                ActiveRecord::Base.establish_connection 
            end
            it "returns not found with a missing title" do
                get "/api/v1/books?title=Hello"
                expect(response).to have_http_status(:not_found)
            end
            it "returns a book by title" do
                get "/api/v1/books?title=#{book.title}"
                res = JSON.parse(response.body)
                expect(response).to have_http_status(:ok)
                expect(res).to eq(book.as_json)
            end
        end
    end

    describe 'GET /books?id', appmap: true do
        let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        let!(:book1) { FactoryBot.create(:book, title:'Night', author: 'Elie Wiesel') }
        context 'when we get a book by id' do
            it "returns internal server error with cannot connect to the db" do
                ActiveRecord::Base.remove_connection
                get "/api/v1/books?id=#{book.id}"
                expect(response).to have_http_status(:internal_server_error)
                ActiveRecord::Base.establish_connection 
            end
            it "returns not found with a missing id" do
                get "/api/v1/books?id=99999"
                expect(response).to have_http_status(:not_found)
            end
            it "returns a book by id" do
                get "/api/v1/books?id=#{book.id}"
                res = JSON.parse(response.body)
                expect(response).to have_http_status(:ok)
                expect(res).to eq(book.as_json)
            end
        end
    end

    describe 'POST /books', appmap: true do
        context 'when create a book' do
            it "returns internal server error with cannot connect to the db" do
                ActiveRecord::Base.remove_connection
                post '/api/v1/books', params: {book: {title: 'Lady Joker', author: 'Kaoru Takamura'}, headers: {"Content-Type" => "application/json"}}
                expect(response).to have_http_status(:internal_server_error)
                ActiveRecord::Base.establish_connection 
            end
            it 'creates a new book' do
                post '/api/v1/books', params: {book: {title: 'Lady Joker', author: 'Kaoru Takamura'}, headers: {"Content-Type" => "application/json"}}
                res = JSON.parse(response.body)
                expect(response).to have_http_status(:created)
                expect(res["title"]).to eq('Lady Joker')
                expect(res["author"]).to eq('Kaoru Takamura')            
            end
            it 'returns error status code for invalid request' do
                post '/api/v1/books', params: {book: {title: ""}, headers: {"Content-Type" => "application/json"}}
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe 'DELETE /books/:id', appmap: true do
        context 'when delete a book' do
            it "returns internal server error with cannot connect to the db" do
                ActiveRecord::Base.remove_connection
                delete "/api/v1/books/#{book.id}", params: {}
                expect(response).to have_http_status(:internal_server_error)
                ActiveRecord::Base.establish_connection 
            end
            it 'deletes a book' do
                delete "/api/v1/books/#{book.id}", params: {}
                expect(response).to have_http_status(:no_content)
                expect(response.body).to be_empty
                expect(Book.exists?(book.id)).to be false
                expect(Book.count).to eq 0
            end
        end
    end
end