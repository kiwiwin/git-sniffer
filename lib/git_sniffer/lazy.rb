module GitSniffer
	module Lazy
		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def lazy_reader(*args)
				opts = {}
				opts = args.pop if args[-1].is_a?(Hash)
				args.each do |arg|
					ivar = "@#{arg}"
					if opts.empty?
						define_method(arg) do
							instance_variable_set(ivar, send("lazy_#{arg}_source")) if !instance_variable_defined?(ivar)
							instance_variable_get(ivar)
						end
					else
						define_method(arg) do
							send(opts[:init]) if !instance_variable_defined?(ivar)
							instance_variable_get(ivar)
						end						
					end
				end
			end
		end
	end
end
