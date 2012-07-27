require 'spec_helper'

describe "UserPages" do

  let(:user) { FactoryGirl.create(:user) }
  subject { page }

  describe "Index" do
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all)  { User.delete_all }
    before(:each) do
      sign_in user
      visit users_path
    end
    it { should have_selector('title', text: full_title('All users')) }
    it { should have_selector('h1', text: 'All users') }
    describe "pagination" do
      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
    describe "delete links" do
      it { should_not have_link('delete') }
      context "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_out user
          sign_in admin
          visit users_path
        end
        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "Signup page" do
    before { visit signup_path }
    let(:submit) { "Create Account" }
    context "submit with invalid information" do 
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


  describe "Edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    context "Page" do
      it { should have_selector('h1', text: 'Edit User') }
      it { should have_selector('title', text: full_title('Edit User')) }
    end
    context "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end
    context "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save changes"
      end
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end

  end

end