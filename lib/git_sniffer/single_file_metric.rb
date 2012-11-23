require_relative 'memory_file'
require_relative 'third_party_helper'

module GitSniffer
	class SingleFileMetric
		private

		def self.method_missing(method_id, *args, &block) 
			if method_id =~ /^max_(\w+)$/
				define_singleton_method(method_id) { |content| max(content, $1) }
				return send(method_id, *args)
			end	
			super
		end

		def self.max(content, rule)
			run_command(content, rule).scan(@@parsers[rule]).inject(0) do |max, variable|
				[max, variable[0].to_i].max
			end
		end

		def self.run_command(content, rule)
			MemoryFile.involve(content) { |path| ThirdPartyHelper.run_checkstyle(rule, path) }
		end

		@@parsers = 
		{
			"cc" => /Cyclomatic Complexity is (\d+)/,
			"method_length" => /Method length is (\d+)/, 
			"parameter_number" => /More than 0 parameters \(found (\d+)\)/
		}
	end
end