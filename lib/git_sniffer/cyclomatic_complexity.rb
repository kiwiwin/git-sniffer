module GitSniffer

	class CyclomaticComplexity

		def self.max(content)
			run_command(content).scan(/Complexity is (\d*)/).inject(0) do |max, variable|
				max = variable[0].to_i if variable[0].to_i > max
			end
		end

		private

		CHECKSTYLE_PATH = "third_party_tools/checkstyle-5.6/checkstyle-5.6-all.jar"
		RULE_PATH = "third_party_tools/checkstyle-5.6/rules/cyclomatic_complexity.xml"
		CHECK_COMMAND = "java -jar #{CHECKSTYLE_PATH} -c #{RULE_PATH} "

		def self.run_command(content)
			`echo "#{content}" > tmp_cyclomatic_complexity`
			result = `#{CHECK_COMMAND} tmp_cyclomatic_complexity`
			`rm tmp_cyclomatic_complexity`
			result
		end
	end
end