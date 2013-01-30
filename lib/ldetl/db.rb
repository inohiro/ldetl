module LDETL
  #
  #== DB Class
  #
  #
  #
  class DB

    attr_reader :connection

    def initialize( schema_name, options = nil )
      @schema = schema_name || DEFAULT_SCHEMA
      @user = options[:user] || DEFAULT_USER
      @password = options[:password] || DEFAULT_PASSWORD
      @host = options[:host] || DEFAULT_HOST
      @db_type = options[:db_type] || DEFAULT_DB_TYPE
      @encoding = options[:encoding] || DEFAULT_ENCODING

      @connection = Sequel.connect( "#{@db_type}://#{@user}:#{@password}@#{@host}/#{@schema}", { :encoding => @encoding } )
    end

    def uri_tablenames
      @connection[:uri_tablename].all
    end

    def distinct_predicate( table_name )
      table_name = table_name.to_sym
      @connection[table_name].select( :predicate, :value_type, :value_type_id ).distinct
    end

    def all_subjects( table_name = ALL_TRIPLES )
      all_subjects = []
      @connection[table_name].select( :subject )
                             .filter( :predicate => RDF::type.to_s )
                             .filter( :object => tdf_type[:uri].to_s )
                             .each { |e| all_subjects << e[:subject] }
      all_subjects
    end

    def insert_attibute( table_name, attribute )
    end

    def insert_attributes( table_name, attributes )
    end

    def insert_triple( table_name, stm, type_info )
      table_name = table_name.to_sym
      begin
        @connection[table_name].insert( :subject => stm.subject.to_s,
                                        :predicate => stm.predicate.to_s,
                                        :object => type_info[:object_alt].to_s || stm.object.to_s,
                                        :value_type => type_info[:data_type].to_s,
                                        :value_type_id => type_info[:type_id].to_i )
      rescue => exp
        puts exp.message
        puts exp.backtrace
      end
    end

    def exist?( table_name, column, target )
      table_name = table_name.to_sym
      column_name = column_name.to_sym

      result = @connection[table_name].filter( column => target )
      result.count >= 1 ? result : nil
    end

    def insert( table_name, argument )
      table_name = table_name.to_sym if table_name.class != Symbol
      @connection[table_name].insert( argument )
    end

    def create_table( table_name,
                      attributes,
                      option = {
                        :pk => :subject,
                        :index => :id_resource,
                        :index_subject => false
                      } )
=begin
                        :pk => {
                          :enable => false,
                          :target_column => :subject},
                        :index => {
                          :enable => false,
                          :index_subject => false,
                          :target_column => :id_resource } } )
=end

      table_name = table_name.to_sym
      option[:pk][:enable] ? pk = option[:pk][:target_column] : pk = nil
      index_column = []
      index_column << :subject if option[:index][:index_subject]

      begin
        @connection.create_table!( table_name, { :engine => 'innodb' } ) do
          primary_key pk if pk
          attributes.each do |attr|
            column( attr[:name], attr[:type] )
            index_column << attr[option[:index][:target_column]] if option[:index][:enable]
          end
        end
      rescue => exp
        puts exp.message
        puts exp.backtrace
      end

      add_index( table_name, index_columns ) if option[:index][:enable]
    end

    def add_index( table_name, column_name )
      table_name = table_name.to_sym
      begin
        @connection.alter_table table_name do
          if column_name.class == String || column_name.class == Symbol
            add_index column_name.to_sym
          elsif column_name.class == Array
            column_name.each { |column| add_index column.to_sym }
          end
        end
      rescue => exp
        puts exp.message
        puts exp.backtrace
      end
    end

    def add_rdf_type( rdf_type, table_name = ALL_RDF_TYPES )
      table_name = table_name.to_sym
      rdf_type = rdf_type.to_s
#      result = @connection[ALL_RDF_TYPES].filter( :uri => rdf_type )
#      @connection[ALL_RDf_TYPE].insert( :uri => rdf_type ) if result.count < 1

      unless self.exist?( table_name, 'uri', 'rdf_type' ) # check
        @connection[table_name].insert( :uri => rdf_type )
      end
    end

    def last_element( table_name, column_name = 'id' )
      table_name = table_name.to_sym
      column_name = column_name.to_sym

      @connection[table_name].order( column_name ).last[column_name.to_sym]
    end

  end
end
