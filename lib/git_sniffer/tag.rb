require_relative 'object'

module GitSniffer
	class Tag < GitSniffer::Object
		def initialize(base, sha)
			super(base, sha)
		end
	end
end
