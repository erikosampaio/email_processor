FactoryBot.define do
  factory :supplier_a_parser, class: 'Parsers::SupplierAParser' do
    transient do
      email_content do
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
      sender_email { 'loja@fornecedorA.com' }
    end

    initialize_with { new(email_content, sender_email) }
  end

  factory :partner_b_parser, class: 'Parsers::PartnerBParser' do
    transient do
      email_content do
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
      sender_email { 'contato@parceiroB.com' }
    end

    initialize_with { new(email_content, sender_email) }
  end
end
