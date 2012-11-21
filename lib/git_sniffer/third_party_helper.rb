module GitSniffer
	class ThirdPartyHelper
		def self.run_checkstyle(rule, file)
			`java -jar third_party_tools/checkstyle-5.6/checkstyle-5.6-all.jar \
			 -c third_party_tools/checkstyle-5.6/rules/#{rule} #{file}`
		end
	end
end
