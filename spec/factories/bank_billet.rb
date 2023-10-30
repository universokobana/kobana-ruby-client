# frozen_string_literal: true

FactoryBot.define do
  factory :bank_billet, class: Hash do
    amount { 9.01 }
    description { "Despesas do contrato 0012" }
    expire_at { "2024-01-01" }
    customer_address { "Rua quinhentos" }
    customer_address_complement { "Sala 4" }

    customer_address_number { "111" }
    customer_city_name { "Rio de Janeiro" }
    customer_cnpj_cpf { "34.565.715/0001-03" }
    customer_email { "cliente@example.com" }
    customer_neighborhood { "Sao Francisco" }

    customer_person_name { "Joao da Silva" }
    customer_person_type { "individual"  }
    customer_phone_number { "2112123434" }
    customer_state { "RJ" }
    customer_zipcode { "12312-123" }

    initialize_with { attributes }
  end
end
