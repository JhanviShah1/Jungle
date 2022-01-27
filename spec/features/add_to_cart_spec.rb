require 'rails_helper'

RSpec.feature "Visitor navigates to home page", type: :feature, js: true do
  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end
  scenario "They see product added to My Cart(1)" do
    visit root_path
    find('.product:nth-of-type(1)').click_button 'Add'

    # DEBUG / VERIFY
    save_screenshot
    # puts page.html
    expect(page).to have_content 'My Cart (1)', count:1
end
end