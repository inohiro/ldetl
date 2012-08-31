module LDETL
  module Extractor
    class Separated < Base
      def vertical_extract
        initialize_tables
      end
      
      def horizontal_extract
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
