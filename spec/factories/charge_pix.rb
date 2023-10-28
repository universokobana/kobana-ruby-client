FactoryBot.define do
  factory :charge_pix, class: Hash do
    amount { 120.99 }
    payer do
      {
        document_number: "779.467.060-81",
        name: "João da Silva"
      }
    end
    pix_account_id { 431 }
    expire_at { "2024-12-02T10:03:56-03:00" }
    message { "string" }
    additional_info { { "Chave" => "Valor" } }

    initialize_with { attributes }
  end
end
