require 'rails_helper'

describe 'Books API', type: :request do

    describe 'GET /books', appmap: true do
        it "return all books" do
            FactoryBot.create(:book, title:"Reyna", author:"Selam") 
            FactoryBot.create(:book, title:"Franklyn", author:"Melley") 
            get '/api/v1/books'
            
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body).size).to eq(2)
        end
    end

    describe 'POST /books', appmap: true do
        it 'creates a new book' do
            expect {
                post '/api/v1/books', params: {book: {title: 'Lady Joker', author: 'Kaoru Takamura'}}
            }.to change { Book.count }.from(0).to(1)
            
            expect(response).to have_http_status(:created)
        end
    end

    describe 'DELETE /books/:id', appmap: true do
        let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        
        it 'deletes a book' do
            expect {
                delete "/api/v1/books/#{book.id}"
            }.to change { Book.count }.from(1).to(0)

        expect(response).to have_http_status(:no_content)
        end
    end
    
end