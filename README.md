

## KobanaRubyClient - Ruby Client for Kobana Services

This Ruby gem provides a convenient method to interact with the Kobana APP, simplifying operations with charges and bank billets.

### Prerequisites

- Ruby version >= 2.7.0
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

api_key = KobanaRubyClient.api_key
charge = KobanaRubyClient::Resources::Charge::Pix.new(api_key, :charges, {}, :sandbox) # You can specify the environment as :development, :sandbox, or :production
result = charge.create(charge_data)
puts result
```

##### Fetching a Charge

```ruby
charge_id = 1  # Replace with your charge ID
api_key = KobanaRubyClient.api_key
charge = KobanaRubyClient::Resources::Charge::Pix.new(api_key, :charges, {}, :sandbox)
result = charge.find(charge_id)
puts result
```

##### Listing All Charges

```ruby
api_key = KobanaRubyClient.api_key
charge = KobanaRubyClient::Resources::Charge::Pix.new(api_key, :charges, {}, :sandbox)
result = charge.index
puts result
```

#### **Bank Billets**

##### Creating a Bank Billeт

```ruby
bank_billet_data = { ... }

api_key = KobanaRubyClient.api_key
bank_billet = KobanaRubyClient::Resources::BankBillet::BankBillet.new(api_key, :bank_billets, {}, :sandbox)
result = bank_billet.create(bank_billet_data)
puts result
```

##### Listing All Bank Billets

```ruby
api_key = KobanaRubyClient.api_key
bank_billet = KobanaRubyClient::Resources::BankBillet::BankBillet.new(api_key, :bank_billets, {}, :sandbox)
result = bank_billet.index
puts result
```
