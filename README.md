

## KobanaRubyClient - Ruby Client for Kobana Services

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
gem 'kobana_ruby_client'
```

Then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install kobana_ruby_client
```

### Configuration

Configure your API key by creating an initializer in your Rails project:

`config/initializers/kobana_ruby_client.rb`

```ruby
KobanaRubyClient.api_key = 'YOUR_API_KEY_HERE'
```

Replace `'YOUR_API_KEY_HERE'` with your actual API key.

### Usage

To use this gem:

#### **Configuration**

```ruby
KobanaRubyClient.configure do |config|
  config.api_token = 'YOUR_API_KEY'
  config.environment = :sandbox # you can specify the environment as :development, :sandbox, or :production
  config.api_version = :v1 #or :v2
end
```

#### **Charges**

##### Creating a Charge

```ruby
charge_data = {
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

charge = KobanaRubyClient::Resources::Charge::Pix.new
result = charge.create(charge_data)
puts result
```

##### Fetching a Charge

```ruby
charge_id = 1  # Replace with your charge ID
charge = KobanaRubyClient::Resources::Charge::Pix.new
result = charge.find(charge_id)
puts result
```

##### Listing All Charges

```ruby
charge = KobanaRubyClient::Resources::Charge::Pix.new
params = { status: ["opened", "overdue"], page: 2 }
results = charge.index(params)
puts result
```

#### **Bank Billets**

##### Creating a Bank Billet

```ruby
bank_billet_data = { ... }

bank_billet = KobanaRubyClient::Resources::BankBillet::BankBillet.new
result = bank_billet.create(bank_billet_data)
puts result
```

##### Fetching a Bank Billet

```ruby
bank_billet_id = 1  # Replace with your charge ID
bank_billet = KobanaRubyClient::Resources::BankBillet::BankBillet.new
result = bank_billet.find(bank_billet_id)
puts result
```

##### Listing All Bank Billets

```ruby
bank_billet = KobanaRubyClient::Resources::BankBillet::BankBillet.new
result = bank_billet.index
puts result
```
