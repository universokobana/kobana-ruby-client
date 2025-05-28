# frozen_string_literal: true

FactoryBot.define do
  factory :admin_subaccount, class: Hash do
    email { "usuario@example.com" }
    account_type { "juridical" }
    business_legal_name { "Empresa LTDA" }
    business_cnpj { "12.345.678/0001-95" }
    nickname { "Empresa" }
    users { [{ email: "empresa@example.com" }] }
  end
end
