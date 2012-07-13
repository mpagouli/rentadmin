# == Schema Information
#
# Table name: models
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  make_id     :integer
#  model_id    :integer
#  group_id    :integer
#  model_name  :string(255)
#

require 'spec_helper'

describe Model do

  before { @make = Make.new(make_name:"Make Name")
           #@group = Group.new(group_name:"Group Name") 
           @model = Model.new 
           #@model.group = @group
           @model.make = @make
         }
  subject { @model }

  it { should respond_to(:model_name) }
  it { should respond_to(:description) }
  it { should respond_to(:make) }
  it { should respond_to(:group) }
  it { should respond_to(:vehicles) }
  it { should_not be_valid }

  describe "Make:" do
  	context "empty" do 
  	   before { @model.model_name = "valid name" 
  	   	        @model.make = nil }
       it { should_not be_valid }
       describe "specific error message" do 
         before { @model.save }
         specify { @model.errors_on(:make).should == ["Make is required"] }
       end
  	end
  end

  describe "Name:" do
  	context "empty" do 	
       it { should_not be_valid }
       describe "specific error message" do 
         before { @model.save }
         specify { @model.errors_on(:model_name).should == ["Model name is required"] }
       end
  	end
  	context "not empty" do 
  	  before { @model.model_name = "valid name" }
  	  it { should be_valid }
  	end
  	context "not unique (ignore case)" do 
  		before { @model_other = Model.new(model_name:"valid name")
  			     @model_other.make = @make
  			     #@model_other.group = @group
  			     @model_other.save 
  			 	 @model.model_name = "VALID NAME"
  			     @model.save }
  		it { should_not be_valid }
  	end
  end

  describe "Description:" do
  	before { @model.model_name = "valid name" if @model.model_name.nil? }
  	context "having less than 400 characters" do 
  	  before { @model.description = "a"*399 }
      it { should be_valid }
	end
	context "having exactly 400 characters" do 
  	  before { @model.description = "a"*400 }
      it { should be_valid }
	end
	context "having more than 400 characters" do 
  	  before { @model.description = "a"*401 }
      it { should_not be_valid }
      describe "specific error message" do 
        before { @model.save }
        specify { @model.errors_on(:description).should == ["Description must not exceed 400 characters"] }
      end
  	end
  end

  describe "Vehicles:" do
  	before { @model.model_name = "valid name" if @model.model_name.nil?
  		     @v1 = Vehicle.new
  		     @v1.model = @model
  		     @v2 = Vehicle.new(reg_no:"valid second reg no")
  		     @v2.model = @model
  	         @model.vehicles << @v1 
  	         @model.vehicles << @v2 
  	       }
  	context "one valid and one invalid" do 
  		it { should_not be_valid }
  	end
  	context "one valid" do 
  		before { @model.vehicles.delete(@v1) }
  		it { should be_valid }
  	end
  	context "two valid ones" do 
  		before { @v1.reg_no="valid first reg no" 
  				 @model.vehicles << @v1 
  			   }
  		it { should be_valid }
  		specify { @model.vehicles.length == 2}
  	end
  end


end
