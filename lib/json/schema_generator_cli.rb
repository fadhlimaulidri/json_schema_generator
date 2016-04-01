#!/usr/bin/env ruby

require 'optparse'

class JSON::SchemaGeneratorCLI
  def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
    @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
  end

  def execute!
    default_version = 'draft4'
    supported_versions = ['draft4']

    options = {
      :schema_version => default_version,
      :defaults => false
    }



    OptionParser.new do |opts|
      opts.on("--defaults", "Record default values in the generated schema") { options[:defaults] = true }
      opts.on("--schema-version draft4", [:draft4],
        "Version of json-schema to generate (#{supported_versions.join ', '}).  Default: #{default_version}") do |schema_version|
          options[:schema_version] = schema_version
        end
      opts.parse!
    end

    file = ARGV.shift
    schema = JSON.parse(JSON::SchemaGenerator.generate file, File.read(file), options)
    @stdout.puts JSON.pretty_generate schema
    @kernel.exit(0)
  end
end
