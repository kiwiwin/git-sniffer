require_relative 'blob'

module GitSniffer
	class Commit
		attr_reader :sha
		attr_reader :git_path

		def initialize(base, sha)
			@base = base
			@sha = sha
		end

		def files
			lines = @base.exec("ls-tree -r #{@sha}")
			lines.split("\n").collect do |line|
				matches = line.match(/(\d+) (\w+) ([a-zA-Z\d]+)\t(.+)/)
				Blob.new(@base, matches[3], matches[4])
			end
		end
	end
end
