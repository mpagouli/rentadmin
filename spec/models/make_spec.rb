# == Schema Information
#
# Table name: makes
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  make_name   :string(255)
#

require 'spec_helper'

describe Make do
  
  before { @make = Make.new }
  subject { @make }

  it { should respond_to(:make_name) }
  it { should respond_to(:description) }
  it { should respond_to(:models) }
  it { should_not be_valid }

  describe "Name:" do
  	context "empty" do 
       it { should_not be_valid }
       describe "specific error message" do 
         before { @make.save }
         specify { @make.errors_on(:make_name).should == ["Make name is required"] }
       end
  	end
  	context "not empty" do 
  	  before { @make.make_name = "valid name" }
  	  it { should be_valid }
  	end
  	context "not unique (ignore case)" do 
  		before { @make_other = Make.new(make_name:"valid name")
  			     @make_other.save 
  			 	 @make.make_name = "VaLiD NaME"
  			     @make.save }
  		it { should_not be_valid }
  	end
  end

  describe "Description:" do
  	before { @make.make_name = "valid name" if @make.make_name.nil? }
  	context "having less than 400 characters" do 
  	  before { @make.description = "a"*399 }
      it { should be_valid }
	end
	context "having exactly 400 characters" do 
  	  before { @make.description = "a"*400 }
      it { should be_valid }
	end
	context "having more than 400 characters" do 
  	  before { @make.description = "a"*401 }
      it { should_not be_valid }
      describe "specific error message" do 
        before { @make.save }
        specify { @make.errors_on(:description).should == ["Description must not exceed 400 characters"] }
      end
  	end
  end

  describe "Models:" do
  	before { @make.make_name = "valid name" if @make.make_name.nil?
  		     #@group = Group.new(group_name:"group name")
  		     @model1 = Model.new
  		     #@model1.group = @group
  		     @model1.make = @make
  		     @model2 = Model.new(model_name:"valid second model name")
  		     #@model2.group = @group
  		     @model2.make = @make
  	         @make.models << @model1 
  	         @make.models << @model2 
  	       }
  	context "one valid and one invalid" do 
  		it { should_not be_valid }
  		specify { @make.models.length == 2}
  	end
  	context "one valid" do 
  		before { @make.models.delete(@model1) }
  		it { should be_valid }
  		specify { @make.models.length == 1}
  	end
  	context "two valid ones" do 
  		before { @model1.model_name="valid first model name" 
  				 @make.models << @model1 
  			   }
  		it { should be_valid }
  		specify { @make.models.length == 2}
  	end
  end

end
