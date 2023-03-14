require 'rails_helper'

describe 'Books API', type: :request do
    it "return all books" do
        FactoryBot.create(:book, title:"Reyna", author:"Selam") 
        FactoryBot.create(:book, title:"Franklyn", author:"Melley") 
        get '/api/v1/books'
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(2)
    end
end