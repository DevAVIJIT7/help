require 'rails_helper'

describe 'Creating help request', js: true do
  let(:user) { create :user }
  let!(:topic1) { create :topic, title: 'super help', description: 'Help me!' }
  let!(:supporter) { create :user }

  before do
    authenticate_user(user)
    topic1.skills << create(:skill, user: supporter, topic: topic1)
    visit root_path
  end

  it 'adding help request' do
    click_on 'I need help'
    expect(page).to have_xpath('/html/body/main/div[2]/div[2]/div/a/span[3]')
    find("a[href='/topics/1']").click
    expect(page).to have_content("Need help with #{topic1.title}?")

    fill_in 'support_body', with: 'HELP ME!'
    click_on 'Ask for help'
    expect(page).to have_content('We asked to help you.')
    expect(current_path).to eq(root_path)
  end
end
