

## Kobana - Ruby Client for Kobana Services

This Ruby gem provides a convenient method to interact with the Kobana APP, simplifying operations with charges and bank billets.

This is BETA and can change anytimes.
Use with caution.

[![Gem Version](https://badge.fury.io/rb/kobana.svg)](https://badge.fury.io/rb/kobana)

### Prerequisites

- Ruby version >= 3.2
- Access to the Kobana API and a valid API key

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'kobana'
```

Then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install kobana
```

### Configuration

Configure your API key by creating an initializer in your Rails project:

`config/initializers/kobana.rb`

```ruby
Kobana.configure do |config|
  config.api_token = 'YOUR_API_TOKEN'
  config.environment = :sandbox # you can specify the environment as :development, :sandbox, or :production
  config.api_version = :v1 #default: :v2
end
```

Replace `'YOUR_API_TOKEN'` with your actual API key from the corresponding environment.

### Usage

#### **Charges**

##### Creating a Charge

```ruby
attributes = {
  'amount' => 100.50,
  'payer' => {
    'document_number' => '1234567890',
    'name' => 'John Doe'
  },
  'pix_account_id' => 1,
  'expire_at' => '2023-12-31',
  'message' => 'Thanks for your purchase!',
  'additional_info' => {
    'Chave' => 'Value'
  },
  'custom_data' => '{"order_id": "12345"}'
}

pix = Kobana::Resources::Charge::Pix.create(attributes)
puts pix.id
```

##### Fetching a Charge

```ruby
charge_id = 1  # Replace with your charge ID
pix = Kobana::Resources::Charge::Pix.find(charge_id)
puts pix
```

##### Listing All Charges

```ruby
params = { status: ["opened", "overdue"], page: 2 }
results = Kobana::Resources::Charge::Pix.all(params)
puts result
```

#### **Bank Billets**

##### Creating a Bank Billet

```ruby
attributes = { ... }

bank_billet = Kobana::Resources::BankBillet::BankBillet.create(attributes)
puts bank_billet
```

##### Fetching a Bank Billet

```ruby
bank_billet_id = 1  # Replace with your charge ID
bank_billet = Kobana::Resources::BankBillet::BankBillet.find(bank_billet_id)
puts bank_billet
```

##### Listing All Bank Billets

```ruby
bank_billets = Kobana::Resources::BankBillet::BankBillet.all
puts bank_billets
```
