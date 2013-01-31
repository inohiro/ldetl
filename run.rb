$:.unshift File.join( File.dirname( __FILE__ ), './lib' )
require 'ldetl'

schema_name = 'ldetl_test'
rdf_file = File.expand_path( './data/' )
rdf_type = :n3
load_type = :deparated

db = LDETL::DB.new( schema_name )

etl = LDETL::ETL.new( rdf_file, rdf_type, load_type, db )
etl.extract

measure_candidates = etl.measure_candidates
measure_candidates.each do |candidate|
  pp candidate
end

dimension_candidates = etl.induce_dimensions( etl.measure_candidates.first )
dimension.candidates.each do |candidate|
  pp candidate
end

schema = Schema.new
schema.fact = etl.measure_candidates.first
schema.dimensions = dimension.candidates

xml = schema.to_xml

