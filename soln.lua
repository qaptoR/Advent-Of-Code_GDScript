--

local TEST_FILE = vim.fn.getcwd() .. "/2024/day00/test00.txt"
local DATA_FILE = vim.fn.getcwd() .. "/2024/day00/data00.txt"

-- Read file
local function read_file(file_path)
	local file = io.open(file_path, "r")
	if not file then
		print("File not found")
		return nil
	end

	local content = {}
	for line in file:lines() do
		table.insert(content, line)
	end

	file:close()
	return content
end

-- split string
local function split_string(input_str, delimiter)
	local result = {}
	for match in (input_str .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

-- part 1
local function test_data1(data_)
	local time_start = vim.uv.hrtime() / 1000

	local result = 0
	for i = 1, #data_ do
		print(data_[i])
	end

	local time_end = vim.uv.hrtime() / 1000
	print("part 1: " .. result .. "time: ", time_end - time_start)
end

-- part 2
local function test_data2(data_)
	local time_start = vim.uv.hrtime() / 1000

	local result = 0

	local time_end = vim.uv.hrtime() / 1000
	print("part 1: " .. result .. "time: ", time_end - time_start)
end

-- main
local function main()
	print("\nHello, Day 00!")

	-- local data = read_file(TEST_FILE)
	local data = read_file(DATA_FILE)

	test_data1(data)
	test_data2(data)

	print("\nfin\n")
end

main()

-- vim: ts=2 sts=2 sw=2 et
