FactoryBot.define do
  factory :financial_account, class: Hash do
    uid { "0196f5e5-dd65-7322-9f36-c3979af436b7" }
    account_number { "00000000000000024618560" }
    account_digit { "3" }
    agency_number { "79731" }
    agency_digit { "3" }
    financial_provider_slug { "sicoob" }
    kind { "checking" }
    person_info { { name: "Margret Santos Filgueiras", document_number: "864.668.358-39" } }
    bank_id { "206" }
    custom_name { "Bancoob/Sicoob CC: 81519387-3" }

    initialize_with { attributes }
  end
end

