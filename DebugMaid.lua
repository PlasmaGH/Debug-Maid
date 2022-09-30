-- || HTTPs Requests must be Enabled
-- || Updates coming soon! <3

local StatService = game:GetService("Stats")
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService")

local InfoRemoteName = "GetServerInfo";
local InfoRemoteParent = game:GetService("ReplicatedStorage")

if RunService:IsServer() then

	local ServerData = HttpService:JSONDecode(HttpService:GetAsync("http://ip-api.com/json/"))
	local ServerLocation = ServerData and require(script["GetRegionFromLongitude"])(ServerData.lon) or "Unknown";

	if InfoRemoteParent:FindFirstChild(InfoRemoteName) == nil then -- Create ping RemoteFunction.

		local RemoteFUNC = Instance.new("RemoteFunction")
		RemoteFUNC.Name = InfoRemoteName;
		RemoteFUNC.Parent = InfoRemoteParent;

		RemoteFUNC.OnServerInvoke = function(player, method)
			if method == "p" then -- Ping
				return true;
			elseif method == "r" then -- Region
				return ServerLocation;
			end
		end

	end;

elseif RunService:IsClient() then

	local Debug_UI = script:WaitForChild("Debug-UI"):Clone();
	Debug_UI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

	local ServerInfoRemote:RemoteFunction = InfoRemoteParent:WaitForChild(InfoRemoteName);
	local serverLocation = ServerInfoRemote:InvokeServer("r");

	Debug_UI.ServerLocation.Text = tostring(serverLocation or "Unknown");

	task.spawn(function()
		while true do
			local ping = os.clock();
			ServerInfoRemote:InvokeServer('p');
			Debug_UI.Ping.Text = ("%s MS"):format(tostring((math.floor(((os.clock() - ping) * 1000) * 100) / 100)));
			Debug_UI.Fps.Text = ("%s FPS"):format(tostring(math.floor(workspace:GetRealPhysicsFPS() * 100) / 100))
			Debug_UI.Mem.Text = ("%s MEM (MB)"):format(StatService:GetTotalMemoryUsageMb());
			Debug_UI.Res.Text = ("X: %s Y: %s"):format(Mouse.ViewSizeX, Mouse.ViewSizeY)
			task.wait(1);
		end
	end)

end

return {}
