class Book < ApplicationRecord
    validates :author, presence: true
    validates :title, presence: true
    # validates :author, presence: true, length: { minimum: 3 }
    # validates :title, presence: true, length: { minimum: 3 }
end
