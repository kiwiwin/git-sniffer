require_relative 'blob'
require_relative 'git_object'
require_relative 'lazy'

module GitSniffer
	class Commit < GitObject
		include Lazy
		lazy_reader :message

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

		def lazy_message_source
			@base.exec("cat-file -p #{@sha}").split("\n")[-1]
		end
	end
end
