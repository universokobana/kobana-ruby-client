

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

#### Global Configuration (Single API Token)

Configure your API key by creating an initializer in your Rails project:

`config/initializers/kobana.rb`

```ruby
Kobana.configure do |config|
  config.api_token = 'YOUR_API_TOKEN'
  config.environment = :sandbox # you can specify the environment as :development, :sandbox, or :production
end
```

Replace `'YOUR_API_TOKEN'` with your actual API key from the corresponding environment.

#### Multi-Client Configuration (Multiple API Tokens)

For applications that need to work with multiple Kobana accounts simultaneously (e.g., multi-tenant applications), you can create multiple client instances:

```ruby
# Create separate clients for different accounts
client1 = Kobana::Client.new(
  api_token: 'CLIENT1_API_TOKEN',
  environment: :production
)

client2 = Kobana::Client.new(
  api_token: 'CLIENT2_API_TOKEN',
  environment: :sandbox
)

# Use client-specific resources
pix1 = client1.charge.pix.create(attributes)
pix2 = client2.charge.pix.create(attributes)

# Each client maintains its own configuration
account1 = client1.financial.account.find(account_id)
account2 = client2.financial.account.find(account_id)
```

You can also configure clients after initialization:

```ruby
client = Kobana::Client.new
client.configure do |config|
  config.api_token = 'YOUR_API_TOKEN'
  config.environment = :production
  config.custom_headers = { 'X-Custom-Header' => 'Value' }
  config.debug = true
end
```

#### HTTP timeouts

By default the client has **no** HTTP timeout, so a slow or hanging API call
blocks the caller until the underlying socket gives up. Set `open_timeout`
(connection establishment) and/or `timeout` (response read), in seconds, to fail
fast instead — both are passed straight to Faraday:

```ruby
Kobana.configure do |config|
  config.api_token = 'YOUR_API_TOKEN'
  config.open_timeout = 2 # seconds to establish the TCP connection
  config.timeout = 8      # seconds to read the response
end
```

When unset (`nil`), behavior is unchanged. Tune `timeout` above the longest
expected operation (e.g. large multipart uploads / batch exports).

### Usage

The gem supports both global configuration (backward compatible) and multi-client usage patterns.

#### **Charges**

##### Creating a Charge

Using global configuration:
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

# Global configuration approach (backward compatible)
pix = Kobana::Resources::Charge::Pix.create(attributes)
```

Using client-specific configuration:
```ruby
# Client-specific approach
client = Kobana::Client.new(api_token: 'YOUR_TOKEN')
pix = client.charge.pix.create(attributes)
pix.id # 1
pix.new_record? false
pix.created? # true
pix.attributes # {}


pix = Kobana::Resources::Charge::Pix.new(attributes)
pix.id nil
pix.new_record? # true
pix.created? # false
pix.attributes # {}

pix.save
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

bank_billet = Kobana::Resources::Charge::BankBillet.create(attributes)
puts bank_billet
```

##### Fetching a Bank Billet

```ruby
bank_billet_id = 1  # Replace with your charge ID
bank_billet = Kobana::Resources::Charge::BankBillet.find(bank_billet_id)
puts bank_billet
```

##### Listing All Bank Billets

```ruby
bank_billets = Kobana::Resources::Charge::BankBillet.all
puts bank_billets
```
