require 'spec_helper'

describe "VehiclePages" do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:make) { FactoryGirl.create(:make) }
  let(:group) { FactoryGirl.create(:group) }
  let(:model) { FactoryGirl.create(:model, make: make, group: group) }
  before do
  	sign_in admin
  	select_menu(admin,'admin')
  end

  subject { page }

  describe "Index" do
    before(:all) { 30.times { FactoryGirl.create(:vehicle, model: model) } }
    after(:all)  { Vehicle.delete_all }
    before(:each) do
      click_link "List"
    end
    it { should have_selector('title', text: full_title('Vehicles')) }
    describe "pagination" do
      it { should have_selector('div.pagination') }
      it "should list each vehicle" do
        Vehicle.paginate(page: 1).each do |vehicle|
          page.should have_selector('li', text: '#{vehicle.make} #{vehicle.model}')
        end
      end
    end
    describe "delete links" do
      it { should have_link('delete') }
    end
    describe "edit links" do
      it { should have_link('edit') }
    end
    describe "show links" do
      it { should have_link('show') }
    end
  end

end
