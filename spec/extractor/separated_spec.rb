require 'spec_helper'

describe 'extractor/separated' do

  let :db do
    LDETL::DB.new( TEST_SCHEMA, TEST_OPTIONS )
  end

  let :etl do
    LDETL::ETL.new( DATA_PATH, :n3, :separated, db )
  end

  context 'general' do
    it 'extractor is a instance of Separated' do
      etl.extractor.is_a?( LDETL::Extractor::Separated ).should eq true
    end

    it 'rdf reader is a instance for n3' do
      reader = etl.extractor.create_reader
      reader.should eq RDF::N3::Reader
    end
  end

  context 'vertical_extract' do
  end
end
