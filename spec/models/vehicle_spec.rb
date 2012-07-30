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

  it { should respond_to(:reg_no) }
  it { should respond_to(:model) }
  it { should respond_to(:reservations) }
  it { should_not be_valid }

  describe "Model:" do
  	context "empty" do 
  	   before { @vehicle.reg_no = "AXB 1234"
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
         specify { @vehicle.errors_on(:reg_no).should include("Plate number is required") }
       end
  	end
  	context "not empty" do 
  	  before { @vehicle.reg_no = "AXB 1234" }
  	  it { should be_valid }
  	end
  	context "not unique" do 
  		before { @vehicle_other = Vehicle.new(reg_no:"AXB 1234")
  			     @vehicle_other.model = @model
  			     @vehicle_other.save 
  			 	 @vehicle.reg_no = "AXB 1234"
  			     @vehicle.save }
  		it { should_not be_valid }
  	end
    context "wrongly formatted" do 
      it "(should be invalid)" do 
        plate_numbers = [ "axb 00 i1", "00000", "AXB 0.0.0.", ".^dasdasdasd", "AXB 1234 23 " ]
        plate_numbers.each do |invalid_num|
          @vehicle.reg_no = invalid_num
          @vehicle.should_not be_valid
        end
      end
    end
    context "correctly formatted" do 
      it "(should be valid)" do 
        plate_numbers = [ "AXB 1234", "AXB34567", "ISF 123 1234", "A 234 5" ]
        plate_numbers.each do |valid_num|
          @vehicle.reg_no = valid_num
          @vehicle.should be_valid
        end
      end
    end
  end

  describe "Reservations:" do
  	before { @vehicle.reg_no = "AXB 1234" if @vehicle.reg_no.nil?
           @make.save
           @model.save
           @vehicle.save
           @client = Client.create(name: "Amy", surname:"Whinehouse",email:"amy@example.com")
  		     @r = Reservation.new(reservation_code:'123456789', pick_up_date: Date.new(2012, 7, 9), drop_off_date:Date.new(2012,7,19), duration:11)
  		     @r.vehicle = @vehicle
           @r.client = @client
  		     @r.save
  	       }
  	context "when present" do 
  		it { should be_valid }
  		specify { @vehicle.reload.reservations.should == [@r] }	
  		specify { @r.reload.vehicle.should == @vehicle }	
  	end
  end

end
