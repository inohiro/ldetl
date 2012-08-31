module LDETL
  module Extractor
    class Devided_All < Base
      def vertical_extract
        @triple_counter = 0
        @table_number = 0
        @table_name_base = 'devided_vertical_'
        @current_table = table_name_base + table_number.to_s

        initialize_tables( @current_table )
        rdf_reader = create_reader
        Dir.glob( iteration_path ) do |f|
          path = "file:#{f.to_s}"

          reader = rdf_reader.open( path )
          reader.each do |stm|
            @etl.db.add_rdf_type( stm.object ) if stm.predicate == RDF::type

            type_info = detect_type( stm )

            replace_current_table if @triple_counter >= TRIPLE_COUNTER_MAX
            @etl.db.insert_triple( @current_table, stm, type_info )
            @triple_counter += 1
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

      def replace_current_table
        @triple_counter = 0
        @table_number += 1
        @current_table = table_name_base + table_number.to_s
        create_vertical_table( @current_table )
        @etl.db.insert( VERTICAL_TABLE_LIST, :vertical_table_name => @current_table )
      end

      def initialize_tables( vertical_table_name )
        create_vertical_table( vertical_table_name )

        all_rdf_types_attrs = [ { :name => 'uri', :type => String } ]
        @etl.db.create_table_with_pk( ALL_RDF_TYPES, all_rdf_types_attrs, 'id' )

        vertical_table_list_attrs = [ { :name => 'vertical_table_name', :type => String } ]
        @etl.db.create_table_with_pk( VERTICAL_TABLE_LIST, vertical_table_list_arrts, 'id' )
      end

      def create_vertical_table( table_name )
        all_triples_attrs = [ { :name => 'subject', :type => String},
                              { :name => 'predicate', :type => String },
                              { :name => 'object', :type => String},
                              { :nema => 'value_type', :type => String },
                              { :name => 'value_type_id', :type => Integer } ]
        @etl.db.create_table( table_name, all_triples_attrs )
      end
    end
  end
end
