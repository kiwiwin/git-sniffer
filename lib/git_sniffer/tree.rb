require_relative 'object'

module GitSniffer
	class Tree < GitSniffer::Object
		def initialize(base, sha)
			super(base, sha)
			@type = "tree"
		end
	end
end
