module LDETL
  module Extractor
    class Separated < Base

      def initialize( etl )
        super( etl )
#        initialize_tables
      end

      def vertical_extract
        tmp_subject = ''
        current_table = ''

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
        super

        table_list.each do |table|
          predicates = distinct_predicates( table[:vertical] )
          attributes = build_attributes( predicates )
          table_name = table[:hotizontal]

          option = { :pk => { :enable => true, :target_column => :subject } }
          @etl.db.create_table( table_name, attributes, option )
          save_table_info( table_name, attributes )
        end
      end

      def duplicate
        table_list.each do |table|
          subjects = @etl.db.all_subjects( table[:vertical] )
          subjects.each do |e|
            subject = e[:subject]
            records = @etl.db.connection[table[:vertical]].filter( :subject => subject )
            tuple = build_tuple( records, subject )
            @etl.db.insert( table[:horizontal], tuple ) # weak performance
          end
        end
      end

      #=======================================================================
      private
      #=======================================================================

      def build_tuple( records, subject )
        tuple = Hash.new
        tuple.store( 'subject', subject )

        recordes.each do |r|
          column_name = ''
          data_type = 'string'
          real_value = nil

          predicate = r[:predicate]
          object = r[:object]
          value_type = r[:value_type]
          value_id = r[:value_type_id].to_i

          real_value = detect_and_cast_type( value_type, object )
          column_name = estimate_column_name( predicate )
          column_name = 'geonames' if value_id == 3

          tuple.store( column_name, real_value )
        end
        tuple
      end

      def estimate_column_name( predicate )
        m = /\#/.match( predicate )
        if m != nil
          m.post_match
        else
          n = predicate.reverse.match( /\// )
          if n != nil
            n.pre_match.reverse
          else
            l = predicate.match( /http:\/\// )
            l != nil ? l.post_match : Time.now.strftime( "unknown_%N" )
          end
        end
      end

      def distinct_predicates( table_name )
        table_name = table_name.to_sym
        @db.connection[table_name].select( :predicate, :value_type, :value_type_id ).distinct
      end

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

      def table_list
        result = []
        table_list = @etl.db.uri_tablenames
        table_list.each do |table|
          result << { :vertical   => v_table_name( table[:id] ),
                      :horizontal => h_table_name( table[:id] ) }
        end
        result
      end

      def initialize_tables
        create_uri_tablename
      end

      def create_uri_tablename
        attributes = [ { :name => 'uri', :type => String } ]
        @etl.db.create_table( URI_TABLENAME, attributes, { :pk => :id } )
      end
    end
  end
end
