# -*- coding: utf-8 -*-
module LDETL

  #
  # = ETL Class
  #
  # データベースへの格納，変換，スキーマ導出をサポートする
  #
  class ETL

    attr_reader :rdf_path
    attr_reader :rdf_type
    attr_reader :load_type
    attr_reader :db
    attr_reader :extractor

    #
    #== initialize
    #
    # constructor of ETL class
    #
    def initialize( rdf_path, rdf_type, load_type, db, options = [] )
      @rdf_path = rdf_path
      @rdf_type = rdf_type # restriction for only one type of RDF
      @load_type = load_type
      @db = db

      case @load_type
      when :divided_all
        @extractor = LDETL::Extractor::Divided_All.new( self )
      when :all
        @extractor = LDETL::Extractor::All.new( self )
      when :separated
        @extractor = LDETL::Extractor::Separated.new( self )
      else
        raise 'Undefined load_type'
      end

    end

    #
    #== extract
    #
    # extract data from resources
    #
    def extract

      @extractor.vertical_extractor
      @extractor.horizontal_extractor
      @extractor.duplicate

#      transformer = LEDTL::Transformer.new( extractor )
#      transformer.transform

#      loader = LDETL::Loader.new
#      loader.load
    end

    #
    #== measure_candidates
    #
    # return candidates of current ETL object
    #
    def measure_candidates
      table_lists = @etl.db.tables
    end

    #
    #== table_info
    #
    # return table information (columns(name, data type, is_resource))
    #
    def table_info( table = nil )
      if table
        # return correspond table's information
      else
        # return all table's information
      end
    end

    #
    #== relationships
    #
    # return table relationships
    #
    def relationships( table = nil )
      if table
        # return correspond table's relationships
      else
        # return all table's relationships
      end
    end

    #
    #== generate_schema
    #
    # generate Mondrian schema with measure_candidate
    #
    def generate_schema( measure_candidate )
    end
  end
end
