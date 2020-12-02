# frozen_string_literal: true

# Controller responsible for returning the collection of library books
class BooksController < ApplicationController
  def all
    render json: Book.all.map { |b| { id: b.id, title: b.title } }.to_json, status: :ok
  end
end
