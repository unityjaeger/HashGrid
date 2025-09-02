## Introduction
I made this module mainly because I just wanted one implementation of hash grids I can always use in my projects, and thought I'd just put it in a repository for others to use as well since its not much work. Aside from that, hash grids are easy to use and they are very useful as they enable efficient spatial queries by eliminating the need to check every object in the world when an algorithm only needs objects around a certain position.

This module is platform-agnostic meaning it was written in pure luau, not sure what applications outside of Roblox exist but if you want to write automated tests that involve this module in some way then keep in mind that its possible without needing to mock any Roblox instances.

## API Overview
The first exported function of the module is:
```luau
createGrid(resolution: number) -> Grid
```
Which is used to create and return a grid object with the specified resolution, it has 2 exposed methods:
```luau
grid:set(id: number, position: vector) -> ()
```
Set handles entering/leaving/moving between cells, it uses the id as a key in the internal data structure, you would typically keep a map seperate from the hash grid that maps ids to instances if u want to use it with Roblox instances.
```luau
grid:remove(id: number) -> ()
```
Simply removes the id from whatever cell it was in.
The other exported function of the module is:
```luau
query(position: vector, radius: number, ...: Grid) -> {number}
```
This function queries the specified grids and returns a table of ids (as used in grid:set and grid:remove), which means you can also have grids of multiple different resolutions and query them in the same query if needed.

## Considerations
TBD
