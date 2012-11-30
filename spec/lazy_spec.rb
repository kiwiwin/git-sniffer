require_relative 'spec_helper'

class DummyLazy
	include GitSniffer::Lazy

	lazy_reader :hello
	def lazy_hello_source
		"hello"
	end
end

class DummyInitLazy
	include GitSniffer::Lazy

	lazy_reader :hello, :byebye, :init => :calculate

	def calculate
		@hello = "hello"
		@byebye = "byebye"
	end
end

describe DummyLazy do
	before(:each) do
		@lazy = DummyLazy.new
	end

	it "should return hello for hello" do
		@lazy.hello.should == "hello"
	end

	it "should return call lazy_hello_source only once" do
		@lazy.should_receive(:lazy_hello_source).once
		@lazy.hello
		@lazy.hello
	end
end

describe DummyInitLazy do
	before(:each) do
		@lazy = DummyInitLazy.new
	end

	it "should return hello for val1 and byebye for val2" do
		@lazy.hello.should == "hello"
		@lazy.byebye.should == "byebye"
	end
end
