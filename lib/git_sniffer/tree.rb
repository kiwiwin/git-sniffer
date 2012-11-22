module GitSniffer
	class Tree
		attr_reader :sha

		def initialize(base, sha)
			@base = base
			@sha = sha
		end
	end
end
