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
            @etl.db.add_rdf_type( stm.object.to_s ) if stm.predicate == RDF::type

            type_info = detect_type( stm )

            replace_current_table if @triple_counter >= TRIPLE_COUNTER_MAX
            @etl.db.insert_triple( @current_table, stm, type_info )
            @triple_counter += 1
          end
        end
      end

      def horizontal_extract
        super

        vertical_table_list = [] # FIX ME
        vertical_table_list.each do |table|
          table_type = table[:vertical_table_name].to_sym
          all_subjects = @db.db.all_subjects( table[:vertical],
                                              [ :predicate => RDF::type.to_s,
                                                :object => type[:uri].to_s ] )
        end
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
        create_all_triples_table( @current_table )
        @etl.db.insert( VERTICAL_TABLE_LIST, :vertical_table_name => @current_table )
      end

      def initialize_tables
        create_all_triples_table( @current_table )
        @etl.db.insert( VERTICAL_TABLE_LIST, :vertical_table_name =>  @current_table )

        create_all_rdf_types_table

        vertical_table_list_attrs = [ { :name => 'vertical_table_name', :type => String } ]
        @etl.db.create_table_with_pk( VERTICAL_TABLE_LIST, vertical_table_list_arrts, 'id' )
      end
    end
  end
end
