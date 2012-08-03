require 'spec_helper'

describe "MenuPages" do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  subject { page }	
  
  #SHARED EXAMPLES FOR MENU PAGES
  shared_examples_for "all menu pages" do
    it 'having page specific title' do
      should have_selector('title', :text => full_title(page_title))
    end
  end

  #OPERATION PAGE
  describe "Operation Page" do
    before { visit operation_path } 
    let(:page_title) { 'Operation' }
    it_should_behave_like "all menu pages"
    describe "Navigation bar links" do
    	it { should have_link "Timeline", href: timeline_path }
    	it { should have_link "Reports", href: '#' }
    	it { should have_link "Reservations", href: '#' }
    	it { should have_link "Home", href: home_path }
    	it { should have_link "Sign out", href: signout_path }
    	it { should have_link "Help", href: '#' }
    end
    describe "Content" do

    end
  end 

  #BOARD PAGE
  describe "Board Page" do
  	before { visit board_path } 
    let(:page_title) { 'Board' }
    it_should_behave_like "all menu pages"
    describe "Navigation bar links" do
    	it { should have_link "Home", href: home_path }
    	it { should have_link "Sign out", href: signout_path }
    	it { should have_link "Help", href: '#' }
    end
    describe "Content" do

    end
  end

  #ADMIN PAGE
  describe "Admin Page" do
  	let(:admin) { FactoryGirl.create(:admin) }
  	before do 
  		sign_out user
  		sign_in admin
  		visit admin_path 
  	end 
    let(:page_title) { 'Admin' }
    it_should_behave_like "all menu pages"
    describe "Navigation bar links" do
    	it { should have_link "General", href: '#' }
    	#it { should have_link "Groups", href: '#' }
    	it { should have_link "Vehicles", href: '#' }
      #it { should have_link "Models", href: '#' }
    	it { should have_link "Customers", href: '#' }
      it { should have_link "Users", href: users_path }
    	it { should have_link "Rates", href: '#' }
    	it { should have_link "Help", href: '#' }
    	it { should have_link "Home", href: home_path }
    	it { should have_link "Sign out", href: signout_path }
    end
    describe "Vehicles Dropdown links:" do
      it { should have_link "New Vehicle", href: new_vehicle_path }
      it { should have_link "Vehicle List", href: vehicles_path }
      describe "Vehicles => New" do
        before { click_link "New Vehicle" }
        it { should have_selector('title', text: 'New Vehicle')}
        it { should have_link "New Vehicle", href: new_vehicle_path }
      end
      describe "Vehicles => List" do
        before { click_link "Vehicle List" }
        it { should have_selector('title', text: 'Vehicles')}
        it { should have_link("Vehicle List", href: vehicles_path)}
      end
    end
    describe "Content" do

    end
    

  end

end
