require 'rails_helper'

describe 'Books API', type: :request do
    let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }

    describe 'GET /books', appmap: true do
        let!(:book1) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        let!(:book2) { FactoryBot.create(:book, title:'Night', author: 'Elie Wiesel') }
        it "return all books" do 
            # binding.pry
            get '/api/v1/books'
            res = JSON.parse(response.body)
            # puts res
            expect(response).to have_http_status(:ok)
    
            expect(res.length).to eq(Book.count) 
            expect(res.length).to eq(3)
        
        end
    end

    # describe 'GET /books/:title', appmap: true do
    #     let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
    #     let!(:book) { FactoryBot.create(:book, title:'Night', author: 'Elie Wiesel') }
    #     context 'when we get a book by title' do
    #         it "returns a book by title" do
    #             get "/api/v1/books?title=#{book.title}"
    #             res = JSON.parse(response.body)
    #             expect(response).to have_http_status(:ok)
    #             expect(res).to have_key("title")
    #             expect(res).to have_key("author")
    #             expect(res).to have_key("id")
    #             expect(res).to have_key("created_at")
    #             expect(res).to have_key("updated_at")
    #             expect(res["title"]).to eq(book.title)
    #         end
    #     end
    # end

    describe 'GET /books/:title/:id', appmap: true do
        let!(:book) { FactoryBot.create(:book, title:'The Martian', author: 'Andy Weir') }
        let!(:book1) { FactoryBot.create(:book, title:'Night', author: 'Elie Wiesel') }
        context 'when we get a book by title and ID' do
            it "returns not found with a missing title or ID" do
                get "/api/v1/books?title=Hello&id=9999"
                expect(response).to have_http_status(:not_found)
            end
            it "returns a book by title and ID" do
                get "/api/v1/books?title=#{book.title}&id=#{book.id}"
                res = JSON.parse(response.body)
                expect(response).to have_http_status(:ok)
                expect(res["title"]).to eq(book.title)
                expect(res["id"]).to eq(book.id)
                expect(res["author"]).to eq(book.author)
                expect(res).to have_key("created_at")
                expect(res).to have_key("updated_at")


            end
        end
    end

    describe 'POST /books', appmap: true do
        context 'when create a book' do
            it 'creates a new book' do
                post '/api/v1/books', params: {book: {title: 'Lady Joker', author: 'Kaoru Takamura'}, headers: {"Content-Type" => "application/json"}}
                res = JSON.parse(response.body)
                expect(res["title"]).to eq('Lady Joker')
                expect(res["author"]).to eq('Kaoru Takamura')
                expect(response).to have_http_status(:created)
            
            end
        end
    end

    describe 'DELETE /books/:id', appmap: true do
        context 'when delete a book' do
            it 'deletes a book' do
                delete "/api/v1/books/#{book.id}", params: {}
                expect(response).to have_http_status(:no_content)
                # expect(response).to have_http_status(:ok)
                expect(Book.exists?(book.id)).to be false
                expect(Book.count).to eq 0
            end
        end
    end
end