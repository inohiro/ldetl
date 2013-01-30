
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

schema = etl.generate_schema( measure_candidates.first )

