require 'spec_helper'

describe 'etl' do

  before :all do
    @db = LDETL::DB.new( TEST_SCHEMA, TEST_OPTIONS )
    @etl = LDETL::ETL.new( DATA_PATH, :n3, :separated, @db )
  end

  context 'create etl object' do
    it 'is not nil' do
      @etl.should_not eq nil
    end

    it 'rdf_path is not nil' do
      @etl.rdf_path.should_not eq nil
      @etl.rdf_path.should_not eq ''
    end

    it 'load_type is separated' do
      @etl.load_type.should eq :separated
    end

    it 'db object is not nil' do
      @etl.db.should_not eq nil
    end

    it 'db.connection si not nil' do
      @etl.db.connection.should_not eq nil
    end

    it 'extractor will be :separated' do
      @etl.extractor.is_a?( LDETL::Extractor::Separated ).should eq true
    end

    it 'extractor will be :divided_all' do
      @etl = LDETL::ETL.new( DATA_PATH, :n3, :divided_all, @db )
      @etl.extractor.is_a?( LDETL::Extractor::Divided_All ).should eq true
    end

    it 'extractor will be :all' do
      @etl = LDETL::ETL.new( DATA_PATH, :n3, :all, @db )
      @etl.extractor.is_a?( LDETL::Extractor::All ).should eq true
    end

    it 'raise undefined load_type error' do
      expect {@etl = LDETL::ETL.new( DATA_PATH, :n3, :hoge, @db )}.to raise_error
    end

  end

end
