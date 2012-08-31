module LDETL
  module Extractor
    class Base
      def initialize( etl )
        @etl = etl
      end

      def etl_params
      end

      def detect_type( stm )
        if stm.object.class == RDF::Literal
          when_literal( stm )
        elsif stm.object.class == RDF::URI
          when_resource( stm )
        end
      end

      def create_reader
        case @etl.rdf_type
        when :ntriples || 'ntriples'
          RDF::NTriples::Reader
        when :n3 || 'n3'
          RDF::N3::Reader
        when :xml || 'xml'
          RDF::Raptor.available? ? RDF::Reader : RDF::RDFXML::Reader
        when :turtle || 'turtle'
          RDF::Reader
        end
      end

      def iteration_path
        rdf_path = @etl.rdf_path
        if rdf_path[rdf_path.length-1] != '/'
          rdf_path << '/'
        end

        case @etl.rdf_type
        when :ntriples || 'ntriples'
          rdf_path + '*.nt'
        when :n3 || 'n3'
          rdf_path + '*.n3'
        when :xml || 'xml'
          rdf_path + '*.xml'
        when :turtle || 'turtle'
          rdf_path + '*.ttl'
        end
      end

      def create_all_triples_table( table_name = ALL_TRIPLES )
        all_triples_attrs = [ { :name => 'subject', :type => String},
                              { :name => 'predicate', :type => String },
                              { :name => 'object', :type => String},
                              { :nema => 'value_type', :type => String },
                              { :name => 'value_type_id', :type => Integer } ]
        @etl.db.create_table( table_name, all_triples_attrs )
      end

      def create_all_rdf_types_table
        all_rdf_types_attrs = [ { :name => 'uri', :type => String } ]
        @etl.db.create_table_with_pk( ALL_RDF_TYPES, all_rdf_types_attrs, 'id' )
      end

      #=======================================================================
      private
      #=======================================================================

      def when_literal( stm )
        type_id = 2

        if stm.object.has_datatype?
          data_type = stm.object.class.to_s
        else
          object_alt = nil
          match = value_divider( stm.object.to_s )
          if match.empty?
            data_type = 'RDF::Literal::String'
          else
            object_alt = match[0]
            data_type = match[1]
          end
        end
        { :type_id => type_id, :data_type => data_type, :object_alt => object_alt }
      end

      def when_resource( stm )
        type_id = 1
        data_type = nil

        forward_domain = URI.parse( stm.object.to_s ).host
        index = SPECIAL_DOMAIN.index forward_domain
        if index != nil
          type_id = index
          data_type = SPECIAL_DOMAIN[index]
        end

        { :type_id => type_id, :data_type => data_type, :object_alt => nil }
      end

      def value_divider( object )
        m = /\^\^/.match( object ) ? [ m.pre_match, m.post_match ] : []
      end

    end
  end
end
