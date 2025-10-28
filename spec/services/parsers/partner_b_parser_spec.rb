require 'rails_helper'

RSpec.describe Parsers::PartnerBParser do
  describe '#extract_data and #successful?' do
    context 'with valid email content' do
      let(:parser) { build(:partner_b_parser) }

      it 'extracts all required fields' do
        data = parser.extract_data

        expect(parser.successful?).to be true
        expect(data[:name]).to be_present
        expect(data[:email]).to match(/@/)
        expect(data[:phone]).to be_present
        expect(data[:product_code]).to be_present
        expect(data[:subject]).to be_present
      end

      it 'has contact information' do
        expect(parser.has_contact_info?).to be true
      end
    end

    context 'with missing contact information' do
      let(:content) { load_eml('email8.eml') }
      let(:parser) { described_class.new(content, 'contato@parceiroB.com') }

      it 'fails when contact info is missing' do
        expect(parser.successful?).to be false
        expect(parser.has_contact_info?).to be false
      end
    end

    context 'with custom email content' do
      let(:email_content) do
        <<~EMAIL
          From: contato@parceiroB.com
          To: vendas@suaempresa.com
          Subject: Consulta de produto

          Cliente: Ana Costa
          Email: ana@example.com
          Telefone: (21) 98765-4321
          Produto: PROD-456
          Assunto: Dúvidas sobre produto
        EMAIL
      end
      let(:parser) { described_class.new(email_content, 'contato@parceiroB.com') }

      it 'extracts data from custom content' do
        data = parser.extract_data

        expect(parser.successful?).to be true
        expect(data[:name]).to eq('Ana Costa')
        expect(data[:email]).to eq('ana@example.com')
        expect(data[:phone]).to eq('(21) 98765-4321')
        expect(data[:product_code]).to eq('PROD-456')
        expect(data[:subject]).to eq('Consulta de produto')
      end
    end

    context 'ignoring sender email' do
      let(:email_content) do
        <<~EMAIL
          From: contato@parceiroB.com
          To: vendas@suaempresa.com
          Subject: Test

          Email: cliente@example.com
        EMAIL
      end
      let(:parser) { described_class.new(email_content, 'contato@parceiroB.com') }

      it 'ignores sender email when extracting client email' do
        data = parser.extract_data
        expect(data[:email]).to eq('cliente@example.com')
        expect(data[:email]).not_to eq('contato@parceiroB.com')
      end
    end
  end
end
