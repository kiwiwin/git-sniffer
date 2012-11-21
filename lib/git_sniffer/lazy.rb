module GitSniffer
	module Lazy
		def self.included(base)
			base.extend ClassMethods
		end

		module ClassMethods
			def lazy_reader(*args)
				args.each do |arg|
					ivar = "@#{arg}"
					define_method(arg) do
						if instance_variable_defined?(ivar)
							val = instance_variable_get(ivar)
							return val if val
						end
						instance_variable_set(ivar, send("lazy_#{arg}_source"))
					end
				end
			end
		end
	end
end
