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

before '/api/v1/books > GET > 404 > text/html' do |transaction| 

  transaction['fullPath'] += "?title=Franklyn&id=100"  

end

before '/api/v1/books > POST > 201 > application/json; charset=utf-8' do |transaction|
  request_body = {}
  param = {}

  param['title'] = 'ReynaPost'
  param['author'] = 'Selam'
  request_body['book'] = param
  transaction['request']['body'] = request_body.to_json
end

before '/api/v1/books/{id} > DELETE > 204 > ' do |transaction|
  book = stash['book']
  transaction['fullPath'] = "/api/v1/books/#{book.id}"

end

require File.expand_path('../../config/environment', __dir__) 


