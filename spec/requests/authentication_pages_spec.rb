require 'spec_helper'

describe "AuthenticationPages" do
  
  subject { page }

  #AUTHENTICATION
  describe "Sign In Page" do
  	before { visit signin_path }
  	it { should have_selector('title', text: full_title('Sign in')) }
  	it { should have_selector('h2', text: 'Sign in') }
    it { should have_link('Help', href: help_path) }
    it { should_not have_link('Administration', href: admin_path) }
    it { should_not have_link('Board', href: board_path) }
    it { should_not have_link('Operation', href: operation_path) }
    it { should_not have_link('Sign out', href: signout_path) }
  	context "with invalid information" do 
  		before { click_button "Sign in" }
  		it { should have_selector('title', text: full_title('Sign in')) }
  		it { should have_selector('div.alert.alert-error', text:'Invalid') }
  		context "after visiting another page" do
  			before { click_link "Help" }
  			it { should_not have_selector('div.alert.alert-error') }
  		end
  	end
  	context "with valid information" do 
  		let(:user) { FactoryGirl.create(:user) }
  		before { sign_in user }
  		#it { should have_selector('title', text: user.name) }
      #it { should have_link('Users', href: users_path) }
  		#it { should have_link('Profile', href: user_path(user)) }
      #it { should have_link('Settings', href: edit_user_path(user)) }
  		#it { should have_link('Sign out', href: signout_path) }
  		it { should_not have_button('Sign in') }
      it { should have_selector('title', text: full_title('')) }
      it { should have_selector('div#wheelmenu') }
      it { should have_link('Sign out', href: signout_path) }
  		context "followed by signout" do
        before { click_link "Sign out" }
        it { should have_button('Sign in') }
      end
  	end
  end

  #AUTHORIZATION
  describe "Authorization" do
    context "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      context "in the Static Pages controller" do
        describe "visiting home page" do
          before { visit home_path }
          it { should have_selector('title', text: full_title('Sign in')) }
        end
        describe "visiting help page and clicking home" do
          before do 
            visit help_path 
            click_link "Open Fleet"
          end
          it { should have_selector('title', text: full_title('Sign in')) }
        end
      end
      context "in the Menu Pages controller" do
        describe "visiting operation page" do
          before { visit operation_path }
          it { should have_selector('title', text: full_title('Sign in')) }
        end
        describe "visiting board page" do
          before { visit board_path }
          it { should have_selector('title', text: full_title('Sign in')) }
        end
        describe "visiting admin page" do
          before { visit admin_path }
          it { should have_selector('title', text: full_title('Sign in')) }
        end
      end
      context "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: full_title('Sign in')) }
        end
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: full_title('Sign in')) }
        end
      end
      context "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: full_title('Edit User'))
          end
        end
      end
    end
    context "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit User')) }
      end
      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
    context "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin }
      context "in the Users controller" do
        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(root_path) }        
        end
      end
      context "in the Menu Pages controller" do
        describe "visiting admin page" do
          before { get admin_path }
          specify { response.should redirect_to(root_path) }        
        end
      end
      context "in the Static Pages controller" do
        describe "visiting home page" do
          before { visit home_path }
          it { should_not have_link('Admin') }
        end
      end
    end
  end
end
