# == Schema Information
#
# Table name: groups
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  group_name  :string(255)
#

require 'spec_helper'

describe Group do

  before { @group = Group.new }
  subject { @group }

  it { should respond_to(:group_name) }
  it { should respond_to(:description) }
  it { should respond_to(:models) }
  it { should_not be_valid }

  describe "Name:" do
  	context "empty" do 
       it { should_not be_valid }
       describe "specific error message" do 
         before { @group.save }
         specify { @group.errors_on(:group_name).should == ["Group name is required"] }
       end
  	end
  	context "not empty" do 
  	  before { @group.group_name = "valid name" }
  	  it { should be_valid }
  	end
  	context "not unique" do 
  		before { @group_other = Group.new(group_name:"valid name")
  			     @group_other.save 
  			 	 @group.group_name = "valid name"
  			     @group.save }
  		it { should_not be_valid }
  	end
  end

  describe "Description:" do
  	before { @group.group_name = "valid name" if @group.group_name.nil? }
  	context "having less than 1000 characters" do 
  	  before { @group.description = "a"*999 }
      it { should be_valid }
	end
	context "having exactly 1000 characters" do 
  	  before { @group.description = "a"*1000 }
      it { should be_valid }
	end
	context "having more than 1000 characters" do 
  	  before { @group.description = "a"*1001 }
      it { should_not be_valid }
      describe "specific error message" do 
        before { @group.save }
        specify { @group.errors_on(:description).should == ["Description must not exceed 1000 characters"] }
      end
  	end
  end

  describe "Models:" do
  	before { @group.group_name = "valid name" if @group.group_name.nil?
  		     @make = Make.new(make_name:"make name")
  		     @model1 = Model.new
  		     @model1.group = @group
  		     @model1.make = @make
  		     @model2 = Model.new(model_name:"valid second model name")
  		     @model2.group = @group
  		     @model2.make = @make
  	         @group.models << @model1 
  	         @group.models << @model2 
  	       }
  	context "one valid and one invalid" do 
  		it { should_not be_valid }
  		specify { @group.models.length == 2}
  	end
  	context "one valid" do 
  		before { @group.models.delete(@model1) }
  		it { should be_valid }
  		specify { @group.models.length == 1}
  	end
  	context "two valid ones" do 
  		before { @model1.model_name="valid first model name" 
  				 @group.models << @model1 
  			   }
  		it { should be_valid }
  		specify { @group.models.length == 2}
  	end
  end
  
end
