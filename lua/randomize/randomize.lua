local M = {}

function M.randomize_lines_in_range(opts)
	local args = vim.split(opts.args, " ")
	if #args ~= 2 then
		vim.api.nvim_err_writeln("Invalid usage. Usage: :RandomizeBetween <min> <max>")
		return
	end

	local min = tonumber(args[1])
	local max = tonumber(args[2])
	if not min or not max or min > max then
		vim.api.nvim_err_writeln("Invalid range. Ensure min and max are numbers, and min <= max.")
		return
	end

	local start_line = opts.line1
	local end_line = opts.line2

	for line = start_line, end_line do
		local random_number = math.random(min, max)
		vim.fn.setline(line, tostring(random_number))
	end
end

function M.setup()
	vim.api.nvim_create_user_command("RandomizeBetween", function(opts)
		M.randomize_lines_in_range(opts)
	end, { nargs = 1, range = true })
end

return M
