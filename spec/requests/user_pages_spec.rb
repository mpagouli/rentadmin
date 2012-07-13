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
    end
  end

end