require_relative '../git_sniffer'

module GitSniffer
	class ThirdPartyHelper
		def self.run_checkstyle(rule, file)
			`java -jar #{GitSniffer::HOME_DIR}/third_party_tools/checkstyle-5.6/checkstyle-5.6-all.jar \
			 -c #{GitSniffer::HOME_DIR}/third_party_tools/checkstyle-5.6/rules/#{rule}.xml #{file}`
		end
	end
end
