# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

require 'spec_helper'

describe User do

    # Runs before each it example. When using before block in one example 
    # we add commands to its before block that contains the command below
	before { @user = User.new(name: "Example User", email:"user@example.com", password: "foobar", password_confirmation: "foobar") }
	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }					#virtual, not persisted
	it { should respond_to(:remember_token) }
	it { should respond_to(:password_confirmation) }	#virtual, not persisted
	it { should respond_to(:authenticate) }
	it { should respond_to(:admin) }

	it { should be_valid }

	describe "Name:" do
		context "blank" do
			before { @user.name = " " }
			it { should_not be_valid }
		end
		context "nil" do
			before { @user.name = nil }
			it { should_not be_valid }
		end
		context "too long" do
			before { @user.name = "a"*51 }
			it { should_not be_valid }
		end
	end

	describe "Email:" do
		context "blank" do
			before { @user.email = " " }
			it { should_not be_valid }
		end
		context "nil" do
			before { @user.email = nil }
			it { should_not be_valid }
		end
		context "wrongly formatted" do 
			it "(should be invalid)" do 
				addresses = %w[ user@foo,com user_at_foo.org example.user@foo. 
								foo@bar_baz.com foo@bar+baz.com ]
				addresses.each do |invalid_address|
					@user.email = invalid_address
					@user.should_not be_valid
				end
			end
		end
		context "correctly formatted" do 
			it "(should be valid)" do 
				addresses = %w[ user@foo.COM A_US-ER@f.b.org fst.lst@foo.jp a+b@baz.cn ]
				addresses.each do |valid_address|
					@user.email = valid_address
					@user.should be_valid
				end
			end
		end
		context "used by other user" do
			before do
				user_with_same_mail = @user.dup
				user_with_same_mail.email = @user.email.upcase
				user_with_same_mail.save
			end
			it { should_not be_valid }
		end
	end

	describe "Password:" do
		context "blank" do
			before { @user.password = @user.password_confirmation = " " }
			it { should_not be_valid }
		end
		context "nil" do
			before { @user.password = @user.password_confirmation = nil }
			it { should_not be_valid }
		end
		context "too short" do
			before { @user.password = "a"*5 }
			it { should_not be_valid }
		end
		context "mismatch with confirmation" do 
			before { @user.password_confirmation = "nofoobar"}
			it { should_not be_valid }
		end
		context "confirmation is nil" do 
			before { @user.password_confirmation = nil}
			it { should_not be_valid }
		end
	end

	describe "Authenticate:" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }
		context "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end
		context "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalidpassword") }
			#let memoizes its value, so that the first nested describe block invokes let 
			#to retrieve the user from the database using find_by_email, 
			#but this block doesn’t hit the database a second time.
			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "Remember Token:" do
		before { @user.save }
    	its(:remember_token) { should_not be_blank }
	end
  
end
