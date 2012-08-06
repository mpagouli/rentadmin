require 'spec_helper'

describe "Reservations" do
  
  let(:make) { FactoryGirl.create(:make) }
  let(:group) { FactoryGirl.create(:group) }
  let(:model) { FactoryGirl.create(:model, make: make, group: group) }
  let(:vehicle) { FactoryGirl.create(:vehicle, model: model) }
  let(:customer) { FactoryGirl.create(:client) }
  let(:user) { FactoryGirl.create(:user) }

  subject { page }

  #RESERVATIONS INDEX PAGE
  describe "Index" do
    before do
      sign_in user
      visit operation_path
      visit reservations_path
    end
    describe "page" do 
      it { should have_link('Reservation List') }
      it { should have_selector('title', text: full_title('Reservations')) }
      it { should have_link('Help', href: '#' ) }
      it { should have_link('Sign out', href: signout_path ) }
    end
    describe "List" do
      before do  
        31.times { |n| FactoryGirl.create(:reservation, vehicle: vehicle, client: customer) }
        visit operation_path
        visit reservations_path
      end
      after  do 
        Reservation.delete_all
      end
      context "'New Reservation' button" do 
        it { should have_selector('form', :action => '/reservations/new') }
        it { should have_selector('input', :type => 'submit', :value => 'New Reservation') }
      end
      it { should have_link('Reservation List') }
      context "pagination" do
        it { should have_selector('div.pagination') }
        it ": should list each reservation" do
          Reservation.paginate(page: 1).each do |res|
            page.should have_selector('div', text: "#{res.reservation_code}")
          end
        end
      end
      describe "delete links" do
        it { should have_link('delete', href: reservation_path(Reservation.first)) }
        specify { ReservationStatus[Reservation.first.status].should_not == 'DELETED'}
        describe "should work" do 
          before { click_link('delete') }
          specify { ReservationStatus[Reservation.first.status].should == 'DELETED' }
        end
      end
      describe "other links" do
        it { should have_link('show') }
        it { should have_link('edit') }
      end
    end
  end

  #SHARED EXAMPLES FOR NEW PAGE
  shared_examples_for "new reservation page" do
    let(:submit) { "Make Reservation" }
    context "submit with invalid information" do
      it "by not inserting the reservation" do
        expect { click_button submit }.not_to change(Reservation, :count)
      end
      describe "pick up date and drop off date" do
        before { click_button submit }
        it "error message" do
          should have_content('Pick-up and drop-off dates are required!')
        end
      end
      #describe "vehicle" do
      #  before do 
      #    #fill_in ""
      #    click_button submit 
      #  end
      #  
      #  it "should contain error message for reservation code" do
      #    should have_content('Reservation code is required')
      #    #should have_xpath("//[contains(text(), 'different')]")
      #  end
      #  it "should contain error message for vehicle" do
      #    should have_content('Vehicle is required')
      #  end
      #  it "should contain error message for customer" do
      #    should have_content('Customer is required')
      #  end
      #  
      #end
    end
    #debugger
    it { should have_selector('select#vehicle_id') }
    it { should have_selector('select#client_id') }
    it { should have_selector('input#pick_up_date') }
    it { should have_selector('input#drop_off_date') }
    #context "submit with valid information", :js => true do
    #  before do  
    #    fill_in "License plate number", with: "AXB 12345"
    #    select model.make.make_name, :from => 'make[id]'
    #    page.execute_script("$('#make_id').trigger('change');")
    #    wait_until { page.has_content? "models of make:"}
    #    select model.model_name, :from => 'model[id]'
    #  end
    #  it "should create a vehicle" do
    #    expect { click_button submit; sleep 2 }.to change(Vehicle,:count).by(1)
    #  end
    #  context "should show flash message" do 
    #    before { click_button submit }
    #    it { should have_selector('div.alert.alert-success', text:'Vehicle inserted successfully!') }
    #  end
    #  context "after saving the vehicle" do
    #    before { click_button submit }
    #    it { should have_xpath("//title[contains(text(), '#{full_title('AXB 12345')}')]")  }
    #  end
    #end
    #context "filter models by make", :js => true do
    #  before do
    #    select another_model1.make.make_name, :from => 'make[id]'
    #    page.execute_script("$('#make_id').trigger('change');")
    #    wait_until { page.has_content? "models of make:"}
    #  end
    #  it ":all make's models should be in the list" do
    #    should have_xpath("//select[@id='model_id']/option[contains(text(), 'different')]")
    #    should have_xpath("//select[@id='model_id']/option[contains(text(), 'different2')]")
    #  end
    #  it ":no other make's models should be in the list" do
    #    should_not have_xpath("//select[@id='model_id']/option[contains(text(), 'test')]")
    #  end
    #end
  end

  #RESERVATIONS NEW PAGE
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
        sign_in user
        visit operation_path
    end
    after do
      Make.delete_all
      Group.delete_all
      Model.delete_all
    end
    context "from Reservations dropdown" do
      before { visit new_reservation_path }
      it_should_behave_like "new reservation page"
    end
    context "from Reservations index page" do
      before do 
        visit reservations_path
      end
      describe "js", :js => true do
        before { click_button "New Reservation"}
        it_should_behave_like "new reservation page"
      end
    end
  end



end
