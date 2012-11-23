require_relative 'spec_helper'

describe GitSniffer::SingleFileMetric do

	context(:single_file) do
		before(:all) do
			@content = File.open("#{File.dirname(__FILE__)}/fixture/single_file.java").read
		end

		it "its max cyclomatic complexity should be 4" do
			GitSniffer::SingleFileMetric.max_cc(@content).should == 4
		end

		it "its max method length should be 12" do
			GitSniffer::SingleFileMetric.max_method_length(@content).should == 12
		end

		it "its max parameter number should be 2" do
			GitSniffer::SingleFileMetric.max_parameter_number(@content).should == 2
		end
	end
end