-- // Dependencies
local Signal = require(script.Parent.Signal)

-- // Module
local State = { }

State.Type = "State"

State.Interface = { }
State.Prototype = { }

-- // Module Types
export type StateObject = {
	ToString: (self: StateObject) -> string,
	Observe: (self: StateObject, callbackFn: (value: any) -> ()) -> RBXScriptConnection,
	Get: (self: StateObject) -> any,
	Set: (self: StateObject, value: any) -> (),
	Update: (self: StateObject, transform: (value: any) -> any) -> StateObject,
	Concat: (self: StateObject, value: string) -> StateObject,
	Decrement: (self: StateObject, value: number) -> StateObject,
	Increment: (self: StateObject, value: number) -> StateObject,

	Changed: RBXScriptSignal
}

export type StateModule = {
	new: (value: any) -> StateObject,
	is: (object: StateObject?) -> boolean,
}

-- // Prototype functions
--[[
	Set the value of a state, when setting a state the 'Changed' signal will invoke.

	### Parameters
	- **value**: *the value we're setting*

	---
	Example:

	```lua
		local Value = State.new(0)

		Value:Set(1)
	```
]]
function State.Prototype:Set(value: any): StateObject
	local oldValue = self._value

	self._value = value
	self.Changed:Fire(oldValue, value)
end

--[[
	Increments the value by a given input

	---
	Example:

	```lua
		local value = State.new(5)
			:Increment(5)

		print(value:Get()) -- 10
	```
]]
function State.Prototype:Increment(value: number): StateObject
	assert(type(self._value) == "number", `Expected value to be a number when calling ':Increment', instead got {type(self._value)}`)

	self:Set(self._value + value)

	return self
end

--[[
	Decrement the value by a given input

	---
	Example:

	```lua
		local value = State.new(10)
			:Decrement(5)

		print(value:Get()) -- 5
	```
]]
function State.Prototype:Decrement(value: number): StateObject
	assert(type(self._value) == "number", `Expected value to be a number when calling ':Decrement', instead got {type(self._value)}`)

	self:Set(self._value - value)

	return self
end

--[[
	Concat the value by a given input

	---
	Example:

	```lua
		local Value = State.new("Hello ")
			:Concat("World!")

		print(value:Get()) -- Hello World!
	```
]]
function State.Prototype:Concat(value: string): StateObject
	assert(type(self._value) == "string", `Expected value to be a string when calling ':Concat', instead got {type(self._value)}`)

	self:Set(self._value .. value)

	return self
end

--[[
	Update the given value with a transform function

	---
	Example:

	```lua
		local Value = State.new("Hello ")
			:Update(function(value)
				return value .. "World!"
			end)

		print(value:Get()) -- Hello World!
	```
]]
function State.Prototype:Update(transform: (value: any) -> any): StateObject
	assert(type(transform) == "function", `Expected #1 parameter 'transform' to be a function when calling ':Update', instead got {type(transform)}`)

	self:Set(transform(self._value))

	return self
end

--[[
	Fetches the value that the State currently holds.

	---
	Example:

	```lua
		local Value = State.new(0)
		local resolve = Value:Get()
	```
]]
function State.Prototype:Get(): any
	return self._value
end

--[[
	Quick QoL function to observe any changes made to the states value

	### Parameters
	- **callbackFn**: *the callback function that'll connect to the 'Changed' event*

	---
	Example:

	```lua
		local Value = State.new(0)

		Value:Observe(function(oldValue, newValue)
			doSomething(oldValue, newValue)
		end)
	```
]]
function State.Prototype:Observe(callbackFn: (oldValue: any, newValue: any) -> ()): RBXScriptConnection
	return self.Changed:Connect(callbackFn)
end

--[[
	Returns a prettified string version of the state table.

	---
	Example:

	```lua
		local Value = State.new(0)

		print(tostring(Value)) -- Value<0>
	```
]]
function State.Prototype:ToString()
	return `{State.Type}<{tostring(self._value)}>`
end

-- // Module functions
--[[
	Generate a new 'value' object

	### Parameters
	- **value**: *any object/type you'd want to store inside of the State*

	---
	Example:

	```lua
		local object = State.new("Hello, World!")

		...
	```
]]
function State.Interface.new(value: any): StateObject
	local self = setmetatable({ _value = value }, {
		__type = State.Type,
		__index = State.Prototype,
		__tostring = function(object)
			return object:ToString()
		end
	})

	self.Changed = Signal.new()

	return self
end

--[[
	Validate if an object is a 'State' object

	### Parameters
	- **object**: *potentially an 'State' object*

	---
	Example:

	```lua
		local object = State.new("Hello, World!")

		if State.is(object) then
			...
		end
	```
]]
function State.Interface.is(object: StateObject?): boolean
	if not object or type(object) ~= "table" then
		return false
	end

	local metatable = getmetatable(object)

	return metatable and metatable.__type == State.Type
end

return State.Interface :: StateModule