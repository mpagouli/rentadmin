require 'spec_helper'

describe "UserPages" do

  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  describe "Signup page" do
    before { visit signup_path }
    let(:submit) { "Create Account" }
    context "submit with valid information" do 
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    context "submit with valid information" do
      before do
        fill_in "Name", with: "Emily Pediaditi"
        fill_in "Email", with: "epediaditi@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User,:count).by(1)
      end
      context "should show flash message" do 
        before { click_button submit }
        it { should have_selector('div.alert.alert-success', text:'Account created successfully!') }
      end
      context "after saving the user" do
        before { click_button submit }
        it { should have_link('Sign out') }
      end
    end
    context "submit with invalid information" do
      before do
        fill_in "Name", with: " "
        fill_in "Email", with: "epediaditiexamplecom"
        fill_in "Password", with: "foo"
        fill_in "Confirmation", with: " "
        click_button submit
      end
      it "should contain error messages for name" do
        should have_selector('div.alert.alert-error', text:"error")
      end
      it "should contain error message for name" do
        should have_selector('li', text:"Name can't be blank")
      end
      it "should show error message for email" do
        should have_selector('li', text:"Email is invalid")
      end
      it "should show error message for password" do
        should have_selector('li', text:"Password is too short (minimum is 6 characters)")
      end
      it "should show error message for password validation" do
        should have_selector('li', text:"Password confirmation can't be blank")
      end
    end
  end

end