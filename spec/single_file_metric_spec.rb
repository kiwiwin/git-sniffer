require_relative 'spec_helper'

describe GitSniffer::SingleFileMetric do

	context(:single_file) do
		before(:all) do
			@base = GitSniffer::Base.open(fixture_path(:single_file))
		end

		it "its max cyclomatic complexity should be 4" do
			GitSniffer::Blob.add_hook(:max_cc) do |blob|
				GitSniffer::SingleFileMetric.max_cc(blob)
			end
			GitSniffer::Blob.add_hook(:detail_cc) do |blob|
				GitSniffer::SingleFileMetric.detail_cc(blob)
			end

			@base.object("6430ff7fb2944a0f0569fd1d416aaae3c09eafe0").hook_max_cc.should == 4
			@base.object("6430ff7fb2944a0f0569fd1d416aaae3c09eafe0").hook_detail_cc[79].should == 4
		end

		it "its max method length should be 12" do
			GitSniffer::Blob.add_hook(:max_method_length) do |blob|
				GitSniffer::SingleFileMetric.max_method_length(blob)
			end
			GitSniffer::Blob.add_hook(:detail_method_length) do |blob|
				GitSniffer::SingleFileMetric.detail_method_length(blob)
			end

			@base.object("6430ff7fb2944a0f0569fd1d416aaae3c09eafe0").hook_max_method_length.should == 12
			@base.object("6430ff7fb2944a0f0569fd1d416aaae3c09eafe0").hook_detail_method_length[79].should == 12
		end

		it "its max parameter number should be 2" do
			GitSniffer::Blob.add_hook(:max_parameter_number) do |blob|
				GitSniffer::SingleFileMetric.max_parameter_number(blob)
			end
			GitSniffer::Blob.add_hook(:detail_parameter_number) do |blob|
				GitSniffer::SingleFileMetric.detail_parameter_number(blob)
			end

			@base.object("6430ff7fb2944a0f0569fd1d416aaae3c09eafe0").hook_max_parameter_number.should == 2
			@base.object("6430ff7fb2944a0f0569fd1d416aaae3c09eafe0").hook_detail_parameter_number[79].should == 2
		end
	end
end