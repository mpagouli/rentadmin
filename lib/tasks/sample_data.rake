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
    name  = "group#{n+1}"
    description = "group#{n+1}"
    Group.create!(group_name: name, description: description)
  end
end

def make_makes
  5.times do |n|
    name  = "make#{n+1}"
    description = "make#{n+1}"
    Make.create!(make_name: name, description: description)
  end
end

def make_models
  groups = Group.all(limit: 4)
  makes = Make.all(limit: 4)
  group_index = 0
  makes.each do |make| 
    7.times do |n|
      name = "model#{groups[group_index].id}_#{n+1}"
      description = "model#{groups[group_index].id}_#{n+1}"
      mod = make.models.create!(model_name: name, description: description) 
      groups[group_index].models << mod
    end
    group_index += 1
  end
end

def make_vehicles
  models = Model.all(limit: 5)
  models[0..2].each do |model|
    20.times do |n|
      postfix = "AXV #{n} "
      reg_no = postfix + rand(6**6).to_s
      while reg_no.to_s.length != 12
        reg_no = postfix + rand(7**7).to_s 
      end
      model.vehicles.create!(reg_no: reg_no)   
    end
  end
  models[3..4].each do |model|
    20.times do |n|
      postfix = "AXZ #{n} "
      reg_no = postfix + rand(6**6).to_s
      while reg_no.to_s.length != 12
        reg_no = postfix + rand(7**7).to_s
      end
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