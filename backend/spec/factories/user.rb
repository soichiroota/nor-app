FactoryBot.define do
    factory :user do
      name { "TestUser" }
      sequence(:email) { |n| "test#{n}@example.com" } #<=一意の値を生成してくれる。
      password { "foobar0" }
      password_confirmation { "foobar0" }
    end
  end