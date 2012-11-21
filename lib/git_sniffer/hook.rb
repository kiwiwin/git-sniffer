require_relative 'base'

module GitSniffer
	class Hook
		def initialize(base)
			@base = base
			@commit_hooks = {}
		end

		def add_commit_hook(hook_name, hook_proc)
			@commit_hooks[hook_name] = hook_proc
		end

		def run_hook
			@commit_results = @base.commits.collect do |commit|
				@commit_hooks.inject({}) do |res, hook|
					res[hook[0]] = hook[1].call(commit); res
				end
			end
		end

		def all_commit_result
			@commit_results
		end
	end
end
