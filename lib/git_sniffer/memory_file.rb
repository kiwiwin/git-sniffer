module GitSniffer
	class MemoryFile
		def initialize(content)
			@@id += 1
			file = File.new(path, "w+");
			file.puts(content)
			file.close
		end

		def path
			BASE_PATH + @@id.to_s
		end

		def delete
			File.delete(path)
		end

		private

		BASE_PATH = "/dev/shm/git_sniffer_tmp_"
		@@id = 0
	end
end