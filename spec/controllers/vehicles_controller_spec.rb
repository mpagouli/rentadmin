require 'spec_helper'

describe VehiclesController do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }

  describe "GET index" do
    before do 
      sign_in admin
      get :index 
    end
    it "should have assigned @menu_selected" do
      assigns(:menu_selected).should eq('admin')
    end
    it "should assign @item_selected" do
      assigns(:item_selected).should eq('list')
    end
  end

end