require_relative 'memory_file'
require_relative 'third_party_helper'
require_relative 'metric_parsers'

module GitSniffer
	class SingleFileMetric
		private
		def self.method_missing(method, *args, &block) 
			if method =~ /^max_(\w+)$/
				define_singleton_method(method) { |content| max(content, $1) }
				return send(method, *args)
			end	
			super
		end

		def self.max(content, metric)
			run_command(content, metric).scan(MetricParsers.get(metric)).inject(0) do |max, str|
				[max, str[0].to_i].max
			end
		end

		def self.run_command(content, metric)
			MemoryFile.involve(content) { |path| ThirdPartyHelper.run_checkstyle(metric, path) }
		end
	end
end