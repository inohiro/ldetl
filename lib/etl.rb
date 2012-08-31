# -*- coding: utf-8 -*-
module LDETL

  #
  # = ETL Class
  #
  # データベースへの格納，変換，スキーマ導出をサポートする
  #
  class ETL

    attr_reader :schema_name
    attr_reader :rdf_file
    attr_reader :load_type

    #
    #== initialize
    #
    # constructor of ETL class
    #
    def initialize( schema_name, rdf_file, load_type )
      @schema_name = schema_name
      @rdf_file = rdf_file
      @load_type = load_type
    end

    #
    #== run
    #
    # run a ETL process
    #
    def run
      extractor = LDETL::Extractor.new( self )
      extractor.extract

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
    end

    #
    #== table_info
    #
    # return table information (columns(name, data type, is_resource))
    #
    def table_info( table = nil )
      if table == nil
        # return all table's information
      else
        # return correspond table's information
      end
    end

    #
    #== relationships
    #
    # return table relationships
    #
    def relationships( table = nil )
      if table == nil
        # return all table's relationships
      else
        # return correspond table's relationships
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
