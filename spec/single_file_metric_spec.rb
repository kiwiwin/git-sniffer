require_relative 'spec_helper'

describe GitSniffer::SingleFileMetric do

	context(:single_file) do
		before(:all) do
			@content = File.open("#{File.dirname(__FILE__)}/fixture/single_file.java").read
		end

		it "its max cyclomatic complexity should be 4" do
			parser = /Cyclomatic Complexity is (\d*)/
			GitSniffer::SingleFileMetric.max(@content, :cc, parser).should == 4
		end

		it "its max method length should be 4" do
			parser = /Method length is (\d*)/
			GitSniffer::SingleFileMetric.max(@content, :method_length, parser).should == 12
		end

	end
end