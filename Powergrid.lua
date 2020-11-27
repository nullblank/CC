--Pastebin code: 7GirYzrJ
-->>Dumbfucks Powergrid v1.2
-->>By: Nullblank
--
-->[About]
--The following is a lua script that displays the status
--of a given power grid between a battery and the amount of
--power flowing through a cable (Measured in RF)
--This script has an added GUI with a working grid bar
--that guages the aforementioned statistics
--
-->[Disclaimer]
--This 100% works but,
--this was made for fun.
--i was bored.

function conf() --Configures periperals
	print("[DumbFucks Power Grid v1.0]")
	print("Enter cable's side: ")
	pcab = side()
	print("Enter battery's side: ")
	pbat = side()
	print("Enter monitor's side: ")
	pmon = side()
	cable = peripheral.wrap(pcab)
	battery = peripheral.wrap(pbat)
	monitor = peripheral.wrap(pmon)
end

function side() --reusable side input
    local dir = {"left", "right", "top", "bottom", "front", "back"}
    for x = 1, 6, 1 do
			term.write(dir[x]..", ")
    end
	  print("")
    term.write(" >Enter side: ")
    local side = read()
    for x = 1, 6, 1 do
        if dir[x] == side then
            return dir[x]
        end
    end
    term.clear()
    term.setCursorPos("1, 1")
    print("[ERROR]")
    print("Not a valid side!")
    print("Please wait...")
    os.sleep(3)
end

function checkPower() --Takes the max capacity to turn the current value into %
	maxPowbat = battery.getMaxEnergy()
	curPowbat = battery.getEnergy()
	perPowbat = math.floor(((curPowbat/maxPowbat)*100)+0.5)
	
	maxPowgrid = cable.getEnergyCapacity()
	curPowgrid = cable.getEnergyStored()
	perPowgrid = math.floor(((curPowgrid/maxPowgrid)*100)+0.5)
end

function writeMon() --The title lol
	monitor.setBackgroundColor(colors.black)
	monitor.clear()
	monitor.setCursorPos(1, 1)
	title = "  [DumbFucks Power Grid v1.0]  "
	centerT(title, 1, colors.black, colors.white)
end

function centerT(text, line, backColor, txtColor) --Handy dandy center text thing
	monitor.setBackgroundColor(backColor)
	monitor.setTextColor(txtColor)
	length = (string.len(text))
	dif = math.floor(monitorX-length)
	x = math.floor(dif/2)
	monitor.setCursorPos(x+1, line)
	monitor.write(text)
end

function drawBar() --Draws a gridbar display based on the X Y coordinates of the terminal/monitor.
	--[Grid Bar]
	--
	gridstring = "Power Grid: "
	redg = (string.len(gridstring)) -- string reduction
	batstring = "Reserved Power: "
	redb = (string.len(batstring)) -- string reduction
	--
	--[Cable Bar]
	gridbar = math.floor(((curPowgrid/maxPowgrid)*(monitorX-2-redg))+0.5)
	--Draw Background Bar
	monitor.setCursorPos(2, 3)
	monitor.setBackgroundColor(colors.black)
	monitor.write(gridstring)
	monitor.setBackgroundColor(colors.lightGray)
	monitor.write(string.rep(" ", monitorX-2-redg))
	--Draw Percentage Bar
	monitor.setCursorPos(2, 3)
	monitor.setBackgroundColor(colors.black)
	monitor.write(gridstring)
	monitor.setBackgroundColor(colors.green)
	monitor.write(string.rep(" ", gridbar))
	--
	--[Battery Bar]
	batbar = math.floor(((curPowbat/maxPowbat)*(monitorX-2-redb))+0.5)
	--Draw Background Bar
	monitor.setCursorPos(2, 5)
	monitor.setBackgroundColor(colors.black)
	monitor.write(batstring)
	monitor.setBackgroundColor(colors.lightGray)
	monitor.write(string.rep(" ", monitorX-2-redb))
	--Draw Percentage Bar
	monitor.setCursorPos(2, 5)
	monitor.setBackgroundColor(colors.black)
	monitor.write(batstring)
	monitor.setBackgroundColor(colors.green)
	monitor.write(string.rep(" ", batbar))
end

-- Main method
conf() 
local maxPowgrid = 0 --Grid var
local curPowgrid = 0
local perPowgrid = 0 
local maxPowbat = 0 --Battery var
local curPowbat = 0
local perPowbat = 0
monitorX,monitorY = monitor.getSize()
while true do --the main tick
	checkPower()
	writeMon()
	drawBar()
	print(curPowbat .. "/" .. maxPowbat)
	sleep(1)
end