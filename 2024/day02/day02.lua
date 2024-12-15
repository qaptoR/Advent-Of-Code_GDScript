-- [[ safe reports ]]
-- all levels increasing or decreasing
-- any two adjacent levels differ by at least 1 and at most 3

-- how many reports are safe?
local function read_file(file_path)
	local file = io.open(file_path, "r")
	if not file then
		return nil
	end

	-- local content = file:read("*all")
	local content = {}
	for line in file:lines() do
		table.insert(content, line)
	end

	file:close()
	return content
end

local function split_string(input_str, delimiter)
	local result = {}
	for match in (input_str .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

local function check_level(level)
	local decreasing = false
	local increasing = false
	local flag = true

	for j = 2, #level do
		local a = tonumber(level[j - 1])
		local b = tonumber(level[j])

		local c = a - b
		local s = c > 0 and 1 or -1
		c = math.abs(c)

		if s > 0 then
			-- we are decreasing
			if increasing then
				-- but we weren't before
				flag = false
				increasing = false
			end
			decreasing = true
		elseif s < 0 then
			-- we were increasing
			if decreasing then
				-- but we weren't before
				flag = false
				decreasing = false
			end
			increasing = true
		end
		if c == 0 or 3 < c then
			flag = false
		end
	end
	return flag
end

local function main1()
	local DATA_FILE = vim.fn.getcwd() .. "/data/day2.txt"

	local reports = read_file(DATA_FILE)
	if not reports then
		return
	end

	local safe_reports = 0

	for i = 1, #reports do
		local level = split_string(reports[i], " ")
		local flag = check_level(level)
		if flag then
			safe_reports = safe_reports + 1
		end
	end

	print(safe_reports)
end

local function main2()
	local DATA_FILE = vim.fn.getcwd() .. "/data/day2.txt"

	local reports = read_file(DATA_FILE)
	if not reports then
		return
	end

	local safe_reports = 0
	local unsafe_reports = {}

	for i = 1, #reports do
		local level = split_string(reports[i], " ")
		local flag = check_level(level)
		if flag then
			safe_reports = safe_reports + 1
		else
			table.insert(unsafe_reports, reports[i])
		end
	end

	for i = 1, #unsafe_reports do
		local level = split_string(unsafe_reports[i], " ")
		for i = 1, #level do
			local sublevel = { table.unpack(level) }
			table.remove(sublevel, i)
			local flag = check_level(sublevel)
			if flag then
				safe_reports = safe_reports + 1
				break
			end
		end
	end

	print(safe_reports)
end

-- main1()
main2()

-- vim: ts=2 sts=2 sw=2 et
