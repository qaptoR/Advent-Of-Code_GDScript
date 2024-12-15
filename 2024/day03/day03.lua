-- [[]]
local function read_file(file_path)
	local file = io.open(file_path, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	-- local content = {}
	-- for line in file:lines() do
	-- 	table.insert(content, line)
	-- end

	file:close()
	return content
end

-- [[]]
local function split_string(input_str)
	local result = {}
	for match in input_str:gmatch([[(mul%(%d%d?%d?,%d%d?%d?%))]]) do
		table.insert(result, match)
	end
	return result
end

-- [[]]
local function find_matches(text)
	local patterns = {
		[[(do%(%))]],
		[[(don't%(%))]],
		[[(mul%(%d%d?%d?,%d%d?%d?%))]],
	}

	local matches = {}
	local position = 1

	while position <= #text do
		local closest_start, closest_end, closest_match = nil, nil, nil

		for _, pattern in ipairs(patterns) do
			local start_pos, end_pos = text:find(pattern, position)
			if start_pos and (not closest_start or start_pos < closest_start) then
				closest_start, closest_end, closest_match = start_pos, end_pos, text:sub(start_pos, end_pos)
			end
		end

		if closest_match then
			table.insert(matches, closest_match)
			position = closest_end + 1
		else
			break
		end
	end

	return matches
end

-- [[]]
local function parse_numbers(input_str)
	local result = {}
	for match in input_str:gmatch("(%d+)") do
		table.insert(result, tonumber(match))
	end
	return result
end

-- [[]]
local function main1()
	local DATA_FILE = vim.fn.getcwd() .. "/data/day3.txt"

	local memory = read_file(DATA_FILE)
	if not memory then
		return
	end

	local data = split_string(memory)
	local accum = 0
	for i = 1, #data do
		local numbers = parse_numbers(data[i])
		accum = accum + (numbers[1] * numbers[2])
	end

	print(accum)
end

-- [[]]
local function main2()
	local DATA_FILE = vim.fn.getcwd() .. "/data/day3.txt"

	local memory = read_file(DATA_FILE)
	if not memory then
		return
	end

	local data = find_matches(memory)
	local accum = 0
	local multiply = true
	for i = 1, #data do
		if data[i]:find("do%(") then
			multiply = true
		elseif data[i]:find("don't%(") then
			multiply = false
		else
			if multiply then
				local numbers = parse_numbers(data[i])
				accum = accum + (numbers[1] * numbers[2])
			end
		end
	end

	print(accum)
end

-- main1()
main2()

-- vim: ts=2 sts=2 sw=2 et
