namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_groups
    make_makes
    make_models
    make_vehicles
    make_users
    make_clients
    make_reservations
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

def make_clients
  40.times do |n|
    fullname = Faker::Name.name
    name = fullname.split(" ")[0]
    surname = fullname.split(" ")[1]
    email = "cust_example#{n+1}@example.com"
    Client.create!(name: name, 
                   surname: surname,
                   email: email)
  end
end

def make_reservations
  clients = Client.all(limit: 20)
  vehicles = Vehicle.all(limit: 20)
  clients[0..9].each_with_index do |client,i|
      daysecs = 24*60*60;
      counter = 3 * daysecs;
      status = 'PENDING'
      2.times do |n|
        stD = Date.today.to_time_in_current_zone + counter
        eD = stD + counter + 2 * daysecs
        duration = eD -stD
        resCode = rand(12**12).to_s
        while resCode.to_s.length != 12
          resCode = rand(12**12).to_s
        end
        res = vehicles[i].reservations.new(pick_up_date: stD, duration: duration, drop_off_date: eD, reservation_code: resCode, status: status)
        res.client = client
        res.save!
        counter += 30
        status = 'CONFIRMED'
      end
  end
  clients[10..19].each_with_index do |client,i|
      daysecs = 24*60*60;
      counter = -50 * daysecs
      status = 'CANCELLED'
      2.times do |n|
        stD = Date.today.to_time_in_current_zone + counter
        eD = stD + 5 * daysecs
        duration = eD - stD
        resCode = rand(12**12).to_s
        while resCode.to_s.length != 12
          resCode = rand(12**12).to_s
        end
        res = vehicles[i].reservations.new(pick_up_date: stD, duration: duration, drop_off_date: eD, reservation_code: resCode, status: status)
        res.client = client
        res.save!
        counter += 30
        status = 'COMPLETED'
      end
  end
end