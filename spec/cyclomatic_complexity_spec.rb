require_relative 'spec_helper'

describe GitSniffer::CyclomaticComplexity do

	it "its cyclomatic complexity should be 0" do
		GitSniffer::CyclomaticComplexity.max("").should == 0
	end

	it "its max cyclomatic complexity should be 2" do
		GitSniffer::CyclomaticComplexity
		.max("class Test{public int func(){if(true){true;}}}").should == 2
	end

	it "its max cyclomatic complexity should be 3" do
		GitSniffer::CyclomaticComplexity
		.max("class Test{public int func(){if(true){true;}} \
			int func(){if(true){true;if(true){true;}}}}").should == 3
	end
	
end