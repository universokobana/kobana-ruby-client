## KobanaRubyClient - Ruby Client for Kobana Charges

This Ruby gem provides an easy way to interact with the Kobana APP, especially when dealing with charges.

### Prerequisites

- Ruby version >= 2.7.0
- Access to the Kobana API and a valid API key

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'kobana_ruby_client'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install kobana_ruby_client
```

### Configuration

You need to set your API key. The easiest way is to create an initializer in your Rails project:

`config/initializers/kobana_ruby_client.rb`

```ruby
KobanaRubyClient.api_key = 'YOUR_API_KEY_HERE'
```

Replace `'YOUR_API_KEY_HERE'` with your actual API key.

### Usage

Here's how you can use this gem to create, show, and index charges:

#### Creating a Charge

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
charge = KobanaRubyClient::Resources::Charge::Pix.new(api_key)
result = charge.create(charge_data)
puts result
```

#### Fetching a Charge

```ruby
charge_id = 1  # Replace with your charge ID
api_key = KobanaRubyClient.api_key
charge = KobanaRubyClient::Resources::Charge::Pix.new(api_key)
result = charge.find(charge_id)
puts result
```

#### Listing All Charges

```ruby
api_key = KobanaRubyClient.api_key
charge = KobanaRubyClient::Resources::Charge::Pix.new(api_key)
result = charge.index
puts result
```
