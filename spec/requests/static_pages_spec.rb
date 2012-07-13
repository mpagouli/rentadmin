require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
  	it "having page specific h1" do  
  		should have_selector('h1', :text => page_title) 
  	end
    it 'having page specific title' do
    	should have_selector('title', :text => page_title)
	end
  end

  describe "Home Page" do
  	before { visit root_path } 
  	let(:page_title) { 'Open Fleet' }
  	it_should_behave_like "all static pages"
  end

  describe "Help Page" do
  	before { visit help_path } 
  	let(:page_title) { 'Help' }
  	it_should_behave_like "all static pages"
  end


end
