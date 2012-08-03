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
    describe "page" do 
      it { should have_link('Vehicle List') }
      it { should have_selector('title', text: full_title('Vehicles')) }
      it { should have_link('Help', href: '#' ) }
      it { should have_link('Sign out', href: signout_path ) }
    end
    describe "List" do
      before do  
        31.times { FactoryGirl.create(:vehicle, model: model) }
        visit admin_path
        visit vehicles_path
      end
      after  do 
        Vehicle.delete_all
      end
      context "'New Vehicle' button" do 
        it { should have_selector('form', :action => '/vehicles/new') }
        it { should have_selector('input', :type => 'submit', :value => 'New Vehicle') }
      end
      it { should have_link('Vehicle List') }
      context "pagination" do
        it { should have_selector('div.pagination') }
        it ": should list each vehicle" do
          Vehicle.paginate(page: 1).each do |vehicle|
            page.should have_selector('div', text: "#{vehicle.reg_no}")
          end
        end
      end
      describe "delete links" do
        it { should have_link('delete', href: vehicle_path(Vehicle.first)) }
        it "should work" do 
          expect { click_link('delete') }.to change(Vehicle, :count).by(-1)
        end
      end
      describe "other links" do
        it { should have_link('show') }
        it { should have_link('edit') }
      end
    end
  end

  #SHARED EXAMPLES FOR NEW PAGE
  shared_examples_for "new vehicle page" do
    let(:submit) { "Insert Vehicle" }
    context "submit with invalid information" do
      it "by not inserting the vehicle" do
        expect { click_button submit }.not_to change(Vehicle, :count)
      end
      describe "by containing error messages" do
        before { click_button submit }
        it "should contain error messages" do
          should have_selector('div.alert.alert-error', text:"error")
        end
        it "should contain error message for license plate number" do
          should have_selector('li', text:"Plate number is required")
        end
        it "should contain error message for model" do
          should have_selector('li', text:"Model is required")
        end
      end
    end
    #debugger
    it { should have_selector('a.add_make') }
    it { should have_selector('a.add_model') }
    it { should have_selector('div#make_new_dialog') }
    it { should have_selector('div#model_new_dialog') }
    it { should have_selector('select#make_id') }
    it { should have_selector('select#model_id') }
    context "submit with valid information", :js => true do
      before do  
        fill_in "License plate number", with: "AXB 12345"
        select model.make.make_name, :from => 'make[id]'
        page.execute_script("$('#make_id').trigger('change');")
        wait_until { page.has_content? "models of make:"}
        select model.model_name, :from => 'model[id]'
      end
      it "should create a vehicle" do
        expect { click_button submit; sleep 2 }.to change(Vehicle,:count).by(1)
      end
      context "should show flash message" do 
        before { click_button submit }
        it { should have_selector('div.alert.alert-success', text:'Vehicle inserted successfully!') }
      end
      context "after saving the vehicle" do
        before { click_button submit }
        it { should have_xpath("//title[contains(text(), '#{full_title('AXB 12345')}')]")  }
      end
    end
    context "filter models by make", :js => true do
      before do
        select another_model1.make.make_name, :from => 'make[id]'
        page.execute_script("$('#make_id').trigger('change');")
        wait_until { page.has_content? "models of make:"}
      end
      it ":all make's models should be in the list" do
        should have_xpath("//select[@id='model_id']/option[contains(text(), 'different')]")
        should have_xpath("//select[@id='model_id']/option[contains(text(), 'different2')]")
      end
      it ":no other make's models should be in the list" do
        should_not have_xpath("//select[@id='model_id']/option[contains(text(), 'test')]")
      end
    end
  end

  #VEHICLES NEW PAGE
  describe "New" do
    let(:another_make) { FactoryGirl.create(:make, :make_name => "different") }
    let(:another_model1) { FactoryGirl.create(:model, :model_name => "different", :make => another_make) }
    let(:another_model2) { FactoryGirl.create(:model, :model_name => "different2", :make => another_make) }
    before do
        group.save
        make.save
        model.save
        another_make.save
        another_model1.save
        another_model2.save
        sign_in admin
        visit admin_path
    end
    after do
      Make.delete_all
      Group.delete_all
      Model.delete_all
    end
    context "from Vehicles dropdown" do
      before { visit new_vehicle_path }
      it_should_behave_like "new vehicle page"
    end
    context "from Vehicles index page" do
      before do 
        visit vehicles_path
      end
      describe "js", :js => true do
        before { click_button "New Vehicle"}
        it_should_behave_like "new vehicle page"
      end
    end
  end

  #VEHICLES EDIT PAGE
  describe "Edit" do
    let(:vehicle) { FactoryGirl.create(:vehicle, model: model) }
    let(:another_make) { FactoryGirl.create(:make, :make_name => "different") }
    let(:another_model) { FactoryGirl.create(:model, :model_name => "different", :make => another_make) }
    before do
        group.save
        make.save
        model.save
        vehicle.save
        another_make.save
        another_model.save
        sign_in admin
        visit admin_path
    end
    after do
      Make.delete_all
      Group.delete_all
      Model.delete_all
      Vehicle.delete_all
    end
    context "from Vehicles index page" do
      let(:submit) { "Save Changes" }
      before do 
        visit vehicles_path
        click_link 'edit'
      end
      context "Page" do
        it { should have_selector('h2', text: vehicle.reg_no) }
        it { should have_selector('title', text: full_title('Edit Vehicle')) }
        it { should have_selector('select#make_id') }
        it { should have_selector('select#model_id') }
      end
      context "filtered models by make" do
        it ":all make's models should be in the list" do
          should have_xpath("//select[@id='model_id']/option[contains(text(), 'test')]")
        end
        it ":no other make's models should be in the list" do
          should_not have_xpath("//select[@id='model_id']/option[contains(text(), 'different')]")
          should_not have_xpath("//select[@id='model_id']/option[contains(text(), 'different2')]")
          
        end
      end
      context "submit with invalid information" do
        before do 
          select '', :from => 'model[id]'
          click_button submit 
        end
        it "should contain error messages" do
          should have_selector('div.alert.alert-error', text:"error")
        end
        it "should contain error message for license plate number" do
          should have_selector('li', text:"Model is required")
        end
      end
      context "submit with valid information", :js => true do
        before do  
          select another_model.make.make_name, :from => 'make[id]'
          page.execute_script("$('#make_id').trigger('change');")
          wait_until { page.has_content? "models of make:"}
          select another_model.model_name, :from => 'model[id]'
          click_button submit
        end
        it { should have_selector('div.alert.alert-success') }
        it { should have_xpath("//title[contains(text(), '#{full_title(vehicle.reg_no)}')]")  }
        specify { vehicle.reload.model == another_model }
      end
    end
  end

  #VEHICLES SHOW PAGE
  describe "Show" do
    let(:vehicle) { FactoryGirl.create(:vehicle, model: model) }
    before do
        group.save
        make.save
        model.save
        vehicle.save
        sign_in admin
        visit admin_path
    end
    after do
      Make.delete_all
      Group.delete_all
      Model.delete_all
      Vehicle.delete_all
    end
    context "from Vehicles index page" do
      before do 
        visit vehicles_path
        click_link 'show'
      end
      context "Page" do
        it { should have_selector('h2', text: vehicle.reg_no) }
        it { should have_selector('title', text: full_title(vehicle.reg_no)) }
        it { should have_content(vehicle.model.model_name) }
        it { should have_content(vehicle.model.make.make_name) }
        it { should have_link("delete") }
        it { should have_link("edit") }
      end
    end
  end

  #SHARED EXAMPLES FOR AUTHORIZATION
  shared_examples_for "forbidden access pages" do
      describe "Index" do
        before { visit vehicles_path }
        it { should have_selector('title', text: full_title(page_title)) }
      end
      describe "New" do
        before { get new_vehicle_path(vehicle) }
        specify { response.should redirect_to(redirect_dest) }
      end
      describe "Show" do
        before { get vehicle_path(vehicle) }
        specify { response.should redirect_to(redirect_dest) }
      end
      describe "Edit" do
       before { get edit_vehicle_path(vehicle) }
       specify { response.should redirect_to(redirect_dest) }
      end
      describe "Update" do
       before { put vehicle_path(vehicle) }
       specify { response.should redirect_to(redirect_dest) }
      end
      describe "Create" do
       before { post vehicles_path }
       specify { response.should redirect_to(redirect_dest) }
      end
      describe "Destroy" do 
        before { delete vehicle_path(vehicle) }
        specify { response.should redirect_to(redirect_dest) }
      end
  end

  #VEHICLE PAGES AUTHORIZATION
  describe "Authorization" do
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
