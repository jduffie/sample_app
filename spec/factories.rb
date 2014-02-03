FactoryGirl.define do
  
  # :user is a variable passed to this test 
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end