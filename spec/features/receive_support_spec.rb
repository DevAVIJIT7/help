require 'rails_helper'

describe 'Receiving help request', js: true do 
  let(:user) { create :user, first_name: 'John' }
  let!(:support) { create :support, user: user, receiver: receiver, body: 'help me!' }
  let(:receiver) { create :user }

  before do
    authenticate_user(user)
  end

  it 'answering help request' do
    visit support_path(support)
    click_link('Acknowledge!')
    expect(page).to have_content('Support acknowledged! now get this thing done!')
    expect(page).to have_content("#{user.first_name} acknowledged this support")
    find('#comment_body').set('I will help you')
    click_button('Comment')
    expect(page).to have_content('You contributed to this support request')
    expect(page).to have_content("#{user.first_name} wrote")
    expect(page).to have_content('I will help you')
    page.evaluate_script('window.confirm = function() { return true; }')
    click_link('Mark as resolved')
    expect(page).to have_content('Finished helping. Awesome!')
    expect(current_path).to eq(root_path)
  end
end