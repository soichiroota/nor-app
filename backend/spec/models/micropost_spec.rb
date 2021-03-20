require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.build(:user) }

  # associationで関連付けしているので、Userオブジェクトを自分で作らなくていい!!
  let(:micropost) { FactoryBot.create(:micropost) }
  
  it "is valid with micropost's test data" do
    expect(micropost).to be_valid
  end
  
  it "is invalid with no user_id" do
    micropost.user_id = nil
    expect(micropost).to be_invalid
  end
  
  it "is invalid with no content" do
    micropost.content = " "
    expect(micropost).to be_invalid
  end
  
  it "is invalid with 141-letter mails" do
    micropost.content = "a" * 141
    expect(micropost).to be_invalid
  end

  describe "Sort by latest" do
    # 評価される前にdbに保存されていないといけないので、「let!」を使用します。
    let!(:day_before_yesterday) { FactoryBot.create(:micropost, :day_before_yesterday) }
    # FactoryBot.create(:micropost, :now) を一番上に持ってくるとテストの意味がなくなるので注意です。
    let!(:now) { FactoryBot.create(:micropost, :now) }
    let!(:yesterday) { FactoryBot.create(:micropost, :yesterday) }
   
    it "succeeds" do
      expect(Micropost.first).to eq now
    end
  end

  describe "dependent: :destroy" do
    before do
      user.save
      user.microposts.create!(content: "Lorem ipsum")
    end

    it "succeeds" do
      expect do
        user.destroy
      end.to change(Micropost, :count).by(-1)
    end
  end
end
