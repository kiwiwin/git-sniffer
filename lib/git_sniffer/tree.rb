require_relative 'git_object'

module GitSniffer
	class Tree < GitObject
		def initialize(base, sha)
			super(base, sha)
		end
	end
end
