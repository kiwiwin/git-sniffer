module GitSniffer
	class MetricParsers

		def self.get(metric)
			@@parsers[metric]
		end

		private
		@@parsers = 
		{
			"cc" => /:(\d+):\d+: Cyclomatic Complexity is (\d+)/,
			"method_length" => /:(\d+):\d+: Method length is (\d+)/, 
			"parameter_number" => /:(\d+):\d+: More than -1 parameters \(found (\d+)\)/
		}
	end
end