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

  factory :make do
    sequence(:make_name)  { |n| "Make#{n}" }
    sequence(:description) { |n| "Description#{n}"}
  end

  factory :group do
    sequence(:group_name)  { |n| "Group#{n}" }
    sequence(:description) { |n| "Description#{n}"}
  end

  factory :model do
    sequence(:model_name)  { |n| "Model#{n}" }
    sequence(:description) { |n| "Description#{n}"}
    make
    group
  end

  factory :vehicle do
    sequence(:reg_no) { |n| "#{n}" }
    model
  end 

end