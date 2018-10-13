RSpec.configure do |config|
  config.after(:example, :type => :document_upload) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/public/test/"])
    end
  end
end
