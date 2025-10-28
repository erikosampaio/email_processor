module EmlHelpers
  def load_eml(filename)
    fixtures_path = Rails.root.join('spec', 'fixtures', 'emails', filename)
    return File.read(fixtures_path) if File.exist?(fixtures_path)

    external_path = Rails.root.join('tech-test-desenvolvedor-pleno-main', 'emails', filename)
    return File.read(external_path) if File.exist?(external_path)

    raise "EML fixture not found: #{filename}. Add it to spec/fixtures/emails/"
  end
end

RSpec.configure do |config|
  config.include EmlHelpers
end
