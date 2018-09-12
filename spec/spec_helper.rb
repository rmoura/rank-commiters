require 'rspec'
require 'tempfile'
require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir     = File.join(File.dirname(__FILE__), 'support')
  c.default_cassette_options = { record: :once }
end
