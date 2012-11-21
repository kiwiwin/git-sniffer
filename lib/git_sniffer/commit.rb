require_relative 'blob'

module GitSniffer
	class Commit
		attr_reader :sha
		
		def initialize(base, sha)
			@base = base
			@sha = sha
		end

		def blobs
			lines = @base.exec("ls-tree -r #{@sha}")
			lines.split("\n").collect do |line|
				matches = line.match(/(\d+) (\w+) ([a-zA-Z\d]+)\t(.+)/)
				Blob.new(@base, matches[3])
			end
		end

		def message
			@base.exec("cat-file -p #{@sha}").split("\n")[-1]
		end
	end
end
