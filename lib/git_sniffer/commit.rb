require 'date'
require_relative 'object'
require_relative 'blob'

module GitSniffer
	class Commit < GitSniffer::Object
		lazy_reader :message
		lazy_reader :commit_date

		def initialize(base, sha)
			super(base, sha)
		end

		def blobs
			lines = @base.exec("ls-tree -r #{@sha}")
			lines.split("\n").collect do |line|
				matches = line.match(/(\d+) (\w+) ([a-zA-Z\d]+)\t(.+)/)
				@base.object(matches[3])
			end
		end

		private
		def lazy_message_source
			content.split("\n")[-1]
		end

		def lazy_commit_date_source
			content =~ /committer.+> (\d+) [+-]\d{4}/
			Time.at($1.to_i).to_datetime
		end
	end
end
