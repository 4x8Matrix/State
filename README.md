# State
State represents an object that wraps around a value, this object allows developers to listen to when a state has updated & perform QoL operations that mutate that value.

## Examples
Brief documentation to go through the functionality:

```lua
local Value = State.new("Hello, World!")

Value:Observe(function()
	print("Value Updated!")
end)

Value:Concat("!!")
```

Brief overview on how this integrates well with Knit:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local State = require(ReplicatedStorage.Packages.State)

local Controller = Knit.CreateController({
	Name = script.Name,
	
	BaseCharacterSpeed = State.new(16)
})

function Controller:updateInternalSpeed(newSpeed)
	doSomething(...)
end

function Controller:KnitInit()

	self:updateInternalSpeed(self.BaseCharacterSpeed:Get())
	self.BaseCharacterSpeed:Observe(function()
		self:updateInternalSpeed(self.BaseCharacterSpeed:Get())
	end)
end

return Controller
```
