require_relative 'spec_helper'

describe GitSniffer::Object do
	it "should be equal for same sha Blob" do
		GitSniffer::Blob.new(nil, "abc").eql?(GitSniffer::Blob.new(nil, "abc")).should == true
	end

	it "should not be equal for different sha Blob" do
		GitSniffer::Blob.new(nil, "abc").eql?(GitSniffer::Blob.new(nil, "cba")).should == false
	end

	it "can be correct hashed" do
		hash = Hash.new
		hash[GitSniffer::Blob.new(nil, "abc")] = "object_value"
		hash[GitSniffer::Blob.new(nil, "abc")].should == "object_value"
	end

	it "return nil for not hased" do
		hash = Hash.new
		hash[GitSniffer::Blob.new(nil, "abc")] = "object_value"
		hash[GitSniffer::Blob.new(nil, "cba")].should == nil
	end

	it "return false for different subclass object" do
		GitSniffer::Blob.new(nil, "abc").eql?(GitSniffer::Tree.new(nil, "abc")).should == false
	end
end
