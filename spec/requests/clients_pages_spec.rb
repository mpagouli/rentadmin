require 'spec_helper'

describe "ClientsPages" do
  
  let(:admin) { FactoryGirl.create(:admin) }

  subject { page }

  #CLIENTS INDEX PAGE
  describe "Index" do
    before do
      sign_in admin
      visit admin_path
      visit clients_path
    end
    describe "page" do 
      it { should have_link('Customer List') }
      it { should have_selector('title', text: full_title('Customers')) }
      it { should have_link('Help', href: '#' ) }
      it { should have_link('Sign out', href: signout_path ) }
    end
    describe "List" do
      before do  
        31.times { FactoryGirl.create(:client) }
        visit admin_path
        visit clients_path
      end
      after  do 
        Client.delete_all
      end
      context "'New Customer' button" do 
        it { should have_selector('form', :action => '/clients/new') }
        it { should have_selector('input', :type => 'submit', :value => 'New Customer') }
      end
      it { should have_link('Customer List') }
      context "pagination" do
        it { should have_selector('div.pagination') }
        it ": should list each customer" do
          Client.paginate(page: 1).each do |cust|
            page.should have_selector('div', text: "#{cust.identity_number}")
          end
        end
      end
      describe "delete links" do
        it { should have_link('delete', href: client_path(Client.first)) }
        it "should work" do 
          expect { click_link('delete') }.to change(Client, :count).by(-1)
        end
      end
      describe "other links" do
        it { should have_link('show') }
        it { should have_link('edit') }
      end
    end
  end


end
