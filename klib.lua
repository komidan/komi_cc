-- komi library
-- built for CC: Tweaked 1.21.1

local knet = {}
local kutil = {}

--- @alias message table
--- | 'data' your data...
--- | 'timestamp' MM/DD/YYYY HH:MM:SS
--- | 'status_code' a message's status code for communication

---@enum STATUS_CODES
local STATUS_CODES = {
	-- success
	OK        = 200,
	CREATED   = 201,
	ACCEPTED  = 202,

	-- error
	BAD_REQUEST  = 400,
	UNAUTHORIZED = 401,
	FORBIDDEN    = 403,
	NOT_FOUND    = 404
}

--- Formats a Message into a loggable/printable string
--- @param from integer
--- @param to integer
--- @param message message
--- @return string 
function knet.formatMessage(from, to, message, protocol)
	local log = (
		message.timestamp .. ","  ..
		tostring(from)    .. "->" ..
		tostring(to)      .. ","  ..
		protocol          .. ","  ..
		textutils.serialize(message.data, { compact = true })
	)
	return log
end

--- Creates a message, adding relevent data to each message
--- because having some form of order to this makes sense.
--- @param data table  table of the data you wish to trasmit
--- @param status_code integer status code provided by `STATUS_CODES` table
--- @return message # returns the data + the 'relevant data'
--- @overload fun(data: table)
function knet.msg(data, status_code)
	---@type message
	local message = {
		data = data,
		timestamp = os.date("%D %T"),
		status_code = status_code,
	}
	return message
end

--- Sends a message over rednet with a message created with `knet.msg()`
--- @param recipient integer id of the computer receiving the message
--- @param message message
--- @param protocol string | nil protocol to send message over
--- @return boolean # returns true if message was sent successfully
function knet.send(recipient, message, protocol)
	local success = nil
	if protocol then
		success = rednet.send(recipient, message)
	end
	success = rednet.send(recipient, message, protocol)
	return success
end

--- Receives a message or broadcast over rednet.
--- @param timeout number how long should you wait before eventually returning nil
--- @return integer sender, message message, string protocol
function knet.receive(timeout)
	-- set timeout to nil if not provided
	timeout = timeout or nil

	return rednet.receive(timeout)
end

--- This is pretty much useless, could just do
--- `rednet.broadcast()` and pass my message type. But hey, why not?
--- @param message message
--- @param protocol string | nil
function knet.broadcast(message, protocol)
	if protocol then
		rednet.broadcast(message)
	end
	rednet.broadcast(message, protocol)
end

--- ### Usage:
--- ```lua
--- local p = kutil.getPeripherals()
--- rednet.open(p.modem)
--- ```
--- Possible peripheral keys are:
--- `command`, `computer`, `drive`, `drive`, `modem`, `monitor`, `printer`, `redstone_relay`, `speaker`
--- @return table # list of all peripherals connected
function kutil.getPeripherals()
    local peripherals = {}
    local names = peripheral.getNames()
    for i = 0, #names do
        if names[i] ~= nil then
            peripherals[peripheral.getType(names[i])] = peripheral.wrap(names[i])
        end
    end
    return peripherals
end

-- funktyouns
return {
	knet = knet,
	kutil = kutil,

	STATUS_CODES = STATUS_CODES,
}