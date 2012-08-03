# == Schema Information
#
# Table name: reservations
#
#  id               :integer         not null, primary key
#  pickUpDate        :datetime
#  dropOffDate      :datetime
#  duration         :decimal(, )
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  vehicle_id       :integer
#  client_id        :integer
#  reservation_code :string(255)
#

require 'spec_helper'

describe Reservation do

  before { @model = Model.new(model_name:"model")
  	       @make = Make.new(make_name:"make")
  	       @vehicle = Vehicle.new(reg_no:"AXB 1234") 
           @client = Client.new(name: "Amy", surname:"Whinehouse",email:"amy@example.com", identity_number: "ID 9876543")
  	       @model.make = @make
           @vehicle.model = @model
           @res = Reservation.new(reservation_code:'123456789', pick_up_date: Date.new(2012, 7, 9), drop_off_date:Date.new(2012,7,19), duration:11)
           @vehicle.save 
           @client.save
           @res.vehicle = @vehicle 
           @res.client = @client
         }

  subject { @res }

  it { should respond_to(:reservation_code) }
  it { should respond_to(:status) }
  it { should respond_to(:pick_up_date) }
  it { should respond_to(:drop_off_date) }
  it { should respond_to(:duration) }
  it { should respond_to(:vehicle) }
  it { should respond_to(:client) }

  describe "Reservation code:" do
    context "blank" do
      before { @res.reservation_code = " " }
      it { should_not be_valid }
      describe "specific error message" do 
         before { @res.save }
         specify { @res.errors_on(:reservation_code).should == ["Reservation code is required"] }
      end
    end
    context "nil" do
      before { @res.reservation_code = nil }
      it { should_not be_valid }
      describe "specific error message" do 
         before { @res.save }
         specify { @res.errors_on(:reservation_code).should == ["Reservation code is required"] }
      end
    end
  end

  describe "Pick Up Date:" do
    context "nil" do
      before { @res.pick_up_date = nil }
      it { should_not be_valid }
      describe "specific error message" do 
         before { @res.save }
         specify { @res.errors_on(:pick_up_date).should == ["Pick-up date is required"] }
      end
    end
  end

  describe "Drop Off Date:" do
    context "nil" do
      before { @res.drop_off_date = nil }
      it { should_not be_valid }
      describe "specific error message" do 
         before { @res.save }
         specify { @res.errors_on(:drop_off_date).should == ["Drop-off date is required"] }
      end
    end
  end

  describe "Vehicle:" do
  	context "empty" do
      before do 
        @res.vehicle = nil 
        @res.save
      end
  		it { should_not be_valid }
  		describe "specific error message" do 
         before { @res.save }
         specify { @res.errors_on(:vehicle).should == ["Vehicle is required"] }
      end
  	end
  	context "not empty" do
  	   before { @res.save }
       it { should be_valid }
       specify { @res.reload.vehicle.should == @vehicle }
       describe "should contain the reservation" do 
         specify { @vehicle.reload.reservations.should == [@res] }
       end
  	end
  end

  describe "Client:" do
    context "empty" do 
      before do 
        @res.client = nil 
        @res.save
      end
      it { should_not be_valid }
      describe "specific error message" do 
         before { @res.save }
         specify { @res.errors_on(:client).should == ["Customer is required"] }
        end
    end
    context "not empty" do
       before { @res.save }
       it { should be_valid }
       specify { @res.reload.client.should == @client }
       describe "should contain the reservation" do 
         specify { @client.reload.reservations.should == [@res] }
       end
    end
  end

end
