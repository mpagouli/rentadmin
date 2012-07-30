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
    sequence(:make_name)  { |n| "Test Make#{n}" }
    sequence(:description) { |n| "Test Description#{n}"}
  end

  factory :group do
    sequence(:group_name)  { |n| "Test Group#{n}" }
    sequence(:description) { |n| "Description#{n}"}
  end

  factory :model do
    sequence(:model_name)  { |n| "Test Model#{n}" }
    sequence(:description) { |n| "Description#{n}"}
    make
    group
  end

  factory :vehicle do
    sequence(:reg_no) { |n| "AAA #{n}" }
    model
  end 

  factory :client do
    sequence(:name)  { |n| "Customer #{n}" }
    sequence(:surname)  { |n| "Surname #{n}" }
    sequence(:email) { |n| "customer_#{n}@example.com"}   
  end

  factory :reservation do
    sequence(:reservation_code) { |n| "ResCode #{n}" }
    sequence(:pick_up_date) { |n| Date.today + n }
    sequence(:drop_off_date) { |n| Date.today + n + (n % 10) + 1 }
    sequence(:duration) { |n| (Date.today + n + (n % 10) + 1) - (Date.today + n) }
    vehicle
    client
  end 

end