FactoryGirl.define do

  factory :user, class: User do
    sequence(:email) { |n| "user#{n}@email.com" }
  end

end
