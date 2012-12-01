module GitSniffer
	class MemoryFile
		def self.involve(content) 
			path = new_path
			File.open(path, "w+") { |file| file.puts(content) };
			result = yield path
			File.delete(path)
			result
		end

		private

		def self.new_path
			@@id += 1
			BASE_PATH + @@id.to_s
		end

		@@id = 0
		BASE_PATH = "/dev/shm/git_sniffer_tmp_"
	end
end