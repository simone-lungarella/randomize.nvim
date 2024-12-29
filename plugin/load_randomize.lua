vim.api.nvim_create_user_command("RandomizeBetween", function(opts)
	require("randomize").generate_random_numbers(opts)
end, { nargs = 1, range = true })

vim.api.nvim_create_user_command("RandomizeDateBetween", function(opts)
	require("randomize").generate_random_dates(opts)
end, { nargs = 1, range = true })
