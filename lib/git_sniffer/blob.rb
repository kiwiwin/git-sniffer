module GitSniffer
	class Blob
		attr_reader :git_path
		attr_reader :sha
		attr_reader :name		

		def initialize(git_path, sha, name)
			@git_path = git_path
			@sha = sha
			@name = name
		end

		def content
			`git --git-dir=#{@git_path} cat-file -p #{@sha}`
		end
	end
end
