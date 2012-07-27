# == Schema Information
#
# Table name: reservations
#
#  id         :integer         not null, primary key
#  startDate  :datetime
#  endDate    :datetime
#  duration   :decimal(, )
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Reservation do

  before { @model = Model.new(model_name:"model")
  	       @make = Make.new(make_name:"make")
  	       @vehicle = Vehicle.new(reg_no:"AXB 1234") 
  	       @model.make = @make
           @vehicle.model = @model
           @res = Reservation.new(startDate: Date.new(2012, 7, 9), endDate:Date.new(2012,7,19), duration:11)
         }

  subject { @res }

  it { should respond_to(:reservation_vehicles) }
  it { should respond_to(:startDate) }
  it { should respond_to(:endDate) }
  it { should respond_to(:duration) }
  it { should respond_to(:vehicles) }
  it { should respond_to(:vehicLess?) }

  describe "Vehicles:" do
  	context "empty" do 
  		it { should be_vehicLess }
  		describe "specific error message" do 
         before { @res.save }
         specify { @res.errors_on(:vehicles).should == ["At least one vehicle is required"] }
        end
  	end
  	context "not empty" do
  	   before { @vehicle.save 
  	   	        @res.vehicles << @vehicle 
  	   	        @res.save
  	   	      }
       it { should be_valid }
       specify { @res.reload.vehicles.should == [@vehicle] }
       describe "should contain the reservation" do 
         specify { @vehicle.reload.reservations.should == [@res] }
       end
  	end
  end

end
