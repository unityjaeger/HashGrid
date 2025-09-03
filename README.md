## Introduction
I made this module mainly because I just wanted one implementation of hash grids I can always use in my projects, and thought I'd just put it in a repository for others to use as well since it's not much work. This module is also written in pure luau so it is platform-agnostic, it's primarily intended for Roblox but you can also easily use it in other luau enviroments or in automated tests without needing to mock Roblox instances just for the hash grid. Aside from that, hash grids are easy to use and they are very useful as they enable efficient spatial queries by eliminating the need to check every object in the world when an algorithm only needs objects around a certain position.

## API Overview
The first exported function of the module is:
```luau
createGrid(resolution: number) -> Grid
```
Which is used to create and return a grid object with the specified resolution, it has 2 exposed methods:
```luau
grid:set(id: number, position: vector) -> ()
```
Set handles entering, leaving and moving between cells, it uses the id as a key in the internal data structure. Calling set with the same id multiple times updates the position, it's not just for a single initial allocation. You would typically keep a map separate from the hash grid that maps ids to instances if you want to use it with Roblox instances.
```luau
grid:remove(id: number) -> ()
```
Simply removes the id from whatever cell it was in.
The other exported function of the module is:
```luau
query(position: vector, radius: number, ...: Grid) -> {number}
```
This function queries the specified grids and returns a table of ids (as used in grid:set and grid:remove), which means you can also have grids of multiple different resolutions and query them in the same query if needed.

## Usage Considerations
- id's should not be contained within multiple grids, otherwise you will get duplicates when querying both grids (unless you are doing this on purpose and don't plan on querying those grids together)
- choose the grid resolution so that the objects that will be inserted later can be fully contained by a single cell
- only use a specific grid for similarly-sized objects, otherwise it's generally better to create a separate grid for different-sized objects
- choose the resolution with care, your resolution doesn't need to match the object size perfectly, the optimal resolution depends on your query patterns, as frequent small-radius queries benefit from smaller cells, while large-radius queries perform better with larger cells
