require 'rspec'
require 'rspec/autorun'
require 'ldetl'
require 'sequel'

RSpec.configure do |config|
  include LDETL
  config.before :all do
    setup_db
  end
end

DEFAULT_SCHEMA = 'ldetl_sample'
DATA_PATH = File.expand_path( './data/' )

MYSQL_USER = 'root'
MYSQL_PASSWORD = ''

def setup_db
end
