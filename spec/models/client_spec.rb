# == Schema Information
#
# Table name: clients
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Client do

	# Runs before each it example. When using before block in one example 
    # we add commands to its before block that contains the command below
	before { @client = Client.new(name: "Amy", surname:"Whinehouse",email:"amy@example.com", identity_number: "ID 7230089") }
	subject { @client }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:identity_number) }
	it { should respond_to(:surname) }
	it { should respond_to(:reservations) }

	it { should be_valid }

	describe "Name:" do
		context "blank" do
			before { @client.name = " " }
			it { should_not be_valid }
		end
		context "nil" do
			before { @client.name = nil }
			it { should_not be_valid }
		end
	end

	describe "Surname:" do
		context "blank" do
			before { @client.surname = " " }
			it { should_not be_valid }
		end
		context "nil" do
			before { @client.surname = nil }
			it { should_not be_valid }
		end
	end

	describe "Identity Number:" do
		context "blank" do
			before { @client.identity_number = " " }
			it { should_not be_valid }
		end
		context "nil" do
			before { @client.identity_number = nil }
			it { should_not be_valid }
		end
	end


	describe "Email:" do
		context "blank" do
			before { @client.email = " " }
			it { should_not be_valid }
		end
		context "nil" do
			before { @client.email = nil }
			it { should_not be_valid }
		end
		context "wrongly formatted" do 
			it "(should be invalid)" do 
				addresses = %w[ user@foo,com user_at_foo.org example.user@foo. 
								foo@bar_baz.com foo@bar+baz.com ]
				addresses.each do |invalid_address|
					@client.email = invalid_address
					@client.should_not be_valid
				end
			end
		end
		context "correctly formatted" do 
			it "(should be valid)" do 
				addresses = %w[ user@foo.COM A_US-ER@f.b.org fst.lst@foo.jp a+b@baz.cn ]
				addresses.each do |valid_address|
					@client.email = valid_address
					@client.should be_valid
				end
			end
		end
		context "used by other client" do
			before do
				client_with_same_mail = @client.dup
				client_with_same_mail.email = @client.email.upcase
				client_with_same_mail.save
			end
			it { should_not be_valid }
		end
	end

	describe "Reservations:" do
	  before { @model = Model.create(model_name:"model")
  	       	   @make = Make.create(make_name:"make")
  	       	   @vehicle = Vehicle.create(reg_no:"AXB 34567")
	  		   @client.save
	  	       @r = Reservation.new(reservation_code:'123456789', pick_up_date: Date.new(2012, 7, 9), drop_off_date:Date.new(2012,7,19), duration:11)
	  		   @r.client = @client
	  		   @r.vehicle = @vehicle
	  		   @r.save
	  	     }
	  context "when present" do 
	  	it { should be_valid }
	  	specify { @client.reload.reservations.should == [@r] }	
	  	specify { @r.reload.client.should == @client }	
	  end
	end
 
end
