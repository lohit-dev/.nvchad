return {
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			sort = {
				-- Sort embedded numbers as numbers: 1, 27, 88, 121 ... rather than
				-- lexically: 121, 169, 1 ...
				sorter = function(nodes)
					local function natural_less(left, right)
						local a, b = left:lower(), right:lower()
						local i, j = 1, 1

						while i <= #a and j <= #b do
							local char_a, char_b = a:sub(i, i), b:sub(j, j)
							if char_a:match("%d") and char_b:match("%d") then
								local number_a = a:match("%d+", i)
								local number_b = b:match("%d+", j)
								local trimmed_a = number_a:gsub("^0+", "")
								local trimmed_b = number_b:gsub("^0+", "")
								trimmed_a = trimmed_a == "" and "0" or trimmed_a
								trimmed_b = trimmed_b == "" and "0" or trimmed_b

								if #trimmed_a ~= #trimmed_b then
									return #trimmed_a < #trimmed_b
								end
								if trimmed_a ~= trimmed_b then
									return trimmed_a < trimmed_b
								end
								i = i + #number_a
								j = j + #number_b
							else
								if char_a ~= char_b then
									return char_a < char_b
								end
								i, j = i + 1, j + 1
							end
						end

						return #a < #b
					end

					table.sort(nodes, function(a, b)
						if a.type ~= b.type and (a.type == "directory" or b.type == "directory") then
							return a.type == "directory"
						end
						return natural_less(a.name, b.name)
					end)
				end,
			},
			view = {
				side = "right",
			},
		},
	},
}
