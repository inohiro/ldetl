require 'spec_helper'

describe 'extractor/base' do

  let :db do
    LDETL::DB.new( TEST_SCHEMA, TEST_OPTIONS )
  end

  let :etl do
    LDETL::ETL.new( DATA_PATH, :n3, :separated, db )
  end

  context 'create_reader' do

    it 'create reader for n3' do
      reader = etl.extractor.create_reader
      reader.should eq RDF::N3::Reader
    end

    it 'create reader for n-triples' do
      etl = LDETL::ETL.new( DATA_PATH, :ntriples, :separated, db )
      reader = etl.extractor.create_reader
      reader.should eq RDF::NTriples::Reader
    end

    it 'create reader for n-triples 2' do
      etl = LDETL::ETL.new( DATA_PATH, :nt, :separated, db )
      reader = etl.extractor.create_reader
      reader.should eq RDF::NTriples::Reader
    end

    it 'create reader for xml' do
      etl = LDETL::ETL.new( DATA_PATH, :xml, :separated, db )
      reader = etl.extractor.create_reader
      [ RDF::Reader, RDF::RDFXML::Reader ].should include reader
    end

    it 'create reader for xml 2' do
      etl = LDETL::ETL.new( DATA_PATH, 'xml', :separated, db )
      reader = etl.extractor.create_reader
      [ RDF::Reader, RDF::RDFXML::Reader ].should include reader
    end

    it 'create reader for turtle' do
      etl = LDETL::ETL.new( DATA_PATH, :turtle, :separated, db )
      reader = etl.extractor.create_reader
      reader.should eq RDF::Reader
    end

    it 'create reader for turtle 2' do
      etl = LDETL::ETL.new( DATA_PATH, :ttl, :separated, db )
      reader = etl.extractor.create_reader
      reader.should eq RDF::Reader
    end

    it 'rise undefined rdf type' do
      etl = LDETL::ETL.new( DATA_PATH, :hoge, :separated, db )
      expect { etl.extractor.create_reader }.to raise_error
    end

    it 'rise undefined rdf type 2' do
      etl = LDETL::ETL.new( DATA_PATH, 'hoge', :separated, db )
      expect { etl.extractor.create_reader }.to raise_error
    end
  end

  context 'create_all_triples_table' do
    pending
  end

  context 'create_all_rdf_types_table' do
    pending
  end

  context 'iteration_path' do
    it 'contains *.nt' do
      etl = LDETL::ETL.new( DATA_PATH, :nt, :separated, db )
      path = etl.extractor.iteration_path
      path.should eq DATA_PATH + '*.nt'
    end

    it 'contains *.n3' do
      etl = LDETL::ETL.new( DATA_PATH, :n3, :separated, db )
      path = etl.extractor.iteration_path
      path.should eq DATA_PATH + '*.n3'
    end

    it 'contains *.xml' do
      etl = LDETL::ETL.new( DATA_PATH, :xml, :separated, db )
      path = etl.extractor.iteration_path
      path.should eq DATA_PATH + '*.xml'
    end

    it 'cottlains *.ttl' do
      etl = LDETL::ETL.new( DATA_PATH, :ttl, :separated, db )
      path = etl.extractor.iteration_path
      path.should eq DATA_PATH + '*.ttl'
    end
  end

  context 'table_name' do
    it 'return t1 as Symbol' do
      etl.extractor.v_table_name( 1 ).should eq :t1
    end

    it 'return t12 as SYmbol' do
      etl.extractor.v_table_name( '12' ).should eq :t12
    end

    it 'return t1_h as Symbol' do
      etl.extractor.h_table_name( 1 ).should eq :t1_h
    end

    it 'return t12_h as Symbol' do
      etl.extractor.h_table_name( '12' ).should eq :t12_h
    end
  end

  context '[private]value_divider' do
    before :each do
      stm = {
        :subject => RDF::URI.new( 'http://www.example.com' ),
        :predicate => RDF::DC.creator,
        :object => RDF::Literal.new( 'Example' )
      }
      @triple = RDF::Statement.new( stm )
    end

    it 'object is string without type definition' do
      etl.extractor.send( :value_divider, @triple.object.to_s ).should eq []
    end

    it 'object is integer without type definition' do
      @triple.object = RDF::Literal.new( 3456 )
      etl.extractor.send( :value_divider, @triple.object.to_s ).should eq []
    end

    it 'object is string with type definition' do
      @triple.object = RDF::Literal.new( "12344", :datatype => RDF::XSD.date )

      pending
      pp @triple
      puts @triple.object
      result = etl.extractor.send( :value_divider, @triple.object.to_s )
      result.should_not eq []
      result[0].should eq "Hello"
      result[1].should eq "string"
    end
  end

  context '[private]detect_literal_type' do
    before :all do
      stm = {
        :subject => RDF::URI.new( 'http://www.example.com' ),
        :predicate => RDF::DC.creator,
        :object => RDF::Literal.new( 'Example' )
      }
      @triple = RDF::Statement.new( stm )
    end

    it 'hoge' do
      pending

      pp @triple
      result = etl.extractor.send( :detect_literal_type, @triple )
      pp result
    end
  end

  context '[private]detect_resource_type' do

  end

end
