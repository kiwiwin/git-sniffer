require_relative 'memory_file'
require_relative 'third_party_helper'
require_relative 'metric_parsers'

module GitSniffer
	class SingleFileMetric
		private
		def self.method_missing(method, *args, &block) 
			if method =~ /^([a-z]+)_(\w+)$/
				define_singleton_method(method) { |content| send($1, content, $2) }
				return send(method, *args)
			end	
			super
		end

		def self.max(content, metric)
			detail(content, metric).values.max
		end

		def self.detail(content, metric)
			result = Hash.new
			run_command(content, metric).scan(MetricParsers.get(metric)) do |line_number, metric|
				result[line_number.to_i] = metric.to_i
			end
			result
		end

		def self.run_command(content, metric)
			MemoryFile.involve(content) { |path| ThirdPartyHelper.run_checkstyle(metric, path) }
		end
	end
end