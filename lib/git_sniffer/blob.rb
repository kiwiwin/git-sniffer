require_relative 'lazy'
require_relative 'object'

module GitSniffer
	class Blob < GitSniffer::Object
		include Lazy

		lazy_reader :name		

		def initialize(base, sha)
			super(base, sha)
		end

		def lazy_name_source
			@base.exec("rev-list --all --objects") =~ /#{@sha} (.*)\n/
			$1
		end
	end
end
