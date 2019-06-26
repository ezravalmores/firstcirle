class Style < ApplicationRecord
  self.inheritance_column = :_type_disabled
  has_many :items
end
