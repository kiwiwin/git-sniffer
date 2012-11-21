require_relative 'base'

module GitSniffer
	class Hook
		def initialize(base)
			@base = base
			@commit_hooks = {}
			@blob_hooks = {}
		end

		def run
			run_blobs
			run_commits
		end

		def run_blobs
			@blob_results ||= {}			
			@base.blobs.each do |blob|
				@blob_results[blob.sha] = @blob_hooks.inject({}) do |res, hook|
					res[hook[0]] = hook[1].call(blob); res
				end
			end
		end

		def run_commits
			@commit_results ||= {} 
			@base.commits.each do |commit|
				@commit_results[commit.sha] = @commit_hooks.inject({}) do |res, hook|
					res[hook[0]] = hook[1].call(self, commit); res
				end
			end
		end

		def blob_result(sha, name)
			@blob_results[sha][name]
		end

		private
		def method_missing(method_id, *args, &block) 
			return add_type_hook($1, *args) if method_id.to_s =~ /^add_(\w+)_hook$/
			return all_type_result($1) if method_id.to_s =~ /^all_(\w+)_result$/
			super
		end

		def add_type_hook(type, args)
			instance_variable_set("@#{type}_hooks", args)
		end

		def all_type_result(type)
			instance_variable_get("@#{type}_results")
		end
	end
end
