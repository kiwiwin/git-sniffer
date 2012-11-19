module GitSniffer
	class Base
		attr_reader :path
		
		def initialize(git_path)
			@path = git_path
		end

		def commits
			shas = `git --git-dir=#{@path} rev-list --all`
			shas.split('\n').collect do |sha|
				Commit.new(@path, sha.chomp)
			end
		end

		class << self
			def open(git_path)
				Base.new(git_path)
			end
		end
	end
end
