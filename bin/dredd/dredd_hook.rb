# frozen_string_literal: true

require 'dredd_hooks/methods'
require 'httparty'

# rubocop:disable Style/MixinUsage
include DreddHooks::Methods
# rubocop:enable Style/MixinUsage

stash = {}
# This hook resets the database
after_all do |transactions|
  puts "\n== Resetting DB =="
  system 'rails db:schema:load'
end

# Prepare one book
before_all do |transactions|
  # Using FactoryBot
  FactoryBot.create(:book, title: 'Reyna', author: 'Selam')

  # Using ActiveRecord
  book = Book.create(title: 'Franklyn', author: 'Melley')
  stash['book'] = book
end

before '/api/v1/books > GET > 200 > application/json; charset=utf-8' do |transaction|
  book = stash['book']
  puts book.id
end

before '/api/v1/books > GET > 404 > application/json; charset=utf-8' do |transaction| 
  book = stash['book']
  # add_params(transaction, "id", book.id)
  # add_params(transaction, "title", book.title)

  add_params(transaction, "id", 99999)
  add_params(transaction, "title", "Unknown")
end

before '/api/v1/books > GET > 200 > application/json; charset=utf-8' do |transaction|
  book = stash['book']
  puts book.title
end

before '/api/v1/books > GET > 404 > application/json; charset=utf-8' do |transaction| 
  book = stash['book']
  # add_params(transaction, "title", book.title)
  add_params(transaction, "title", "Unknown")

end

before '/api/v1/books > GET > 200 > application/json; charset=utf-8' do |transaction|
  book = stash['book']
  puts book.id
end

before '/api/v1/books > GET > 404 > application/json; charset=utf-8' do |transaction| 
  book = stash['book']
  # add_params(transaction, "id", book.id)
  add_params(transaction, "id", 99999)

end

# add query parameter to each transaction here
def add_params(transaction, param, value)
  param_to_add = "#{param}=#{value}"

  if transaction['fullPath']['?']
    transaction['fullPath'] += "&"
  else
    transaction['fullPath'] += "?"
  end

  transaction['fullPath'] += param_to_add
end


before '/api/v1/books > POST > 201 > application/json; charset=utf-8' do |transaction|
  request_body = {}
  param = {}

  param['title'] = 'ReynaPost'
  param['author'] = 'Selam'
  request_body['book'] = param
  transaction['request']['body'] = request_body.to_json
end

before '/api/v1/books > POST > 422 > application/json; charset=utf-8' do |transaction|
  request_body = {}
  param = {}

  # param['title'] = ""
  param['author'] = "1234"
  request_body['book'] = param
  transaction['request']['body'] = request_body.to_json
end

before '/api/v1/books/{id} > DELETE > 204 > ' do |transaction|
  book = stash['book']
  transaction['fullPath'] = "/api/v1/books/#{book.id}"

end

require File.expand_path('../../config/environment', __dir__) 


