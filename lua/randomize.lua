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

	-- Iterate through the selected lines
	for line = start_line, end_line do
		local current_line = vim.fn.getline(line) -- Get the current line content
		local col_start, col_end = vim.fn.col("'<"), vim.fn.col("'>") -- Get the visual selection range (columns)

		-- Ensure the range is valid for this line
		col_start = math.max(1, col_start)
		col_end = math.min(#current_line + 1, col_end)

		-- Generate a random number
		local random_number = tostring(math.random(min, max))

		-- Replace only the selected portion
		local before = current_line:sub(1, col_start - 1) -- Text before the selection
		local after = current_line:sub(col_end + 1) -- Text after the selection
		local updated_line = before .. random_number .. after

		vim.fn.setline(line, updated_line) -- Update the line
	end
end

function M.setup()
	vim.api.nvim_create_user_command("RandomizeBetween", function(opts)
		M.randomize_lines_in_range(opts)
	end, { nargs = 1, range = true })
end

return M
