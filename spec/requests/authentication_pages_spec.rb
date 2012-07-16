require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }

  describe "Sign In Page" do
  	before { visit signin_path }
  	it { should have_selector('title', text:'Sign in') }
  	it { should have_selector('h2', text: 'Sign in') }
    it { should have_link('Help', href: help_path) }
  	context "with invalid information" do 
  		before { click_button "Sign in" }
  		it { should have_selector('title', text:'Sign in') }
  		it { should have_selector('div.alert.alert-error', text:'Invalid') }
  		context "after visiting another page" do
  			before { click_link "Help" }
  			it { should_not have_selector('div.alert.alert-error') }
  		end
  	end
  	context "with valid information" do 
  		let(:user) { FactoryGirl.create(:user) }
  		before do 
  			fill_in "Email", with: user.email
  			fill_in "Password", with: user.password
  			click_button "Sign in" 
  		end
  		it { should have_selector('title', text: user.name) }
  		it { should have_link('Profile', href: user_path(user)) }
  		it { should have_link('Sign out', href: signout_path) }
  		it { should_not have_link('Sign in', href: signin_path) }
  		context "followed by signout" do
        	before { click_link "Sign out" }
        	it { should have_button('Sign in') }
      	end
  	end
  end
end
