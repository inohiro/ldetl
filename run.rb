
require 'ldetl'

schema_name = 'bill'
rdf_file = './spec/data/'
load_type = 'separated'

etl = LDETL::ETL.new( schema_name, rdf_file, load_type )
etl.run

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

