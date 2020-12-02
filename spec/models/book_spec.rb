# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'creation' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:request) }
  end
end
