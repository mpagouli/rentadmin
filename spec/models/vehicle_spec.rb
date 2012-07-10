# == Schema Information
#
# Table name: vehicles
#
#  id         :integer         not null, primary key
#  reg_no     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  model_id   :integer
#

require 'spec_helper'

describe Vehicle do

  before { @model = Model.new(model_name:"model")
  	       @make = Make.new(make_name:"make")
  	       @vehicle = Vehicle.new 
  	       @model.make = @make
           @vehicle.model = @model
         }
  subject { @vehicle }

  it { should respond_to(:reservation_vehicles) }
  it { should respond_to(:reg_no) }
  it { should respond_to(:model) }
  it { should respond_to(:reservations) }
  it { should_not be_valid }

  describe "Model:" do
  	context "empty" do 
  	   before { @vehicle.reg_no = "registration no"
  	   	        @vehicle.model = nil }
       it { should_not be_valid }
       describe "specific error message" do 
         before { @vehicle.save }
         specify { @vehicle.errors_on(:model).should == ["Model is required"] }
       end
  	end
  end

  describe "Registration Number:" do
  	context "empty" do 
       it { should_not be_valid }
       describe "specific error message" do 
         before { @vehicle.save }
         specify { @vehicle.errors_on(:reg_no).should == ["Registration number is required"] }
       end
  	end
  	context "not empty" do 
  	  before { @vehicle.reg_no = "registration no" }
  	  it { should be_valid }
  	end
  	context "not unique" do 
  		before { @vehicle_other = Vehicle.new(reg_no:"registration no")
  			     @vehicle_other.model = @model
  			     @vehicle_other.save 
  			 	 @vehicle.reg_no = "registration no"
  			     @vehicle.save }
  		it { should_not be_valid }
  	end
  end

  describe "Reservations:" do
  	before { @vehicle.reg_no = "registration no" if @vehicle.reg_no.nil?
  		     @r = Reservation.new
  		     @r.vehicles << @vehicle
  		     @r.save
  	       }
  	context "when present" do 
  		it { should be_valid }
  		specify { @vehicle.reload.reservations.should == [@r] }	
  		specify { @r.reload.vehicles.should == [@vehicle] }	
  	end
  end

end
