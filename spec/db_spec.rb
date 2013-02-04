require 'spec_helper'

describe 'LDETL::DB' do
  let :db do
    LDETL::DB.new( TEST_SCHEMA, TEST_OPTIONS )
  end

  context 'connect schema' do

    it 'connect succesfully' do
      db.should_not eq nil
    end

    it 'connection is not nil' do
      db.connection.should_not eq nil
    end
  end
end
