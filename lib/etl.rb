# -*- coding: utf-8 -*-
module LDETL

  #
  # = ETL Class
  #
  # データベースへの格納，変換，スキーマ導出をサポートする
  #
  class ETL

    def initialize( schema_name, rdf_file, load_type )
      @schema_name = schema_name
      @rdf_file = rdf_file
      @load_type = load_type
    end

    def run
      extractor = LDETL::Extractor.new( @schema_name, @rdf_type, @load_type )
      extractor.extract

#      transformer = LEDTL::Transformer.new( extractor )
#      transformer.transform

#      loader = LDETL::Loader.new
#      loader.load
    end

    #
    # 
    def measure_candidates
    end

    def table_info( table = nil )
      if table == nil
        # return all table's information
      else
        # return correspond table's information
      end
    end

    def relations( table = nil )
      if table == nil
        # return all table's relationships
      else
        # return correspond table's relationships
      end
    end

    def create_schema( measure_candidate )
    end
    
  end
end
