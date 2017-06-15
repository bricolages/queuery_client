# QueueryClient

Queuery client for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'queuery_client'
```

## Configuration

### If you don't use Rails

```ruby
# configuration
RedshiftConnector.logger = Logger.new($stdout)
GarageClient.configure do |config|
  config.name = "queuery-example"
end
QueueryClient.configure do |config|
  config.endpoint = 'http://localhost:3000'
  config.token = 'XXXXXXXXXXXXXXXXXXXXX'
  config.token_secret = '*******************'
end
```

### If you are on Rails

In `config/initializers/queuery.rb`:

```ruby
QueueryClient.configure do |config|
  config.endpoint = 'http://localhost:3000'
  config.token = 'XXXXXXXXXXXXXXXXXXXXX'
  config.token_secret = '*******************'
end
```

## Usage

```ruby
select_stmt = 'select column_a, column_b from the_great_table; -- an awesome query shows amazing fact up'
bundle = QueueryClient.query(select_stmt)
bundle.each do |row|
  # do some useful works
  p row
end
```
