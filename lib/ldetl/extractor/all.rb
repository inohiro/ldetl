module LDETL
  module Extractor
    class All < Base
      def initialize( etl )
        super( etl )
      end

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
        super

        @etl.db.connection[ALL_RDF_TYPES].each do |type|
          all_subjects = []

          predicates = distinct_predicates( [[ :subject, all_subjects ]] )
          attributes = build_attributes( predicates )

          table_name = h_table_name( type[:id] )
          option = { :pk => { :enable => true, :target_column => :subject } }
          @etl.db.create_table( table_name, attributes, option )
          save_table_info( table_name, attributes )
        end
      end

      def duplicate
      end

      #=======================================================================
      private
      #=======================================================================

      def initialize_tables
        create_all_triples_table
        create_all_rdf_types_table
      end

    end
  end
end
