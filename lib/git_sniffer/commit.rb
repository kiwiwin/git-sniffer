require_relative 'blob'
require_relative 'git_object'

module GitSniffer
	class Commit < GitObject
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

		def message
			@base.exec("cat-file -p #{@sha}").split("\n")[-1]
		end
	end
end
