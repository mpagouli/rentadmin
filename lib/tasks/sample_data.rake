namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_groups
    make_makes
    make_models
    make_vehicles
    make_users
  end
end

def make_groups
  5.times do |n|
    name  = Faker::Name.name
    description = "group#{n+1}"
    Group.create!(group_name: name, description: description)
  end
end

def make_makes
  5.times do |n|
    name  = Faker::Name.name
    description = "make#{n+1}"
    Make.create!(make_name: name, description: description)
  end
end

def make_models
  groups = Group.all(limit: 4)
  makes = Make.all(limit: 4)
  7.times do |n|
    group_index = 0
    name = 'model#{n+1}'
    description = "model#{n+1}"
    makes.each do |make| 
      mod = make.models.create!(model_name: name, description: description) 
      groups[group_index].models << mod
      group_index += 1
    end
  end
end

def make_vehicles
  models = Model.all(limit: 5)
  models[0..2].each do |model|
    3.times do |n|
      reg_no = Faker::Lorem.sentence(5) 
      model.vehicles.create!(reg_no: reg_no)   
    end
  end
  models[3..4].each do |model|
    2.times do |n|
      reg_no = rand(12)
      model.vehicles.create!(reg_no: reg_no)   
    end
  end
end

def make_users
  admin = User.create!(name: "Emily Pediaditi",
                       email: "epediaditi@example.com",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example#{n+1}@example.com"
    password  = "foobar"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end