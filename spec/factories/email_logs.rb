FactoryBot.define do
  factory :email_log do
    filename { "#{Faker::Lorem.word}.eml" }
    status { "success" }
    processed_at { Time.current }
    extracted_data { { name: "João Silva", email: "joao@example.com" }.to_json }
    error_message { nil }

    trait :success do
      status { "success" }
      extracted_data { { name: "João Silva", email: "joao@example.com", phone: "(11) 99999-9999", product_code: "ABC123", subject: "Pedido" }.to_json }
      error_message { nil }
    end

    trait :failure do
      status { "failure" }
      extracted_data { nil }
      error_message { "Failed to extract contact information" }
    end
  end
end
