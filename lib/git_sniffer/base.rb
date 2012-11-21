module GitSniffer
	class Base
		attr_reader :path
		
		def initialize(git_path)
			@path = git_path
		end

		def commits
			shas = exec("rev-list --all")
			shas.split("\n").collect { |sha| Commit.new(self, sha) }
		end

		def exec(command)
			`git --git-dir=#{@path} #{command}`
		end

		class << self
			def open(git_path)
				Base.new(git_path)
			end
		end
	end
end
