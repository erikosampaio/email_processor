require 'rails_helper'

RSpec.describe Parsers::SupplierAParser do
  describe '#extract_data and #successful?' do
    context 'with valid email content' do
      let(:parser) { build(:supplier_a_parser) }

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
      let(:content) { load_eml('email7.eml') }
      let(:parser) { described_class.new(content, 'loja@fornecedorA.com') }

      it 'fails when contact info is missing' do
        expect(parser.successful?).to be false
        expect(parser.has_contact_info?).to be false
      end
    end

    context 'with custom email content' do
      let(:email_content) do
        <<~EMAIL
          From: loja@fornecedorA.com
          To: vendas@suaempresa.com
          Subject: Pedido de orçamento

          Nome: Maria Santos
          Email: maria@example.com
          Telefone: (11) 98765-4321
          Código do Produto: XYZ789
          Assunto: Solicitação de preço
        EMAIL
      end
      let(:parser) { described_class.new(email_content, 'loja@fornecedorA.com') }

      it 'extracts data from custom content' do
        data = parser.extract_data

        expect(parser.successful?).to be true
        expect(data[:name]).to eq('Maria Santos')
        expect(data[:email]).to eq('maria@example.com')
        expect(data[:phone]).to eq('(11) 98765-4321')
        expect(data[:product_code]).to eq('XYZ789')
        expect(data[:subject]).to eq('Pedido de orçamento')
      end
    end
  end
end
