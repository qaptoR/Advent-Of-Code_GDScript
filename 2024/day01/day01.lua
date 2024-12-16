--

local TEST_FILE = vim.fn.getcwd() .. "/2024/day01/test01.txt"
local DATA_FILE = vim.fn.getcwd() .. "/2024/day01/data01.txt"

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

-- part 1
local function test_data1(data_)
	local time_start = vim.uv.hrtime() / 1000000

	local result = 0
	local lists = { {}, {} }
	for i = 1, #data_ do
		local j = 1
		for match in (data_[i] .. "   "):gmatch("(.-)" .. "   ") do
			table.insert(lists[j], match)
			j = j + 1
		end
	end

	for i = 1, #lists do
		table.sort(lists[i])
	end

	for _ = 1, #lists[1] do
		local a = lists[1][1]
		table.remove(lists[1], 1)

		local b = lists[2][1]
		table.remove(lists[2], 1)

		result = result + math.abs(a - b)
	end

	local time_end = vim.uv.hrtime() / 1000000
	print("part 1: " .. result .. " time: ", time_end - time_start)
end

-- part 2
local function test_data2(data_)
	local time_start = vim.uv.hrtime() / 1000000

	local result = 0
	local lists = { {}, {} }
	for i = 1, #data_ do
		local j = 1
		for match in (data_[i] .. "   "):gmatch("(.-)" .. "   ") do
			table.insert(lists[j], match)
			j = j + 1
		end
	end

	for i = 1, #lists[1] do
		local a = lists[1][i]
		local count = 0
		for j = 1, #lists[2] do
			local b = lists[2][j]
			if a == b then
				count = count + 1
			end
		end

		result = result + a * count
	end

	local time_end = vim.uv.hrtime() / 1000000
	print("part 2: " .. result .. " time: ", time_end - time_start)
end

-- main
local function main()
	print("Hello, Day 01!")

	-- local data = read_file(TEST_FILE)
	local data = read_file(DATA_FILE)

	test_data1(data)
	test_data2(data)

	print("fin\n")
end

main()

-- vim: ts=2 sts=2 sw=2 et
