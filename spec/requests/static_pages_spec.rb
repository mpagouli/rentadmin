require 'spec_helper'

describe "StaticPages" do

  subject { page }

  #SHARED EXAMPLES FOR STATIC PAGES
  shared_examples_for "all static pages" do
    it 'having page specific title' do
      should have_selector('title', :text => full_title(page_title))
    end
  end

  #HOME PAGE
  describe "Home Page" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      sign_in user
      visit home_path
    end 
    let(:page_title) { '' }
    it_should_behave_like "all static pages"
    it { should_not have_selector('title', :text => 'Open Fleet | Open Fleet') }
    it { should have_link('Sign out', href: signout_path) }
    it { should have_link('Help', href: help_path) }
    it { should have_link('Home', href: home_path) }
    it { should have_link('Board', href: board_path) }
    it { should have_link('Operation', href: operation_path) }
    it { should have_selector('div#wheelmenu') }
    context ": visit as simple user" do
      it { should_not have_link('Administration', href: admin_path) }
    end
    context ": visit as administrator" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_out user
        sign_in admin
      end
      it { should have_link('Administration', href: admin_path) }
      context "clicking on Administration Link" do
        before { click_link "Administration" }
        it { should have_selector('title', text: full_title('Admin')) }
      end
      context "selecting Admin Menu Item" do
        #####################################################################################
      end
    end 
    describe "Navigation Bar Links" do
      describe "Help" do
        before { click_link "Help" }
        it { should have_selector('title', text: full_title('Help')) }
      end
    end
    describe "Menu links:" do
      describe "Sign out" do
        before { click_link "Sign out" }
        it { should have_button('Sign in') }
      end
      describe "Home" do
        before { click_link "Home" }
        it { should have_selector('div#wheelmenu') }
      end
      describe "Operation" do
        before { click_link "Operation" }
        it { should have_selector('title', text: full_title('Operation')) }
      end
      describe "Board" do
        before { click_link "Board" }
        it { should have_selector('title', text: full_title('Board')) }
      end
    end 
    describe "steering wheel menu" do
      ######################################################################################
    end
  end

  #HELP PAGE
  describe "Help Page" do
  	before { visit help_path } 
  	let(:page_title) { 'Help' }
  	it_should_behave_like "all static pages"
    it "having page specific h1" do  
      should have_selector('h1', :text => page_title) 
    end
    it { should_not have_link("Help", href: help_path) }
    it { should have_link("Back") }
    it { should have_link("Open Fleet", href: home_path) }
    describe "when clicking on Home" do
      context "as a signed in user" do
        let(:user) { FactoryGirl.create(:user) }
        before do
          sign_in user
          visit help_path
          click_link "Open Fleet"
        end
        it { should have_selector('title', text: full_title('')) }
      end
    end
    describe "when clicking on Back link" do
      context "coming from sign in page" do
        before do
          visit signin_path
          click_link "Help"
        end
        it { should have_link "Back" }
        describe "should redirect to sign in page" do
          before { click_link "Back" }
          it { should have_button "Sign in" }
        end
      end
      context "coming from home page" do
        let(:user) { FactoryGirl.create(:user) }
        before do
          sign_in user
          visit home_path
          click_link "Help"
        end
        it { should have_link "Back" }
        describe "should redirect to home page" do
          before { click_link "Back" }
          it { should have_selector('div#wheelmenu') }
        end
      end
    end
  end

end
