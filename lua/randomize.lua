local M = {}

function M.generate_random_numbers(opts)
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

function M.generate_random_dates(opts)
	local args = vim.split(opts.args, " ")
	if #args ~= 2 then
		vim.api.nvim_err_writeln("Invalid usage. Usage: :RandomizeDateBetween <min-date> <max-date>")
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
		local random_date = M.random_date(args[1], args[2])

		-- Replace only the selected portion
		local before = current_line:sub(1, col_start - 1) -- Text before the selection
		local after = current_line:sub(col_end + 1) -- Text after the selection
		local updated_line = before .. random_date .. after

		vim.fn.setline(line, updated_line) -- Update the line
	end
end

function M.random_date(start_date, end_date)
	local pattern = "(%d+)-(%d+)-(%d+)"

	-- Parse the start and end dates into timestamps
	local start_year, start_month, start_day = start_date:match(pattern)
	local end_year, end_month, end_day = end_date:match(pattern)

	if not (start_year and start_month and start_day and end_year and end_month and end_day) then
		error("Invalid date format. Expected 'YYYY-MM-DD'.")
	end

	local start_time = os.time({
		year = tonumber(start_year, 1970),
		month = tonumber(start_month, 1),
		day = tonumber(start_day, 1),
		hour = 0,
		min = 0,
		sec = 0,
	})

	local end_time = os.time({
		year = tonumber(end_year, 2024),
		month = tonumber(end_month, 12),
		day = tonumber(end_day, 31),
		hour = 0,
		min = 0,
		sec = 0,
	})

	if start_time > end_time then
		error("Start date must be earlier than end date.")
	end

	-- Generate a random timestamp between the two dates
	local random_time = math.random(start_time, end_time)

	-- Convert the random timestamp back to a date string
	return os.date("%Y-%m-%d", random_time)
end

function M.setup()
	vim.api.nvim_create_user_command("RandomizeBetween", function(opts)
		M.generate_random_numbers(opts)
	end, { nargs = 1, range = true })

	vim.api.nvim_create_user_command("RandomizeDateBetween", function(opts)
		M.generate_random_dates(opts)
	end, { nargs = 1, range = true })
end

return M
