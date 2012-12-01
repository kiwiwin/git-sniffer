require "bundler/gem_tasks"

task :default => [:spec]

task :spec do
	puts `rspec spec/*_spec.rb`
end

task :slow do
	puts `rspec spec/*_specslow.rb`
end

task :all => [:spec, :slow] do
end

task :example do
	Dir[File.dirname(__FILE__) + "/example/*.rb"].each do |e|
		puts `ruby #{e}`
	end
end

