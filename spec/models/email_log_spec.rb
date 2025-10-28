require 'rails_helper'

RSpec.describe EmailLog, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:filename) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:processed_at) }

    it 'validates status inclusion' do
      log = build(:email_log, status: 'invalid')
      expect(log).not_to be_valid
      expect(log.errors[:status]).to include('is not included in the list')
    end

    it 'accepts valid status values' do
      expect(build(:email_log, status: 'success')).to be_valid
      expect(build(:email_log, status: 'failure')).to be_valid
    end
  end

  describe 'scopes' do
    let!(:success_log) { create(:email_log, :success, filename: 'success.eml') }
    let!(:failure_log) { create(:email_log, :failure, filename: 'failure.eml') }

    describe '.successful' do
      it 'returns only success logs' do
        expect(EmailLog.successful).to include(success_log)
        expect(EmailLog.successful).not_to include(failure_log)
      end
    end

    describe '.failed' do
      it 'returns only failure logs' do
        expect(EmailLog.failed).to include(failure_log)
        expect(EmailLog.failed).not_to include(success_log)
      end
    end

    describe '.recent' do
      it 'orders by processed_at desc' do
        # Clear existing logs to avoid interference
        EmailLog.delete_all

        old_log = create(:email_log, processed_at: 1.hour.ago)
        new_log = create(:email_log, processed_at: 1.minute.ago)

        recent_logs = EmailLog.recent.to_a
        expect(recent_logs.first).to eq(new_log)
        expect(recent_logs.last).to eq(old_log)
      end
    end
  end

  describe 'factory' do
    it 'creates valid email log' do
      log = build(:email_log)
      expect(log).to be_valid
    end

    it 'creates success log with traits' do
      log = create(:email_log, :success)
      expect(log.status).to eq('success')
      expect(log.extracted_data).to be_present
      expect(log.error_message).to be_nil
    end

    it 'creates failure log with traits' do
      log = create(:email_log, :failure)
      expect(log.status).to eq('failure')
      expect(log.extracted_data).to be_nil
      expect(log.error_message).to be_present
    end
  end
end
