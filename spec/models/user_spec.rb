require 'rails_helper'

describe User do
  describe '#create' do
    it "is valid user_create" do
      user = build(:user)
      expect(user).to be_valid
    end
  end
end
