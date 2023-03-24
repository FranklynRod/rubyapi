#!/usr/bin/env ruby
# frozen_string_literal: true
require 'dredd_hooks/methods'
require 'httparty'
include DreddHooks::Methods

stash = {}

#Perform authentication and store response headers

before "/api/v1/books > GET > 200 > application/json; charset=utf-8" do |transaction|
  #Set the request headers getting from the stash variable
  FactoryBot.create(:book, title:"Reyna", author:"Selam") 
  FactoryBot.create(:book, title:"Franklyn", author:"Melley")
end
# Load Rails Server App
require File.expand_path('../config/environment', __dir__)