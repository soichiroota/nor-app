require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.build(:user) }

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(
      user,
      'https://example.com',
      true
    ) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq(["test1@example.com"])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "password_reset" do
    before { user.reset_token = User.new_random_token }

    let(:mail) { UserMailer.password_reset(
      user,
      'https://example.com',
      true
    ) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["test3@example.com"])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match user.reset_token
    end
  end

end
