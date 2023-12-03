-- Function to create a graph table from input
function createGraph()
	local graph = {}

	-- Read the number of vertices
	io.write("Enter the number of vertices: ")
	local numVertices = tonumber(io.read())

	-- Read edges
	for i = 1, numVertices do
		graph[i] = {}
		io.write("Enter the neighbors of vertex " .. i .. " (comma-separated): ")
		local input = io.read()
		for neighbor in input:gmatch("%d+") do
			if tonumber(neighbor) > numVertices or tonumber(neighbor) < 1 then
				io.write("Invalid vertex index: " .. tonumber(neighbor) .. " skipping\n")
			else
				table.insert(graph[i], tonumber(neighbor) - 1)
			end
		end
	end

	return graph
end

-- Function to save the graph to a file
function saveGraphToFile(graph, filename)
	local file = assert(io.open(filename, "w"))

	for _, neighbors in ipairs(graph) do
		for _, neighbor in ipairs(neighbors) do
			file:write(neighbor .. " ")
		end
		file:write("\n")
	end

	file:close()
	print('\nGraph adjacency list saved to "' .. filename .. '"')
end

-- Function to print the graph
function printGraph(graph)
	print("\nGraph adjacency list:")
	for i, neighbors in ipairs(graph) do
		io.write("Vertex " .. i .. ": ")
		for _, neighbor in ipairs(neighbors) do
			io.write(neighbor + 1 .. " ")
		end
		print()
	end
end

-- Main program
local filename = "../shared/graph_input.txt"
local graph = createGraph()
printGraph(graph)
saveGraphToFile(graph, filename)
