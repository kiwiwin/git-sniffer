module GitSniffer
	class MetricParsers

		def self.get(metric)
			@@parsers[metric]
		end

		private
		@@parsers = 
		{
			"cc" => /Cyclomatic Complexity is (\d+)/,
			"method_length" => /Method length is (\d+)/, 
			"parameter_number" => /More than 0 parameters \(found (\d+)\)/
		}
	end
end