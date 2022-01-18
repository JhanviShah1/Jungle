class Admin::DashboardController < ApplicationController
  
  http_basic_authenticate_with name: ENV['username'], password: ENV['password']
  def show
    @productCount = Product.count
    @categoriesCount = Category.count
  end
end
