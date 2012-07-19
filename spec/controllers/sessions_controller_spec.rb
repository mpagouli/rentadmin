require 'spec_helper'

describe SessionsController do
  #render_views # Render this controller's views during spec execution.

  let(:user) { FactoryGirl.create(:user) }
  
  describe "POST create" do
    before do 
      post :create, :session => { :email => user.email, :password => user.password } 
      #assign(:current_user, user)
    end
    it "should assign @current_user" do
      assigns(:current_user).should eq(user)
    end
  end
  
end