require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it 'should be valid' do
    expect(user).to be_valid
  end

  it 'is invalid with no name' do
    user.name = ' '
    expect(user).to be_invalid
  end

  it 'is invalid with no mail' do
    user.email = ' '
    expect(user).to be_invalid
  end

  it 'is invalid with 51-letter names' do
    user.name = 'a' * 51
    expect(user).to be_invalid
  end

  it 'is invalid with 256-letter mails' do
    user.name = 'a' * 244 + 'example.com'
    expect(user).to be_invalid
  end

  it 'is valid with the correct email\'s format' do
    valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn)
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid 
    end
  end

  it 'is invalid with the wrong email\'s format' do
    invalid_addresses = %w(user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com)
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to be_invalid
    end
  end

  it "is invalid with registered email" do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user).to be_invalid
  end

  it "is invalid with registered email" do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).to be_invalid
  end

  it 'is invalid with no password' do
    user.password = user.password_confirmation = ' ' * 6
    expect(user).to be_invalid
  end

  it 'is invalid with 5-letter passwords' do
    user.password = user.password_confirmation = 'a' * 5
    expect(user).to be_invalid
  end

  # authenticated?のテスト
  it 'returns false for a user with nil digest' do
    expect(user.authenticated?(:activation, '')).to be_falsy
  end

  describe "follow and unfollow" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    before { user.follow(other_user) }

    describe "follow" do
      it "succeeds" do
        expect(user.following?(other_user)).to be_truthy
      end

      describe "followers" do
        it "succeeds" do
          expect(other_user.followers.include?(user)).to be_truthy
        end
      end
    end

    describe "unfollow" do
      it "succeeds" do
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be_falsy
      end
    end
  end

  describe "def feed" do
    let(:user) { FactoryBot.create(:user, :with_microposts) }
    let(:other_user) { FactoryBot.create(:user, :with_microposts) }

    context "when user is following other_user" do

      before { user.active_relationships.create!(followed_id: other_user.id) }

      it "contains other user's microposts within the user's Micropost" do
        other_user.microposts.each do |post_following|
          expect(user.feed.include?(post_following)).to be_truthy
        end
      end

      it "contains the user's own microposts in the user's Micropost" do
        user.microposts.each do |post_self|
          expect(user.feed.include?(post_self)).to be_truthy
        end
      end
    end

    context "when user is not following other_user" do
      it "doesn't contain other user's microposts within the user's Micropost" do
        other_user.microposts.each do |post_unfollowed|
          expect(user.feed.include?(post_unfollowed)).to be_falsy
        end
      end
    end
  end
end
