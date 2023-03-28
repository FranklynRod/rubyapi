# class ApplicationRecord < ActiveRecord::Base
#   primary_abstract_class
# end

# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end