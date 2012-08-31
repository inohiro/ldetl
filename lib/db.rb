module LDETL

  #
  #== DB Class
  #
  #
  #
  class DB

    attr_reader :connection

    def initialize( schema_name, user_name, password, options = nil )
      @schema = schema_name || DEFAULT_SCHEMA
      @user = user_name || DEFAULT_USER
      @password = password || DEFAULT_PASSWORD
      @host = options[:host] || DEFAULT_HOST
      @db_type = options[:db_type] || DEFAULT_DB_TYPE
      @encoding = options[:encoding] || DEFAULT_ENCODING

      @connection = Sequel.connect( "#{@db_type}://#{@user}:#{@password}@#{@host}/#{@schema}", { :encoding => @encoding } )
    end

    def insert_attibute( table_name, attribute )
    end

    def insert_attributes( table_name, attributes )
    end

    def insert_triple( table_name, triple )
      table_name = table_name.to_sym
      begin
        @connection[table_name].insert( :subject => triple[:subject].to_s,
                                        :predicate => triple[:subject].to_s,
                                        :object => triple[:object].to_s,
                                        :value_type => triple[:value_type].to_s,
                                        :value_type_id => triple[:value_type_id].to_s )
      rescue => exp
        puts exp.message
        puts exp.backtrace
      end
    end

=begin
    def insert( table_name, attributes )
      table_name = table_name.to_sym if table_name.class != Symbol
      @connection[table_name].insert( )
    end
=end

    def create_table( table_name, attributes )
      table_name = table_name.to_sym

      begin
        @connection.create_table!( table_name, { :engine => 'innodb' } ) do
          attributes.each do |attr|
            column( attr[:name], attr[:type] )
          end
        end
      rescue => exp
        puts exp.message
        puts exp.backtrace
      end
    end

    def create_table_with_index( table_name, attributes )
      table_name = table_name.to_sym
      index_columns = []

      begin
        @connection.create_table!( table_name, { :engine => 'innodb' } ) do
          attributes.each do |attr|
            column( attr[:name], attr[:type] )
            if attr[:is_resource] == true
              index_columns << attr[:name]
            end
          end
        end
      rescue => exp
        puts exp.message
        puts exp.backtrace
      end

      add_index( table_name, inde_columns )
    end

    def add_index( table_name, column_name )
      table_name = table_name.to_sym
      begin
        @connection.alter_table table_name do
          if column_name.class == String || column_name.class == Symbol
            add_index column_name.to_sym
          elsif column_name.class == Array
            column_name.each do |column|
              add_index column.to_sym
            end
          end
        end
      rescue => exp
        puts exp.message
        puts exp.backtrace
      end
    end
  end
end
