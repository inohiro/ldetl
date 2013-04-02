require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'rspec/autorun'
require 'ldetl'
require 'sequel'

require 'pp'

RSpec.configure do |config|
  include LDETL
  config.before :all do
#    setup_db
  end
end

TEST_SCHEMA = 'ldetl_sample'
DATA_PATH = File.expand_path( './spec/data/' )

TEST_USER = 'root'
TEST_PASSWORD = ''

TEST_OPTIONS = {
  :user => TEST_USER,
  :password => TEST_PASSWORD
}

options = []

def setup_db
  connection = nil
  begin
    connection = Sequel.connect( "#{DEFAULT_DB_TYPE}://#{TEST_USER}:#{TEST_PASSWORD}@#{DEFAULT_HOST}/#{TEST_SCHEMA}",
                                 { :encoding => DEFAULT_ENCODING } )
    require 'pp'
    pp connection
  rescue => exp
    puts exp
  end
end
