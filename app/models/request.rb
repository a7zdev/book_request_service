# frozen_string_literal: true

# This class represents a request for a book
# Currently, there can only be one request on a book at any given time.
class Request < ApplicationRecord
  #------------------------------
  # Validations
  #------------------------------
  validates_presence_of :email
  validates :book, presence: true, uniqueness: true

  #------------------------------
  # Associations
  #------------------------------
  belongs_to :book

  #------------------------------
  # Instance Methods
  #------------------------------

  #
  # Return attributes to be used in api responses
  #
  # @param [String] requestor The email of the requestor; Provides context for the attributes
  # (e.g. available is true if the requestor is also the user the request is for)
  #
  # @return [Hash] The api attributes
  #
  def api_attributes(requestor: nil)
    {
      id: book.id,
      available: requestor == email,
      title: book.title,
      timestamp: created_at.iso8601
    }
  end
end
