local M = {}

--- Generate random numbers within a specified range and replace selected text in the buffer.
-- This function modifies the selected portion of lines in a buffer, replacing it with
-- randomly generated numbers within a given range.
--
-- @param opts table A table containing the options for the function. It must include:
--   - args (string): A string containing two space-separated numbers: `<min> <max>`.
--                    These specify the range for random number generation.
--   - line1 (number): The starting line number of the range of lines to process.
--   - line2 (number): The ending line number of the range of lines to process.
--
-- The function uses the following rules:
-- - If `args` is not in the format `<min> <max>`, it will display an error.
-- - If `<min>` is greater than `<max>`, or if either is not a number, it will display an error.
-- - For each line in the range from `line1` to `line2`, it replaces the visually selected
--   text (columns defined by `vim.fn.col("'<")` and `vim.fn.col("'>")`) with a random number in specified range.
--
-- Errors:
-- - Displays an error message if the arguments are invalid or the range is invalid.
--
-- @return nil This function does not return a value.
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

	for line = start_line, end_line do
		local current_line = vim.fn.getline(line)
		-- Get the visual selection range (columns)
		local col_start, col_end = vim.fn.col("'<"), vim.fn.col("'>")

		col_start = math.max(1, col_start)
		col_end = math.min(#current_line + 1, col_end)

		local random_number = tostring(math.random(min, max))

		-- Replace only the selected portion
		local before = current_line:sub(1, col_start - 1)
		local after = current_line:sub(col_end + 1)
		local updated_line = before .. random_number .. after

		vim.fn.setline(line, updated_line)
	end
end

--- Generate random dates within a specified range and replace selected text in the buffer.
-- This function modifies the visually selected portion of lines in a buffer, replacing it
-- with randomly generated dates within a given range.
--
-- @param opts table A table containing the options for the function. It must include:
--   - args (string): A string containing two space-separated dates: `<min-date> <max-date>`.
--                    Dates must be in the format `YYYY-MM-DD`.
--   - line1 (number): The starting line number of the range of lines to process.
--   - line2 (number): The ending line number of the range of lines to process.
--
-- The function processes each line in the specified range (`line1` to `line2`) as follows:
-- 1. It extracts the visually selected portion of the line using `vim.fn.col`.
-- 2. It generates a random date between `<min-date>` and `<max-date>` using `M.random_date`.
-- 3. It replaces the visually selected portion of the line with the random date.
--
-- Errors:
-- - Displays an error message if `args` is not in the format `<min-date> <max-date>`.
-- - Displays an error message if the start date is later than the end date.
-- - Displays an error message if the dates are not in the format `YYYY-MM-DD`.
--
-- @return nil This function does not return a value.
function M.generate_random_dates(opts)
	local args = vim.split(opts.args, " ")
	if #args ~= 2 then
		vim.api.nvim_err_writeln("Invalid usage. Usage: :RandomizeDateBetween <min-date> <max-date>")
		return
	end

	local pattern = "(%d+)-(%d+)-(%d+)"

	-- Parse the start and end dates into timestamps
	local start_year, start_month, start_day = args[1]:match(pattern)
	local end_year, end_month, end_day = args[2]:match(pattern)

	if not (start_year and start_month and start_day and end_year and end_month and end_day) then
		vim.api.nvim_err_writeln("Invalid date format. Expected 'YYYY-MM-DD'.")
		return
	end

	local start_time = os.time({
		year = tonumber(start_year) or 1970,
		month = tonumber(start_month) or 1,
		day = tonumber(start_day) or 1,
		hour = 0,
		min = 0,
		sec = 0,
	})

	local end_time = os.time({
		year = tonumber(end_year) or 2024,
		month = tonumber(end_month) or 12,
		day = tonumber(end_day) or 31,
		hour = 0,
		min = 0,
		sec = 0,
	})

	if start_time > end_time then
		vim.api.nvim_err_writeln("Start date must be earlier than end date.")
		return
	end

	local start_line = opts.line1
	local end_line = opts.line2

	for line = start_line, end_line do
		local current_line = vim.fn.getline(line)
		-- Get the visual selection range (columns)
		local col_start, col_end = vim.fn.col("'<"), vim.fn.col("'>")

		col_start = math.max(1, col_start)
		col_end = math.min(#current_line + 1, col_end)

		-- Convert the random timestamp back to a date string
		local random_date = os.date("%Y-%m-%d", math.random(start_time, end_time))

		-- Replace only the selected portion
		local before = current_line:sub(1, col_start - 1)
		local after = current_line:sub(col_end + 1)
		local updated_line = before .. random_date .. after

		vim.fn.setline(line, updated_line)
	end
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
