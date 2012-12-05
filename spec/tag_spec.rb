require_relative 'spec_helper'

describe GitSniffer::Tag do
	before(:each) do
		@base = GitSniffer::Base.open(fixture_path(:weiboclient4j))
	end	

	it "should be tag for 58cd951449e3667bb512a7e3af928a0cf465da6a" do
		@base.object("58cd951449e3667bb512a7e3af928a0cf465da6a").type.should == "tag"
	end
end
