# frozen_string_literal: true

# Responsible for management of book requests
class RequestsController < ApplicationController
  EMAIL_REGEX = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.freeze

  # POST /request
  def create
    # Validate email format
    return render json: { error: 'invalid-email' }, status: :unprocessable_entity unless params[:email].match?(EMAIL_REGEX)
    # Validate existence of requested book
    return render json: { error: 'book-not-found' }, status: :not_found unless (book = Book.find_by(title: params[:title])).present?

    # Create new request if book is available
    # TODO: Add guarding in case multiple requests are made at once
    request = book.request || Request.create(book_id: book.id, email: params[:email])

    render json: request.api_attributes(requestor: params[:email]), status: :ok
  end

  # GET /request
  def all
    render json: Request.all.map(&:api_attributes), status: :ok
  end

  # GET /request/:id
  def find_by_book_id
    # Validate existence of request
    return render json: { error: 'request-not-found' }, status: :not_found unless (request = Request.find_by(book_id: params[:id])).present?

    render json: request.api_attributes, status: :ok
  end

  # DELETE /request/:id
  def delete_by_book_id
    # Validate existence of request
    return render json: { error: 'request-not-found' }, status: :not_found unless (request = Request.find_by(book_id: params[:id])).present?

    # Delete existing request
    request.destroy!

    render json: {}, status: :ok
  end
end
