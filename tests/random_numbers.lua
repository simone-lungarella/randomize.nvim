local M = require("randomize")
local eq = assert.are.same

describe("randomize_between", function()
	it("should error on missing argument", function()
		local opts = { args = "10", line1 = 1, line2 = 1 }

		local error_message = ""
		---@diagnostic disable-next-line: duplicate-set-field
		vim.api.nvim_err_writeln = function(msg)
			error_message = msg
		end

		M.generate_random_numbers(opts)

		eq(error_message, "Invalid usage. Usage: :RandomizeBetween <min> <max>")
	end)

	it("should error on range having min > max", function()
		local opts = { args = "20 10", line1 = 1, line2 = 1 }

		local error_message = ""
		---@diagnostic disable-next-line: duplicate-set-field
		vim.api.nvim_err_writeln = function(msg)
			error_message = msg
		end

		M.generate_random_numbers(opts)

		eq(error_message, "Invalid range. Ensure min and max are numbers, and min <= max.")
	end)

	it("should replace selected portion with random number in range", function()
		local min = 1
		local max = 100
		local opts = { args = "1 100", line1 = 1, line2 = 1 }

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

		---@diagnostic disable-next-line: duplicate-set-field
		math.random = function(...)
			local args = { ... }
			local first_arg = args[1]
			local second_arg = args[2]
			return second_arg - first_arg
		end

		M.generate_random_numbers(opts)

		eq(vim.fn.mock_line, "This is a " .. max - min .. " line")
	end)
end)
