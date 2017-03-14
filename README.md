# QueueryClient

Queuery client for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'queuery_client'
```

## Usage

### If you don't use Rails

```ruby
# configuration
RedshiftConnector.logger = Logger.new(STDOUT)
GarageClient.name = "queuery-example"
QueueryClient.endpoint = 'http://localhost:3000'

# query
select_stmt = 'select column_a, column_b from the_great_table limit 10000; -- an awesome query shows amazing fact up'
bundle = QueueryClient.query(select_stmt)
bundle.each do |row|
  # do some useful works
  p row
end
```

### If you are on Rails

In `config/initializers/queuery.rb`:

```ruby
QueueryClient.endpoint = 'http://localhost:3000'
```

In your code:

```ruby
select_stmt = 'select column_a, column_b from the_great_table limit 10000; -- an awesome query shows amazing fact up'
bundle = QueueryClient.query(select_stmt)
bundle.each do |row|
  # do some useful works
  p row
end
```
