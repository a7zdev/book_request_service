# frozen_string_literal: true

# This model represents a library book
class Book < ApplicationRecord
  #------------------------------
  # Validations
  #------------------------------
  validates :title, uniqueness: true, presence: true

  #------------------------------
  # Associations
  #------------------------------
  has_one :request
end
