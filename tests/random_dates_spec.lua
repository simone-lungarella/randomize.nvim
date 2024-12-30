local M = require("randomize")
local eq = assert.are.same

describe("randomize_date_between", function()
	it("should error on missing argument", function()
		local opts = { args = "2024-01-01", line1 = 1, line2 = 1 }

		local error_message = ""
		---@diagnostic disable-next-line: duplicate-set-field
		vim.api.nvim_err_writeln = function(msg)
			error_message = msg
		end

		M.generate_random_dates(opts)

		eq(error_message, "Invalid usage. Usage: :RandomizeDateBetween <min-date> <max-date>")
	end)

	it("should error when start date is after end date", function()
		local opts = { args = "2024-01-01 2023-01-01", line1 = 1, line2 = 1 }

		local error_message = ""
		---@diagnostic disable-next-line: duplicate-set-field
		vim.api.nvim_err_writeln = function(msg)
			error_message = msg
		end

		M.generate_random_dates(opts)

		eq(error_message, "Start date must be earlier than end date.")
	end)

	it("should replace selected portion with random date in range", function()
		local start_range = "2023-01-01"
		local end_range = "2024-01-01"

		local opts = { args = start_range .. " " .. end_range, line1 = 1, line2 = 1 }

		-- Mock the line content
		---@diagnostic disable-next-line: duplicate-set-field
		vim.fn.getline = function(line)
			if line == 1 then
				return "This is a test line"
			end
		end

		---@diagnostic disable-next-line: duplicate-set-field
		vim.fn.setline = function(line, content)
			if line == 1 then
				vim.fn.mock_line = content
			end
		end

		---@diagnostic disable-next-line: duplicate-set-field
		vim.fn.col = function(marker)
			if marker == "'<" then
				return 11
			end
			if marker == "'>" then
				return 14
			end
		end

		--- Mock random function to return starting range as random date
		---@diagnostic disable-next-line: duplicate-set-field
		math.random = function(...)
			local args = { ... }
			return args[1]
		end

		M.generate_random_dates(opts)

		eq(vim.fn.mock_line, "This is a " .. start_range .. " line")
	end)
end)
