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
        create_horizontal_info

        @etl.db.connection[ALL_RDF_TYPES].each do |type|
          all_subjects = []
          
        end

      end

      def duplicate
      end

      #=======================================================================
      private
      #=======================================================================

      def build_attributes( query_result )
        attributes = []
        query_results.each do |result|
          predicate = r[:predicate].to_s
          value_type = r[:value_type].to_s
          value_id = r[:value_type_id].to_i

          attribute = { } # { :type => datatype, :name => hoge.to_sym }
          data_type = String
          column_name = ''
          is_resource = false

          column_name = Util.get_column_name( predicate ) # estimate column name from predicate

          if value_id == 2 # Literal

            data_type = Util.detect_data_type( value_type )

            #      elsif value_id == 3 # GeoNames
            #        column_name = 'geonames'
            #        data_type = String

          elsif value_id == 1 # Resource
            is_resource = true
          end

          attributes << { :type => data_type,
            :name => column_name,
            :is_resource => is_resource }
        end
        attributes
      end

      def initialize_tables
        create_all_triples_table
        create_all_rdf_types_table
      end

    end
  end
end
