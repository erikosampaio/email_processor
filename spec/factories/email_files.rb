FactoryBot.define do
  factory :email_file do
    filename { "#{Faker::Lorem.word}.eml" }
    content { Faker::Lorem.paragraph }
    uploaded_at { Time.current }
  end

  factory :email_file_with_content, parent: :email_file do
    transient do
      from_email { "loja@fornecedorA.com" }
      to_email { "vendas@suaempresa.com" }
      subject { "Pedido de orçamento" }
      body_content { "Nome: João Silva\nEmail: joao@example.com\nTelefone: (11) 99999-9999\nProduto: ABC123" }
    end

    content do
      <<~EML
        From: #{from_email}
        To: #{to_email}
        Subject: #{subject}

        #{body_content}
      EML
    end
  end
end
