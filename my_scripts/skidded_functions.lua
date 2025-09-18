local src = ""
local CoreGui = game:GetService("StarterGui")

pcall(function() 
    src = game:HttpGet("https://rawscripts.net/raw/Universal-Script-Integrated-GUI-40017", false)
end)
if src == "" then
  CoreGui:SetCore("SendNotification", {
  	Title = "outage";
  	Text = "scriptblox is unavailable. using offline version";
	  Duration = 5;
  })
  src = game:HttpGet("https://pastefy.app/2ZNljEse/raw", false)
end

loadstring(src)()
