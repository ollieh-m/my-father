module AuthenticationHelpers
  def mock_admin_access
    allow_any_instance_of(Admin::BaseController).to receive(:admin_access?).and_return(true)
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :feature
end
