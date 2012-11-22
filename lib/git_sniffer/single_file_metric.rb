require_relative 'memory_file'
require_relative 'third_party_helper'

module GitSniffer
	class SingleFileMetric

		def self.max(content, rule, parser)
			run_command(content, rule).scan(parser).inject(0) do |max, variable|
				[max, variable[0].to_i].max
			end
		end

		private

		def self.run_command(content, rule)
			MemoryFile.create(content) { |path| ThirdPartyHelper.run_checkstyle(rule, path) }
		end
	end
end