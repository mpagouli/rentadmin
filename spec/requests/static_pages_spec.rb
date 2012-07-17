require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it 'having page specific title' do
      should have_selector('title', :text => page_title)
    end
  end

  describe "Home Page" do
    let(:user) { FactoryGirl.create(:user) }
  	before do 
      sign_in user
      visit home_path
    end 
  	let(:page_title) { 'Open Fleet' }
  	it_should_behave_like "all static pages"
    it { should have_selector('div', id: 'wheelmenu') }
    it { should have_link('Sign out', href: signout_path) }
    it { should have_link('Board', href: '#') }
    it { should have_link('Operation', href: '#') }
    context ": visit as simple user" do
      it { should_not have_link('Admin', href: '#') }
    end
    context ": visit as administrator" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_out user
        sign_in admin
      end
      it { should have_link('Admin', href: '#') }
    end 
    describe "Menu links" do
      #it "should be able to sign out user" do
      #    expect { click_link('delete') }.to change(User, :count).by(-1)
      #  end
    end 
    describe "steering wheel menu" do
    end
  end

  describe "Help Page" do
  	before { visit help_path } 
  	let(:page_title) { 'Help' }
  	it_should_behave_like "all static pages"
    it "having page specific h1" do  
      should have_selector('h1', :text => page_title) 
    end
    it { should have_link("Open Fleet", href: home_path) }
    context "when clicking on Home" do
      before { click_link "Open Fleet" }
      it { should have_button"Sign in" }
    end
  end

end
