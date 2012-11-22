module GitSniffer
	class CyclomaticComplexity
		def self.max(content)
			run_command(content).scan(/Complexity is (\d*)/).inject(0) do |max, variable|
				[max, variable[0].to_i].max
			end
		end

		private

		def self.run_command(content)
			MemoryFile.create(content) { |path| ThirdPartyHelper.run_checkstyle("cc.xml", path) }
		end
	end
end