class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

# class Lead < ApplicationRecord
#   validates :phone, format: { with: /\A\d{10}\z/, message: "debe tener 10 dígitos numéricos" }
# end