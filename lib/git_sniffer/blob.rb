require_relative 'lazy'

module GitSniffer
	class Blob
		include Lazy

		attr_reader :git_path
		attr_reader :sha
		lazy_reader :name		

		def initialize(base, sha)
			@base = base
			@sha = sha
		end

		def content
			@base.exec("cat-file -p #{@sha}")
		end

		def lazy_name_source
			@base.exec("rev-list --all --objects").split("\n").each do |line|
				return $1 if line =~ /^#{@sha} (.*)/ ;
			end
		end
	end
end
