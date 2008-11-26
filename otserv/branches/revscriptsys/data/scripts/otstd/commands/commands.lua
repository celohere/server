otstd.Commands = {}

Command = {}
Command_meta = { __index = Command }

function Command:new()
	local command = {}
	setmetatable(command, Command_meta)
	return command
end


function Command:register()
	if self.listener ~= nil then
		stopListener(self.listener)
	end
	if self.words == nil then
		error("Can not register command without words!")
	end
	if self.groups == nil then
		self.groups = {}
	end
	if self.handler == nil then
		error("Can not register command '" .. self.words .. " without handler!")
	end

	function internalHandler(event)
		local speaker = event.creature
		if isOfType(speaker, "Player") then
			if (type(self.groups) == "string" and self.groups == "All") or table.contains(self.groups, speaker:getAccessGroup()) then
				event.cmd = self.words
				event.param = event.text:sub(self.words:len()+1)
				self.handler(event)
			end
		else
			print "Not a player :("
		end
	end
	
	self.Listener = registerOnSay("beginning", true, self.words, internalHandler)
end

require("otstd/commands/move")
require("otstd/commands/floorchange")
require("otstd/commands/makeitem")
require("otstd/commands/age")