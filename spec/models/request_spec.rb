# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Request, type: :model do
  let!(:book) { Book.create(title: 'Test book volume 1') }

  describe 'creation' do
    subject { described_class.new(email: 'john.doe@example.com', book_id: book.id) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:book) }
    it { is_expected.to validate_uniqueness_of(:book) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:book) }
  end

  describe '#api_attributes' do
    subject { request.api_attributes(requestor: requestor) }

    let(:request) { described_class.create(email: 'test@testing.com', book_id: book.id) }
    let(:requestor) { nil }
    let(:expected_result) do
      {
        id: book.id,
        available: book_available,
        title: book.title,
        timestamp: request.created_at.iso8601
      }
    end
    let(:book_available) { false }

    context 'when requestor matches the email on the request' do
      let(:requestor) { request.email }
      let(:book_available) { true }

      it { is_expected.to eq(expected_result) }
    end

    context 'when requestor does not match the email on the request' do
      let(:requestor) { 'jane.doe@gmail.com' }
      it { is_expected.to eq(expected_result) }
    end

    context 'when no requestor is provided' do
      let(:requestor) { nil }
      it { is_expected.to eq(expected_result) }
    end
  end
end
