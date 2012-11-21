require_relative 'blob'

module GitSniffer
	class Commit
		attr_reader :sha
		attr_reader :git_path

		def initialize(git_path, sha)
			@git_path = git_path
			@sha = sha
		end

		def files
			lines = `git --git-dir=#{@git_path} ls-tree -r #{@sha}`
			lines.split("\n").collect do |line|
				matches = line.match(/(\d+) (\w+) ([a-zA-Z\d]+)\t(.+)/)
				Blob.new(@git_path, matches[3], matches[4])
			end
		end
	end
end
