FactoryBot.define do
    factory :user do
      name { "TestUser" }
      sequence(:email) { |n| "test#{n}@example.com" } #<=一意の値を生成してくれる。
      password { "foobar0" }
      password_confirmation { "foobar0" }
      activated { true }
      activated_at { Time.zone.now }

      trait :no_activated do
        activated { false }
        activated_at { nil }
      end

      trait :with_microposts do
        after(:create) { |user| create_list(:micropost, 5, user: user)}
      end
    end
  end