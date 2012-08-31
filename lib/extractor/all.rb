module LDETL
  module Extractor
    class All < Base
      def vertical_extract
        initialize_tables
        table_name = ALL_TRIPLES
        rdf_reader = create_reader

        Dir.glob( iteration_path ) do |f|
          path = "file:#{f.to_s}"
          
          reader = rdf_reader.open( path )
          reader.each do |stm|
            @etl.db.add_rdf_type( stm.object ) if stm.predicate == RDF::type

            type_info = detect_type( stm )
            @etl.db.insert_triple( table_name, stm, type_info )
          end
        end
      end

      def horizontal_extract
      end

      def duplicate
      end

      #=======================================================================
      private
      #=======================================================================

      def initialize_tables
        all_triples_attrs = [ { :name => 'subject', :type => String},
                              { :name => 'predicate', :type => String },
                              { :name => 'object', :type => String},
                              { :nema => 'value_type', :type => String },
                              { :name => 'value_type_id', :type => Integer } ]
        @etl.db.create_table( ALL_TRIPLES, all_triples_attrs )

        all_rdf_types_attrs = [ { :name => 'uri', :type => String } ]
        @etl.db.create_table_with_pk( ALL_RDF_TYPES, all_rdf_types_attrs, 'id' )
      end

    end
  end
end
