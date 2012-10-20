module LDETL
  module Extractor
    class Separated < Base
      def vertical_extract
        tmp_subject = ''
        current_table = ''

        initialize_tables
        rdf_reader = create_reader

        Dir.glob( iteration_path ) do |f|
          path = "#{f.to_s}"

          reader = rdf_reader.open( path )
          reader.each do |stm|
            if tmp_subject != stm.subject.to_s
              tmp_subject = stm.subject.to_s
              current_table = get_or_create_table( stm )
            end
          end

          type_info = detect_type( stm )
          @etl.db.insert_triple( current_table, stm, type_info )
        end
      end

      def horizontal_extract
      end

      def duplicate
      end

      #=======================================================================
      private
      #=======================================================================

      def get_or_create_table( stm )
        table = ''

        if stm.predicate == RDF::type
          table_name = stm.object.to_s.gsub( /\s+/, '' )

          # create table if it's not exist
          result = @etl.db.exist?( ALL_RDF_TYPES, 'uri', table_name )
          if result
            table = table_name( result[:id] )
          else
            @etl.db.add_rdf_type( table_name )
            table_id = @etl.db.last_element( ALL_RDF_TYPES, 'id' )
            table = table_name( table_id )
            create_all_triples_table( table )
          end
        end
        table
      end

      def table_name( id )
        "t_#{id.to_s}".to_sym
      end

      def initialize_tables
        create_all_triples_table
        create_all_rdf_types_table
      end
    end
  end
end
