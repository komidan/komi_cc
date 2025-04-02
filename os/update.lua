-- Updates all files on system.
local drive = peripheral.find("drive")

local rebootTimer = 3.0
URLS = {
	"https://raw.githubusercontent.com/komidan/komi_cc/refs/heads/main/klib.lua",
	"https://raw.githubusercontent.com/komidan/komi_cc/refs/heads/main/os/startup.lua",
	"https://raw.githubusercontent.com/komidan/komi_cc/refs/heads/main/os/chocolat.lua",
	"https://raw.githubusercontent.com/komidan/komi_cc/refs/heads/main/os/update.lua",
}

term.clear()
term.setCursorPos(1, 1)

print("ChocolatOS Update")
term.setTextColor(colors.yellow)
print("WARNING: It is suggested to kill any scripts before updating!")
term.setTextColor(colors.white)
print("\nPress any button to continue.")
read()

local onDisk = nil
if drive then
	::diskInstall::
	print("Install to disk? (y/n/cancel)")
	local input = string.lower(read())
	if input == "y" then
		onDisk = true
	elseif input == "n" then
		onDisk = false
	elseif input == "cancel" then
		goto abort
	else
		print("Invalid Input: '" .. input .. "' try again.")
		goto diskInstall
	end
end

fs.delete("chocolat/")

-- get all the files to root
for i = 1, #URLS do
	shell.run("wget " .. URLS[i])
end

if onDisk then
	fs.move("klib.lua", "disk/chocolat/lib/klib.lua")
	fs.move("chocolat.lua", "disk/chocolat/os/chocolat.lua")
	fs.move("startup.lua", "disk/chocolat/os/startup.lua")
	fs.move("update.lua", "disk/chocolat/os/update.lua")
end

fs.move("klib.lua", "chocolat/lib/klib.lua")
fs.move("chocolat.lua", "chocolat/os/chocolat.lua")
fs.move("startup.lua", "chocolat/os/startup.lua")
fs.move("update.lua", "chocolat/os/update.lua")

while true do
	if rebootTimer == 0 then
		break
	end

	print("Rebooting in " .. rebootTimer)
	rebootTimer = rebootTimer - 1
	sleep(1)
end

os.reboot()

::abort::
print("Aborted Update")