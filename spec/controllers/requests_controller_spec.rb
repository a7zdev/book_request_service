# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  describe 'POST #create' do
    subject { post :create, body: params.to_json }

    before do
      request.env['HTTP_ACCEPT'] = 'application/json'
      request.env['CONTENT_TYPE'] = 'application/json'
    end

    let!(:book) { Book.create(title: 'test title') }

    let(:params) do
      {
        email: 'john.doe@test.com',
        title: book.title
      }
    end

    describe 'failure' do
      context 'invalid email' do
        let(:params) do
          {
            email: 'john.doe@invalid',
            title: book.title
          }
        end
        let(:expected_body) { { error: 'invalid-email' } }

        it do
          is_expected.to have_http_status(422)
          expect(response.body).to eq(expected_body.to_json)
        end
      end

      context 'book does not exist' do
        let(:params) do
          {
            email: 'john.doe@test.com',
            title: 'some-random-title'
          }
        end
        let(:expected_body) { { error: 'book-not-found' } }

        it do
          is_expected.to have_http_status(404)
          expect(response.body).to eq(expected_body.to_json)
        end
      end

      context 'book has already been requested by another user' do
        let!(:book_request) { Request.create(email: 'jane.doe@test.com', book: book) }
        let(:expected_body) do
          {
            id: book.id,
            available: false,
            title: book.title,
            timestamp: book_request.created_at.iso8601
          }
        end

        it do
          is_expected.to have_http_status(200)
          expect(response.body).to eq(expected_body.to_json)
        end
      end
    end

    describe 'success' do
      context 'new request created' do
        let(:expected_body) do
          {
            id: book.id,
            available: true,
            title: book.title,
            timestamp: book.reload.request.created_at.iso8601
          }
        end

        it do
          is_expected.to have_http_status(200)
          expect(response.body).to eq(expected_body.to_json)
        end
      end

      context 'existing request for same user' do
        let(:expected_body) do
          {
            id: book.id,
            available: true,
            title: book.title,
            timestamp: book_request.created_at.iso8601
          }
        end
        let!(:book_request) { Request.create(book: book, email: params[:email]) }

        it do
          is_expected.to have_http_status(200)
          expect(response.body).to eq(expected_body.to_json)
        end
      end
    end
  end
end
