require 'rails_helper'

RSpec.describe ProcessEmailJob, type: :job do
  describe '#perform' do
    context 'with valid email file' do
      let(:email_file) { create(:email_file_with_content, filename: 'email2.eml') }

      it 'enqueues job correctly' do
        expect {
          ProcessEmailJob.perform_later(email_file.id)
        }.to have_enqueued_job(ProcessEmailJob).with(email_file.id).on_queue('default')
      end

      it 'processes email successfully' do
        expect {
          ProcessEmailJob.perform_now(email_file.id)
        }.to change(Customer, :count).by(1)
          .and change(EmailLog, :count).by(1)

        log = EmailLog.last
        expect(log.status).to eq('success')
        expect(log.filename).to eq('email2.eml')
      end

      it 'handles job execution with perform_enqueued_jobs' do
        ProcessEmailJob.perform_later(email_file.id)

        expect {
          perform_enqueued_jobs
        }.to change(Customer, :count).by(1)
          .and change(EmailLog, :count).by(1)
      end
    end

    context 'with invalid email file' do
      let(:email_file) { create(:email_file, filename: 'email7.eml', content: load_eml('email7.eml')) }

      it 'creates failure log' do
        expect {
          ProcessEmailJob.perform_now(email_file.id)
        }.not_to change(Customer, :count)

        expect {
          ProcessEmailJob.perform_now(email_file.id)
        }.to change(EmailLog, :count).by(1)

        log = EmailLog.last
        expect(log.status).to eq('failure')
        expect(log.error_message).to be_present
      end
    end

    context 'with non-existent email file' do
      it 'handles missing file gracefully' do
        expect {
          ProcessEmailJob.perform_now(99999)
        }.to raise_error(NoMethodError)
      end
    end

    context 'with processing error' do
      let(:email_file) { create(:email_file, filename: 'error.eml', content: 'invalid') }

      before do
        allow_any_instance_of(Services::EmailProcessor).to receive(:process).and_raise(StandardError, 'Test error')
      end

      it 'creates failure log and re-raises error' do
        expect {
          ProcessEmailJob.perform_now(email_file.id)
        }.to raise_error(StandardError, 'Test error')
          .and change(EmailLog, :count).by(1)

        log = EmailLog.last
        expect(log.status).to eq('failure')
        expect(log.error_message).to eq('Test error')
      end
    end
  end
end
