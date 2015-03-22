FactoryGirl.define do

  factory :user, class: User do
    first_name { Forgery(:name).first_name }
    sequence(:email) { |n| "user#{n}@email.com" }
  end

  factory :user_with_supports, parent: :user do

    ignore do
      supports_count 1
    end

    after(:create) do |user, evaluator|
      evaluator.supports_count.times do
        create(:done_support, user: user)
      end
    end
  end

end
