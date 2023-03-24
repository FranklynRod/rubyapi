# frozen_string_literal: true

require 'dredd_hooks/methods'
require 'httparty'

# rubocop:disable Style/MixinUsage
include DreddHooks::Methods
# rubocop:enable Style/MixinUsage

stash = {}

#Perform authentication and store response headers
before_all do |transactions|
  p "HERE"
end


require File.expand_path('../config/environment', __dir__)
