require_relative 'spec_helper'

describe GitSniffer::SingleFileMetric do

	context(:cyclomatic_complexity) do

		before(:all) do
			@parser = /Complexity is (\d*)/
		end

		it "its cyclomatic complexity should be 0" do
			GitSniffer::SingleFileMetric.max("", :cc, @parser).should == 0
		end

		it "its max cyclomatic complexity should be 2" do
			GitSniffer::SingleFileMetric
			.max("class Test{public int func(){if(true){true;}}}",
				:cc, @parser).should == 2
		end

		it "its max cyclomatic complexity should be 3" do
			GitSniffer::SingleFileMetric
			.max("class Test{public int func(){if(true){true;}} \
				int func(){if(true){true;if(true){true;}}}}",
				:cc, @parser).should == 3
		end
	end
end