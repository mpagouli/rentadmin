FactoryGirl.define do
  # By passing the symbol :user to the factory command, 
  # we tell Factory Girl that the subsequent definition is for a User model object.
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"
    factory :admin do
      admin true
    end
  end
end