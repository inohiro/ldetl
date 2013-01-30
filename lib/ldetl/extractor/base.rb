module LDETL
  module Extractor
    class Base
      def initialize( etl )
        @etl = etl
      end

      def horizontal_extract
        create_horizontal_info_table
      end

      def etl_params
      end

      def detect_type( stm )
        if stm.object.class == RDF::Literal
          detect_literal_type( stm )
        elsif stm.object.class == RDF::URI
          detect_resource_type( stm )
        end
      end

      def create_reader
        case @etl.rdf_type
        when :ntriples || 'ntriples'
          RDF::NTriples::Reader
        when :n3 || 'n3'
          RDF::N3::Reader # RDF::N3::Reader.new( File.read( f.to_s ) )
        when :xml || 'xml'
          RDF::Raptor.available? ? RDF::Reader : RDF::RDFXML::Reader # RDF::RDFXML::Reader.open( path )
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
        @etl.db.create_table( ALL_RDF_TYPES, all_rdf_types_attrs, 'id' )
      end

      def create_horizontal_info_table
        attributes = [ { :name => 'table_name', :type => String },
                       { :name => 'attribute_name', :type => String },
                       { :name => 'data_type', :type => String },
                       { :name => 'is_resource', :type => Boolean } ]
        @etl.db.create_table( :horizontal_info, attributes, 'id' )
      end

      def distinct_predicates( table_name = ALL_TRIPLES, filters = [] )
        result = @etl.db.connection[table_name].select( :predicate, :value_type, :value_type_id )
        result.filter( filters )
        result.distinct
      end

      def build_attributes( predicates )
        attributes = []
        predicates.each do |predicate|
          name = r[:predicate].to_s
          value_type = r[:value_type].to_s
          value_id = r[:value_type_id].to_i

          attribute = { } # { :type => datatype, :name => hoge.to_sym }
          data_type = String
          column_name = ''
          is_resource = false

          column_name = Util.get_column_name( name ) # estimate column name from predicate

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

      def v_table_name( id )
        "t_#{id.to_s}".to_sym
      end

      def h_table_name( id )
        "t_#{id.to_s}_h".to_sym
      end

      def type_detection( type, object )
        if m = /\#/.match( value_type )
          if m.post_match =~ /float/
            object.to_f
          elsif m.post_match =~ /boolean/
            object == 'true' ? true : false
          elsif m.post_match =~ /integer/
#            real_value =~ /integer/
            object.to_i
          else
            object
          end
        else
          object
        end
      end

      #=======================================================================
      private
      #=======================================================================

      def detect_literal_type( stm )
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

      def detect_resource_type( stm )
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
