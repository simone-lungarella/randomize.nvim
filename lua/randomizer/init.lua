local M = {}

function M.randomize_lines_in_range(opts)
	-- Validate input range
	local min = tonumber(opts.args[0])
	local max = tonumber(opts.args[1])
	if not min or not max or min > max then
		vim.api.nvim_err_writeln("Invalid range. Usage: :RandomizeBetween <min> <max>")
		return
	end

	-- Get the current range of selected lines
	local start_line, end_line = unpack(vim.fn.getpos("'<")), unpack(vim.fn.getpos("'>"))
	start_line = start_line[2]
	end_line = end_line[2]

	-- Iterate over the selected lines and replace them with random numbers
	for line = start_line, end_line do
		local random_number = math.random(min, max)
		vim.fn.setline(line, tostring(random_number))
	end
end

function M.setup()
	vim.api.nvim_create_user_command("RandomizeBetween", M.randomize_lines_in_range, { nargs = "?", range = true })
end

return M
