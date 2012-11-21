module GitSniffer
	class Blob
		attr_reader :git_path
		attr_reader :sha
		attr_reader :name		

		def initialize(base, sha, name)
			@base = base
			@sha = sha
			@name = name
		end

		def content
			@base.exec("cat-file -p #{@sha}")
		end
	end
end
