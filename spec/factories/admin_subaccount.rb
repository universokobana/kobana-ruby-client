# frozen_string_literal: true

FactoryBot.define do
  factory :admin_subaccount, class: Hash do
    email { "usuario#{rand(10_000)}@kobana.com.br" }
    account_type { "juridical" }
    business_legal_name { "Empresa LTDA" }
    # business_cnpj { CNPJ.generate(true) }
    business_cnpj { "92.051.295/0001-43" }
    nickname { "Empresa" }
    users { [{ email: "empresa@example.com" }] }
  end
end
