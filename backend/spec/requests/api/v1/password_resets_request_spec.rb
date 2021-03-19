require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { FactoryBot.create(:user) }

# edit,updateアクションへのテストで必要です。
  before { user.create_reset_digest }

  describe "def create" do
    # メールアドレスが無効
    it 'falis create with invalid email' do
      post api_v1_password_resets_path, params: { password_reset: { email: "" } }
      aggregate_failures do
        expect(response).to have_http_status(200)
        expect(response.body).to include "{\"user\":null}"
      end
    end

    # メールアドレスが有効
    it 'succeds create with valid email' do
      post api_v1_password_resets_path, params: { password_reset: { email: user.email } }
      aggregate_failures do
        expect(user.reset_digest).not_to eq user.reload.reset_digest
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end
  end

  describe "def update" do
    # 無効なパスワードとパスワード確認
    context "when user sends wrong password" do
      before do
        patch api_v1_password_reset_path(user.reset_token),
              params: {   
                user: {
                  email: user.email,
                  password: "foobaz",
                  password_confirmation: "barquux",
                },
              }
      end

      it 'fails' do
        aggregate_failures do
          expect(response).to have_http_status(200)
          expect(response.body).to include "{\"user\":null,\"errors\":[\"Password は英数6文字以上で指定してください。\"],\"token\":null}"
        end
      end
    end

    # パスワードが空
    context "when user sends blank password" do
      before do
        patch api_v1_password_reset_path(user.reset_token),
              params: {
                user: {
                  email: user.email,
                  password: "",
                  password_confirmation: "",
                },
              }
      end

      it 'fails' do
        aggregate_failures do
          expect(response).to have_http_status(200)
          expect(response.body).to include "{\"user\":null,\"errors\":[\"Password can't be blank\"],\"token\":null}"
        end
      end
    end
  end
end