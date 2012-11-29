require_relative 'memory_file'
require_relative 'third_party_helper'
require_relative 'metric_parsers'
require_relative 'blob'

module GitSniffer
	class SingleFileMetric
		private
		def self.method_missing(method, *args, &block) 
			if method =~ /^([a-z]+)_(\w+)$/
				define_singleton_method(method) { |blob| send($1, blob, $2) }
				return send(method, *args)
			end	
			super
		end

		def self.max(blob, metric)
			detail(blob, metric).values.max
		end

		def self.detail(blob, metric)
			output = run_command(blob.content, metric)
			if nothing_to_check?(output)
				return { 0 => 0 }
			end
			get_result(output, blob, metric)
		end

		def self.run_command(content, metric)
			MemoryFile.involve(content) { |path| ThirdPartyHelper.run_checkstyle(metric, path) }
		end

		def self.nothing_to_check?(output)
			return output == "Starting audit...\nAudit done.\n"
		end

		def self.get_result(output, blob, metric)
			result = Hash.new
			output.scan(MetricParsers.get(metric)) { |line, metric| result[line.to_i] = metric.to_i }
			result.empty? ? (raise SingleFileCheckError.new(blob.name, output)) : result
		end
	end

	class SingleFileCheckError < RuntimeError
		attr_reader :file_name
		attr_reader :message

		def initialize(file_name, message)
			@file_name = file_name
			@message = message
		end
	end
end