require 'rails_helper'

RSpec.describe EmailFile, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:filename) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:uploaded_at) }
  end

  describe 'scopes' do
    let!(:old_file) { create(:email_file, uploaded_at: 1.hour.ago) }
    let!(:new_file) { create(:email_file, uploaded_at: 1.minute.ago) }

    describe '.recent' do
      it 'orders by uploaded_at desc' do
        expect(EmailFile.recent.first).to eq(new_file)
        expect(EmailFile.recent.last).to eq(old_file)
      end
    end
  end

  describe 'factory' do
    it 'creates valid email file' do
      file = build(:email_file)
      expect(file).to be_valid
    end

    it 'creates email file with content' do
      file = create(:email_file_with_content)
      expect(file.filename).to be_present
      expect(file.content).to include('From:')
      expect(file.content).to include('To:')
      expect(file.uploaded_at).to be_present
    end
  end
end
