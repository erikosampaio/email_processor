module EmlHelpers
  def load_eml(filename)
    base = Rails.root.join('tech-test-desenvolvedor-pleno-main', 'emails', filename)
    File.read(base)
  end
end

RSpec.configure do |config|
  config.include EmlHelpers
end
