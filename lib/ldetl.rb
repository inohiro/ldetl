require 'rdf'
require 'rdf/rdfxml'
require 'rdf/n3'
require 'rdf/raptor'
require 'rest-client'
require 'equivalent-xml'
require 'sequel'

require 'ldetl/db'
require 'ldetl/etl'
require 'ldetl/extractor/base'
require 'ldetl/extractor/separate'
require 'ldetl/extractor/all'
require 'ldetl/extractor/divided_all'

module LDETL
  DEFAULT_SCHEMA = 'ldetl'
  DEFAULT_USER = 'root'
  DEFAULT_PASSWORD = ''
  DEFAULT_HOST = 'localhost'
  DEFAULT_DB_TYPE = 'mysql'
  DEFAULT_ENCODING = 'utf8'

  ALL_TRIPLES = 'all_triples'
  SPECIAL_DOMAIN = [ 'geonames' ]

end
