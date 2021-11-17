-- finobinos
-- init.lua
-- 16 October 2021

--[[
	-- Static methods:

	Maid.new() --> table 
	Maid.IsA(self : any) --> boolean 

	-- Instance methods:
	
	Maid:AddTask(task : table | function | RBXScriptConnection | Instance) --> task 
	Maid:Cleanup() --> ()
	Maid:RemoveTask(task : table | function | RBXScriptConnection | Instance) --> () 
	Maid:LinkToInstance(instance : Instance) --> (instance, ManualConnection) 
		ManualConnection:Disconnect() --> ()
		ManualConnection:IsConnected() --> boolean
		
	Maid:Destroy() --> () 
]]

--[=[
	@class Maid
	Maids track tasks and clean them when needed.

	For e.g:
	```lua
	local maid = Maid.new()
	local connection = workspace.ChildAdded:Connect(function()

	end)
	maid:AddTask(connection)
	maid:Cleanup()

	task.defer(function()
		print(connection.Connected) --> false
	end)
	```
]=]

local Maid = {}
Maid.__index = Maid

local LocalConstants = {
	ErrorMessages = {
		InvalidArgument = "Invalid argument#%d to %s: expected %s, got %s",
	},
}

local ManualConnection = {}
ManualConnection.__index = ManualConnection

do
	function ManualConnection.new()
		return setmetatable({}, ManualConnection)
	end

	function ManualConnection.IsA(self)
		return getmetatable(self) == ManualConnection
	end

	function ManualConnection:Disconnect()
		assert(self._connection.Connected, "Can't disconnect an already disconnected connection")
		self._connection:Disconnect()
	end

	function ManualConnection:GiveConnection(connection)
		self._connection = connection
	end

	function ManualConnection:IsConnected()
		return self._connection.Connected
	end
end

--[=[
	A constructor method which creates and returns a new maid.

	@return Maid 
]=]

function Maid.new()
	return setmetatable({
		_tasks = {},
		_linkedConnections = {},
	}, Maid)
end

--[=[
	A method which is used to check if the given argument is a maid or not.

	@param self any 
	@return boolean 
]=]

function Maid.IsA(self)
	return getmetatable(self) == Maid
end

--[=[
	Adds a task for the maid to cleanup. 

	:::note
	If `table` is passed as a task, it must have a `Destroy` or `Disconnect` method so that it can be cleaned up.
	:::

	@tag Maid
	@param task function | RBXScriptConnection | table | Instance 
	@return task 
]=]

function Maid:AddTask(task)
	assert(
		typeof(task) == "function"
			or typeof(task) == "RBXScriptConnection"
			or typeof(task) == "table" and (typeof(task.Destroy) == "function" or typeof(task.Disconnect) == "function")
			or typeof(task) == "Instance",

		LocalConstants.ErrorMessages.InvalidArgument:format(
			1,
			"Maid:AddTask()",
			"function or RBXScriptConnection or Instance or table with Destroy or Disconnect method",
			typeof(task)
		)
	)

	self._tasks[task] = task

	return task
end

--[=[
	Removes the task (assuming it was added as an task for the maid to cleanup) so that it will not be cleaned up. 

	@tag Maid
	@param task function | RBXScriptConnection | table | Instance 
]=]

function Maid:RemoveTask(task)
	self._tasks[task] = nil
end

--[=[
	Works the same as `Maid:RemoveTask`, but also cleans up `task` for the last time.

	@tag Maid
	@param task function | RBXScriptConnection | table | Instance 
]=]

function Maid:RemoveTaskAndCleanup(task)
	self:RemoveTask(task)
	self:_cleanupTask(task)
end

--[=[
	Cleans up all the added tasks.
	@tag Maid

	| Task      | Type                          |
	| ----------- | ------------------------------------ |
	| `function`  | The function will be called.  |
	| `table`     | Any `Destroy` or `Disconnect` method in the table will be called. |
	| `Instance`    | The instance will be destroyed. |
	| `RBXScriptConnection`    | The connection will be disconnected. |
]=]

function Maid:Cleanup()
	-- next() allows us to easily traverse the table accounting for more values being added. This allows us to clean
	-- up tasks spawned by the cleaning up of current tasks.
	local tasks = self._tasks
	local key, task = next(tasks)

	while task do
		tasks[key] = nil
		self:_cleanupTask(task)
		key, task = next(tasks)
	end
end

--[=[
	@tag Maid

	Destroys the maid and makes it unusuable.
	
	:::warning
	Trivial errors will occur if your code unintentionally works on a destroyed maid, only call this method when you're done working with the maid.
	:::
]=]

function Maid:Destroy()
	-- First cleanup all linked connections:
	for _, connection in ipairs(self._linkedConnections) do
		if
			ManualConnection.IsA(connection) and connection:IsConnected()
			or typeof(connection) == "RBXScriptConnection" and connection.Connected
		then
			connection:Disconnect()
		end
	end

	self:Cleanup()

	for key, _ in pairs(self) do
		self[key] = nil
	end

	setmetatable(self, nil)
end

--[=[
	Links the given instance to the maid so that the maid will clean up all the tasks once the instance has been removed from the game i.e parented to `nil`.
	If `callback` is specified, it will be called before cleaning up the maid (when the instance is parented to `nil`) and 
	if the function upon being called doesn't return a truthy value, the maid will not cleanup.

	For e.g:

	```lua
	local instance = ... -- some instance parented to workspace
	local maid = Maid.new()

	maid:AddTask(function()
		warn("cleaned up")
	end)

	maid:LinkToInstance(instance)
	instance.Parent = nil
	-- Now the maid will cleanup as the instance is parented to nil.
	```

	Here's an alternate case:

	```lua
	local instance = ... -- some instance parented to workspace
	local maid = Maid.new()

	maid:AddTask(function()
		warn("cleaned up")
	end)

	maid:LinkToInstance(instance, function()
		if instance:GetAttribute("DontHaveTheMaidCleanedupYetPlease") then
			return false
		end

		-- If the instance doesn't have that attribute, we can clean it up:
		return true
	end))

	instance:SetAttribute("DontHaveTheMaidCleanedupYetPlease", true)
	instance.Parent = nil
	-- The instance is parented to nil, but the maid hasn't cleaned up!
	```

	A connection is returned so that once it is disconnected, the maid will unlink from the instance. The connection 
	contains the following methods:

	| Methods      | Description                          |
	| ----------- | ------------------------------------ |
	| `Disconnect`  | The connection will be disconnected and the maid will unlink to the instance it was linked to.  |
	| `IsConnected` | Returns a boolean indicating if the connection has been disconnected. |

	:::note
	This connection will be disconnected when the maid is destroyed, so be careful with how you work with them.
	:::

	@param instance Instance
	@param callback function | nil
	@return Connection 
]=]

function Maid:LinkToInstance(instance, callback)
	assert(
		typeof(instance) == "Instance",
		LocalConstants.ErrorMessages.InvalidArgument:format(1, "Maid:LinkToInstance()", "Instance", typeof(instance))
	)

	if callback then
		assert(
			typeof(callback) == "function",
			LocalConstants.ErrorMessages.InvalidArgument:format(
				2,
				"Maid:LinkToInstance()",
				"function",
				typeof(callback)
			)
		)
	end

	local manualConnection = ManualConnection.new()

	local function Cleanup()
		-- Incase the maid was destroyed, then that means it isn't safe to access it:
		if not Maid.IsA(self) then
			return
		end

		local shouldCleanup = if callback then callback() else true

		-- Recheck again as after calling the callback (it may have yielded), and it's possible that by
		-- time, the maid was either destroyed or the manual connection returned was disconnected
		if not Maid.IsA(self) or not manualConnection:IsConnected() then
			return
		end

		if shouldCleanup or not callback then
			manualConnection:Disconnect()
			self:Cleanup()
		end
	end

	local instanceAncestryChangedConnection = instance.AncestryChanged:Connect(function(_, parent)
		if not parent then
			Cleanup()
		end
	end)

	manualConnection:GiveConnection(instanceAncestryChangedConnection)
	table.insert(self._linkedConnections, manualConnection)

	if not instance.Parent then
		Cleanup()
	end

	return manualConnection
end

function Maid:_cleanupTask(task)
	if typeof(task) == "function" then
		task()
	elseif typeof(task) == "RBXScriptConnection" then
		task:Disconnect()
	else
		if task.Destroy then
			task:Destroy()
		else
			task:Disconnect()
		end
	end
end

return Maid
