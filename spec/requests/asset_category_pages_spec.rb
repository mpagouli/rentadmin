require 'spec_helper'

describe "AssetCategoryPages" do
  describe "GET /asset_category_pages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get asset_category_pages_index_path
      response.status.should be(200)
    end
  end
end
