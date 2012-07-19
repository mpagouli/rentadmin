require 'spec_helper'

describe MenuPagesController do
  
  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }

  describe "GET admin" do
    before do 
      sign_in admin
      get :admin 
    end
    it "should assign @menu_selected" do
      assigns(:menu_selected).should eq('admin')
    end
  end

  describe "GET operation" do
    before do 
      sign_in user
      get :operation 
    end
    it "should assign @menu_selected" do
      assigns(:menu_selected).should eq('operation')
    end
  end

  describe "GET board" do
    before do 
      sign_in user
      get :board 
    end
    it "should assign @menu_selected" do
      assigns(:menu_selected).should eq('board')
    end
  end

  
end