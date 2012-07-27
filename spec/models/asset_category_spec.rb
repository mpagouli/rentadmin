require 'spec_helper'

describe AssetCategory do
  before { @cat = AssetCategory.new }
  subject { @cat }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:assets) }
  it { should_not be_valid }

  describe "Name:" do
  	context "empty" do 
       it { should_not be_valid }
       describe "specific error message" do 
         before { @cat.save }
         specify { @cat.errors_on(:name).should == ["Asset Category name is required"] }
       end
  	end
  	context "not empty" do 
  	  before { @cat.name = "valid name" }
  	  it { should be_valid }
  	end
  	context "not unique (ignore case)" do 
  		before { @cat_other = AssetCategory.new(name:"valid name")
  			     @cat_other.save 
  			 	 @cat.name = "valid name"
  			     @cat.save }
  		it { should_not be_valid }
  	end
  end

  describe "Description:" do
  	before { @cat.name = "valid name" if @cat.name.nil? }
  	context "having less than 400 characters" do 
  	  before { @cat.description = "a"*399 }
      it { should be_valid }
	end
	context "having exactly 400 characters" do 
  	  before { @cat.description = "a"*400 }
      it { should be_valid }
	end
	context "having more than 400 characters" do 
  	  before { @cat.description = "a"*401 }
      it { should_not be_valid }
      describe "specific error message" do 
        before { @cat.save }
        specify { @cat.errors_on(:description).should == ["Description must not exceed 400 characters"] }
      end
  	end
  end

  describe "Assets:" do
  	before { @cat.name = "valid name" if @cat.name.nil?
  		     @asset1 = Asset.new
  		     @asset1.asset_category = @cat
  		     @asset2 = Asset.new(filename:"valid second asset name")
  		     @asset2.asset_category = @cat
  	         @cat.assets << @asset1 
  	         @cat.assets << @asset2  
  	       }
  	context "one valid and one invalid" do 
  		it { should_not be_valid }
  		specify { @cat.assets.length == 2}
  	end
  	context "one valid" do 
  		before { @cat.assets.delete(@asset1) }
  		it { should be_valid }
  		specify { @cat.assets.length == 1}
  	end
  	context "two valid ones" do 
  		before { @asset1.filename="valid first model name" 
  				 @cat.assets << @asset1 
  			   }
  		it { should be_valid }
  		specify { @cat.assets.length == 2}
  	end
  end
end
