require 'spec_helper'

describe "VehiclePages" do

  let(:make) { FactoryGirl.create(:make) }
  let(:group) { FactoryGirl.create(:group) }
  let(:model) { FactoryGirl.create(:model, make: make, group: group) }
  let(:admin) { FactoryGirl.create(:admin) }

  subject { page }

  #VEHICLES INDEX PAGE
  describe "Index" do
    before do
      sign_in admin
      visit admin_path
      visit vehicles_path
    end
    describe "title and links" do 
      it { should have_link('Vehicle List') }
      it { should have_selector('title', text: full_title('Vehicles')) }
      it { should have_link('Help', href: '#' ) }
      it { should have_link('Sign out', href: signout_path ) }
    end
    describe "Pagination" do
      before do  
        31.times { FactoryGirl.create(:vehicle, model: model) }
        visit admin_path
        visit vehicles_path
      end
      after  do 
        Vehicle.delete_all 
        Model.delete_all
        Group.delete_all
        Make.delete_all
        admin.destroy
      end
      it { should have_selector('div.pagination') }
      it { should have_link('Vehicle List') }
      it "should list each vehicle" do
        Vehicle.paginate(page: 1).each do |vehicle|
          page.should have_selector('li', text: "#{vehicle.model.make.make_name}_#{vehicle.model.model_name}")
        end
      end
      it { should have_link('delete', href: vehicle_path(Vehicle.first)) }
      it { should have_link('show') }
      it { should have_link('edit') }
    end
  end

  #SHARED EXAMPLES FOR AUTHORIZATION
  shared_examples_for "forbidden access pages" do
    context "Index" do
        describe "visiting the index page" do
          before { visit vehicles_path }
          it { should have_selector('title', text: full_title(page_title)) }
        end
      end
      context "New" do
        describe "submitting to the new action" do
          before { get new_vehicle_path(vehicle) }
          specify { response.should redirect_to(redirect_dest) }
        end
      end
      #context "Show" do
      #  describe "submitting to the show action" do
      #    before { get vehicle_path(vehicle) }
      #    specify { response.should redirect_to(redirect_dest) }
      #  end
      #end
      #context "Edit" do
      #  describe "submitting to the edit action" do
      #    before { get edit_vehicle_path(vehicle) }
      #    specify { response.should redirect_to(redirect_dest) }
      #  end
      #end
      #context "Update" do
      #  describe "submitting to the update action" do
      #    before { put vehicle_path(vehicle) }
      #    specify { response.should redirect_to(redirect_dest) }
      #  end
      #end
      #context "Create" do
      #  describe "submitting to the create action" do
      #    before { post vehicles_path }
      #    specify { response.should redirect_to(redirect_dest) }
      #  end
      #end
  #    context "Destroy" do
  #      describe "submitting to the destroy action" do
  #        before { delete vehicle_path(vehicle) }
  #        specify { response.should redirect_to(redirect_dest) }
  #      end
  #    end
  end

  #VEHICLE PAGES AUTHORIZATION
  describe "Authorization" do
    #let(:make) { FactoryGirl.create(:make) }
    #let(:group) { FactoryGirl.create(:group) }
    #let(:model) { FactoryGirl.create(:model, make: make, group: group) }
    let(:vehicle) { FactoryGirl.create(:vehicle, model: model) }
    context "for non-signed-in users" do
      let(:redirect_dest) { signin_path }
      let(:page_title) { 'Sign in' }
      it_should_behave_like "forbidden access pages"
    end
    context "for non-admin users" do
      let(:non_admin) { FactoryGirl.create(:user) }
      let(:redirect_dest) { root_path }
      let(:page_title) { '' }
      before do 
        sign_in non_admin
      end
      it_should_behave_like "forbidden access pages"
    end
  end

  

end
