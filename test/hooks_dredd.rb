require 'dredd_hooks/methods'

include DreddHooks::Methods

before_all do |transactions|
  puts 'before all'
end

before_each do |transaction|
  puts 'before each'
end

before "Machines > Machines collection > Get Machines" do |transaction|
  puts 'before'
end

before_each_validation do |transaction|
  puts 'before each validation'
end

before_validation "Machines > Machines collection > Get Machines" do |transaction|
  puts 'before validations'
end

after "Machines > Machines collection > Get Machines" do |transaction|
  puts 'after'
end

after_each do |transaction|
  puts 'after_each'
end

after_all do |transactions|
  puts 'after_all'
end