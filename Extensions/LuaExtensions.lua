function array_has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

function string_first_to_upper(s)
    return (s:gsub("^%l", string.upper))
end

function to_string(o)
    return '"' .. tostring(o) .. '"'
end

function recurse(o, indent)
    if indent == nil then indent = '' end
    local indent2 = indent .. '  '
    if type(o) == 'table' then
        local s = indent .. '{' .. '\n'
        local first = true
        for k,v in pairs(o) do
            if first == false then s = s .. ', \n' end
            if type(k) ~= 'number' then k = to_string(k) end
            s = s .. indent2 .. '[' .. k .. '] = ' .. recurse(v, indent2)
            first = false
        end
        return s .. '\n' .. indent .. '}'
    else
        return to_string(o)
    end
end

function var_dump(...)
    local args = {...}
    if #args > 1 then
        var_dump(args)
    else
        print(recurse(args[1]))
    end
end