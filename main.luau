--!strict
--!native
--!optimize 2

export type Grid = {
	resolution: number,
	cells: {[number]: {vector}},
	identifierToCell: {number},

	set: (grid: Grid, id: number, position: vector) -> (),
	remove: (grid: Grid, id: number) -> ()
}

--randomly chosen 6 digit prime numbers
local HASH_X = 521707
local HASH_Y = 268501  
local HASH_Z = 662351
local MAX_BUCKETS = 1024

local function hash(position: vector, resolution: number): number
	local hashedX = position.x // resolution * HASH_X
	local hashedY = position.y // resolution * HASH_Y
	local hashedZ = position.z // resolution * HASH_Z
	return (hashedX + hashedY + hashedZ) % MAX_BUCKETS
end

local function gridSet(grid: Grid, id: number, position: vector): ()
	local cells = grid.cells
	local identifierToCell = grid.identifierToCell
	
	local cell = hash(position, grid.resolution)
	local oldCell = identifierToCell[id]
	
	if not oldCell then
		identifierToCell[id] = cell
	else
		if oldCell ~= cell then
			identifierToCell[id] = cell
			cells[oldCell][id] = nil 
			
			if next(cells[oldCell]) == nil then
				cells[oldCell] = nil
			end
		end
	end

	if not cells[cell] then
		cells[cell] = {[id] = position}
	else
		cells[cell][id] = position
	end
end

local function gridRemove(grid: Grid, id: number): ()
	local cells = grid.cells
	local identifierToCell = grid.identifierToCell

	local cell = identifierToCell[id]
	if cell then
		identifierToCell[id] = nil
		cells[cell][id] = nil
		
		if next(cells[cell]) == nil then
			cells[cell] = nil
		end
	end
end

local function createGrid(resolution: number): Grid
	return {
		resolution = resolution,
		identifierToCell = {},
		cells = {},
		
		set = gridSet,
		remove = gridRemove
	}
end

local function query(position: vector, radius: number, ...: Grid): {number}
	local result = {}

	for _, grid in {...} do
		local hasCellBeenVisited: {[number]: boolean} = {}
		
		local cells = grid.cells
		local resolution = grid.resolution
		local cellsToTraverse = math.ceil(radius / resolution)

		local centerX = position.x // resolution
		local centerY = position.y // resolution
		local centerZ = position.z // resolution

		for offsetX = -cellsToTraverse, cellsToTraverse do
			local hashedCellX = (centerX + offsetX) * HASH_X
			
			for offsetY = -cellsToTraverse, cellsToTraverse do
				local hashedCellY = (centerY + offsetY) * HASH_Y
				
				for offsetZ = -cellsToTraverse, cellsToTraverse do
					local hashedCellZ = (centerZ + offsetZ) * HASH_Z

					local hashedPosition = (hashedCellX + hashedCellY + hashedCellZ) % MAX_BUCKETS
					local entry = cells[hashedPosition]
					
					if entry then
						if hasCellBeenVisited[hashedPosition] then
							continue
						end
						
						hasCellBeenVisited[hashedPosition] = true
						
						for objectId, objectPosition in entry do
							if vector.magnitude(objectPosition - position) <= radius then
								table.insert(result, objectId)
							end
						end
					end
				end
			end
		end
	end
	
	return result
end

return {
	createGrid = createGrid,
	query = query
}
