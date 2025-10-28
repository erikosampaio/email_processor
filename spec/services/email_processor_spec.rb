require 'rails_helper'

RSpec.describe Services::EmailProcessor do
  describe '#process' do
    context 'with valid email file' do
      let(:email_file) { create(:email_file_with_content, filename: 'email2.eml') }
      let(:processor) { described_class.new(email_file) }

      it 'creates Customer and success log for Fornecedor A' do
        expect { processor.process }.to change(Customer, :count).by(1)
          .and change(EmailLog, :count).by(1)

        result = processor.result
        expect(result[:status]).to eq(:success)

        log = EmailLog.last
        expect(log.status).to eq('success')
        expect(log.filename).to eq('email2.eml')
        expect(log.extracted_data).to be_present
        expect(log.error_message).to be_nil

        customer = Customer.last
        expect(customer.name).to be_present
        expect(customer.email).to match(/@/)
      end

      it 'returns success result' do
        result = processor.process
        expect(result[:status]).to eq(:success)
        expect(result[:data]).to be_present
      end
    end

    context 'with missing contact information' do
      let(:email_file) { create(:email_file, filename: 'email7.eml', content: load_eml('email7.eml')) }
      let(:processor) { described_class.new(email_file) }

      it 'creates failure log when contact info missing' do
        expect { processor.process }.not_to change(Customer, :count)
        expect { processor.process }.to change(EmailLog, :count).by(1)

        result = processor.result
        expect(result[:status]).to eq(:failure)
        expect(result[:error]).to be_present

        log = EmailLog.last
        expect(log.status).to eq('failure')
        expect(log.error_message).to be_present
        expect(log.extracted_data).to be_nil
      end
    end

    context 'with unknown sender' do
      let(:email_content) do
        <<~EMAIL
          From: unknown@example.com
          To: vendas@suaempresa.com
          Subject: Test
        EMAIL
      end
      let(:email_file) { create(:email_file, filename: 'unknown.eml', content: email_content) }
      let(:processor) { described_class.new(email_file) }

      it 'creates failure log for unknown sender' do
        expect { processor.process }.to change(EmailLog, :count).by(1)

        log = EmailLog.last
        expect(log.status).to eq('failure')
        expect(log.error_message).to include('Remetente desconhecido')
      end
    end

    context 'with invalid email content' do
      let(:email_file) { create(:email_file, filename: 'invalid.eml', content: 'invalid content') }
      let(:processor) { described_class.new(email_file) }

      it 'handles parsing errors gracefully' do
        expect { processor.process }.to change(EmailLog, :count).by(1)

        result = processor.result
        expect(result[:status]).to eq(:failure)
        expect(result[:error]).to be_present
      end
    end
  end
end
