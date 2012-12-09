require_relative 'object'

module GitSniffer
	class Tag < GitSniffer::Object
		def initialize(base, sha)
			super(base, sha)
			@type = "tag"
		end
	end
end
