require_relative 'object'

module GitSniffer
	class Blob < GitSniffer::Object
		lazy_reader :name		

		def initialize(base, sha)
			super(base, sha)
			@type = "blob"
		end

		def lazy_name_source
			@base.exec("rev-list --all --objects") =~ /#{@sha} (.*)\n/
			$1
		end
	end
end
