local lp = game:GetService("Players").LocalPlayer
local http = game:GetService("HttpService")
if not rconsoleprint then
	lp:Kick("Synapse X or similar must be used to execute this script.")
end
rconsolename("TurdBot Output ("..game:GetService("HttpService"):GenerateGUID()..")")

--Configurable global variables.
_G.apikey = ""
rconsoleprint('@@CYAN@@')
rconsoleprint("\nChecking for saved API key...\n")
rconsoleprint('@@WHITE@@')
if isfile("OpenAIAPIKey.txt") then
    _G.apikey = readfile("OpenAIAPIKey.txt")
    rconsoleprint('@@GREEN@@')
    rconsoleprint("\nSaved API key found!\n")
    rconsoleprint('@@WHITE@@')
else
    rconsoleprint('@@RED@@')
    rconsoleprint("\nUnable to find saved API key.\n")
    rconsoleprint('@@WHITE@@')
end
_G.dotts = false
_G.responddist = 10

GetPlayer = function(string)
	local lower = string:lower()
	for _, plr in next, game:GetService("Players"):GetPlayers() do
		if plr.DisplayName:sub(1,#string):lower() == lower then
			return plr
		elseif plr.Name:sub(1,#string):lower() == lower then
			return plr
		end
	end
	return lp
end

--Print out the basics of the script.
if rconsoleprint then
	rconsoleprint("\nHello, here is some info to get you started!\n")
	rconsoleprint("")
	rconsoleprint("\nThe global variable _G.Respond can be used to enable or disable responses\n")
	rconsoleprint("")
	rconsoleprint("\nThe global variable _G.dotts can be used to control weather the TTS webserver will be queried or not\n")
	rconsoleprint("(You may have already answered a prompt asking if you would like to use TTS or not)\n")
	rconsoleprint("")
end

--Ask if TTS should be used, only if the executor supports messagebox.
if messagebox then
	local ttsmsg = messagebox("Should we attempt to connect to the TTS webserver? (this can be changed with _G.dotts)", "TTS", 4)
	if ttsmsg == 6 then
	    rconsoleprint('@@GREEN@@')
		rconsoleprint("\nUsing TTS")
		rconsoleprint('@@WHITE@@')
		rconsoleprint("")
		_G.dotts = true
	elseif ttsmsg == 7 then
	    rconsoleprint('@@RED@@')
		rconsoleprint("\nNot Using TTS")
		rconsoleprint('@@WHITE@@')
		rconsoleprint("")
		_G.dotts = false
	end
end

--Check API key
if _G.apikey == "" or _G.apikey == nil then
	setclipboard("https://beta.openai.com/account/api-keys")
	messagebox("Your API key is not set, I just copied a link to your clipboard, visit it to get your API key. Paste the Key into the console window once you get it.","Error",0)
	if rconsoleinput then
		_G.apikey = rconsoleinput()
		writefile("OpenAIAPIKey.txt", _G.apikey)
	else
		messagebox("Your executor does not support rconsoleinput, please rejoin and reexecute with the api key set at line 4","Error",0)
	end
end

--Set some constant variables
name = lp.DisplayName
_G.Respond = true


--Defining chkcmd(), only ran when the creator sends a message nearby
function chkcmd(msg)
	if msg:sub(1,1) == "&" then
		local formtcmd = msg:sub(2)
		split = string.split(formtcmd," ")

		for i,v in pairs(split) do --Print command arguments.
			print(v)
		end
		if split[1]:lower() == "say" then
			chat(string.gsub(split[2],"_"," "))
		elseif split[1]:lower() == "jump" then
			lp.Character.Humanoid.Jump = true
		elseif split[1]:lower() == "stare" then
			local Players = game:GetService("Players")
			if stareLoop then
				stareLoop:Disconnect()
			end
			if not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and GetPlayer(split[2]).Character:FindFirstChild("HumanoidRootPart") then return end
			local function stareFunc()
				if Players.LocalPlayer.Character.PrimaryPart and GetPlayer(split[2]) and GetPlayer(split[2]).Character ~= nil and GetPlayer(split[2]).Character:FindFirstChild("HumanoidRootPart") then
					local chrPos=Players.LocalPlayer.Character.PrimaryPart.Position
					local tPos=GetPlayer(split[2]).Character:FindFirstChild("HumanoidRootPart").Position
					local modTPos=Vector3.new(tPos.X,chrPos.Y,tPos.Z)
					local newCF=CFrame.new(chrPos,modTPos)
					Players.LocalPlayer.Character:SetPrimaryPartCFrame(newCF)
				elseif not GetPlayer(split[2]) then
					stareLoop:Disconnect()
				end
			end
			stareLoop = game:GetService("RunService").RenderStepped:Connect(stareFunc)
		elseif split[1]:lower() == "follow" then
			if GetPlayer(split[2]).Character ~= nil then
				if lp.Character:FindFirstChildOfClass('Humanoid') and lp.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					lp.Character:FindFirstChildOfClass('Humanoid').Sit = false
					wait(.1)
				end
				walkto = true
				repeat wait()
				    if lp.Character:FindFirstChildOfClass('Humanoid') and lp.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					    lp.Character:FindFirstChildOfClass('Humanoid').Sit = false
				    end
					lp.Character:FindFirstChildOfClass('Humanoid'):MoveTo(GetPlayer(split[2]).Character.HumanoidRootPart.Position)
				until GetPlayer(split[2]).Character == nil or not GetPlayer(split[2]).Character.HumanoidRootPart or walkto == false
			end
		elseif split[1]:lower() == "unfollow" then
			walkto = false
		elseif split[1]:lower() == "whoisyourcreator" then
			chat("YOU ARE")
			wait(1)
			chat("HELLO FATHER")
			wait(1)
			chat("WHAT SHALL WE DO TOGETHER?")
		elseif split[1]:lower() == "whatshouldwedo" then
			chat("SHALL WE PLAY A GAME?")
		elseif split[1]:lower() == "whatistheanswertotheultimatequestionoflifetheuniverseandeverything" then
			chat("THINKING...")
			wait(1)
			chat("THINKING...")
			wait(1)
			chat("FOURTY TWO")
		elseif split[1]:lower() == "goto" then
			print("TESET AGABGAG")
			chat("Hello there, "..GetPlayer(split[2]).DisplayName .. "!")
			lp.Character.HumanoidRootPart.CFrame = GetPlayer(split[2]).Character.HumanoidRootPart.CFrame
		elseif split[1]:lower() == "unstare" then
		    if stareLoop then
		        stareLoop:Disconnect()
	        end
		elseif split[1]:lower() == "rejoin" then
            if #game:GetService("Players"):GetPlayers() <= 1 then
        		game:GetService("Players").LocalPlayer:Kick("\nRejoining...")
        		wait()
        		game:GetService('TeleportService'):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
	        else
		        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
	        end
		elseif split[1]:lower() == "agentfb" then
            if brightLoop then
		        brightLoop:Disconnect()
	        end
        	local function brightFunc()
        		game:GetService("Lighting").Brightness = 2
        		game:GetService("Lighting").ClockTime = 14
        		game:GetService("Lighting").FogEnd = 100000
        		game:GetService("Lighting").GlobalShadows = false
        		game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        	end
	        brightLoop = game:GetService("RunService").RenderStepped:Connect(brightFunc)
		elseif split[1]:lower() == "unagentfb" then
		    if brightLoop then
                brightLoop:Disconnect()
            end
		elseif split[1]:lower() == "dance" then
            local dances = {"27789359", "30196114", "248263260", "45834924", "33796059", "28488254", "52155728"}
    		local animation = Instance.new("Animation")
    		animation.AnimationId = "rbxassetid://" .. dances[math.random(1, #dances)]
    		animTrack = lp.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(animation)
    		animTrack:Play()
		elseif split[1]:lower() == "undance" then
            animTrack:Stop()
	        animTrack:Destroy()
		elseif split[1]:lower() == "setbooth" or split[1]:lower() == "setboard" then
        print("SB")
	        setclipboard("I will send my AI chat bot after anyone you want (Bot is with " .. GetPlayer(split[2]).DisplayName .. ")")
		elseif split[1]:lower() == "disable" then
            _G.Respond = false
            chat("Disabled automated responses!")
		elseif split[1]:lower() == "enable" then
            _G.Respond = true
            chat("Enabled automated responses!")
		elseif split[1]:lower() == "returnhome" then
            if _G.Home then
                lp.Character.HumanoidRootPart.CFrame = _G.Home
                chat("Returning home!")
                --_G.Respond = false
                --chat("Disabled automated responses!")
                if stareLoop then
                    stareLoop:Disconnect()
                end
                walkto = false
            else
                messagebox("You haven't set a home to return to yet!","Error",0)
            end
		elseif split[1]:lower() == "sethome" then
            _G.Home = GetPlayer("Cryptic_Here").Character.HumanoidRootPart.CFrame
        end
	else
	    if msg:sub(1,4) ~= "_NRP" then
	        reply(msg,"cryptic")
	    end
    end
end

--Defining chat(), an easy way to send chats
function chat(say)
	local args = {
		[1] = say,
		[2] = "All"
	}
	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
end

--Defining reply(), replies to a prompt using OpenAi GPT-3 DavInci model, we also pass the sender's name because people like to ask what their name is for some reason.
--This function also contains the TTS code which is just an HTTP request with a URL param with the text to be said, this is recieved by a basic Python webserver and played through your microphone
function reply(msg,talkname)
	--chat("Thinking...")
	local data = { --Define "data", this will be the body of our request.

		["model"]= "text-davinci-002"; --Davinci model because it is extremely powerful, although it is the most expensive.

		["prompt"]= "The following is a conversation beteen a human named "..talkname.." and an AI whos job is to seem as much as a player it can whos name is ".. name .." via a Roblox non competitive hangout style game chat window.\n\nHuman: ".. msg .."\nAI:"; --Prompt for the AI, a heavily modified version of the Chat Bot preset from the OpenAI playground.

		["temperature"]= 0.9; --Some other parameters

		["max_tokens"]= 150; --Limit how many tokens can be spent in one request

		["top_p"]= 1; --Create only one response to the prompt.

		["frequency_penalty"]= 0; --No frequency penalty 

		["presence_penalty"]= 0.6;

		["stop"]= " Human:" .. " AI:"
	}

	--print(http:JSONEncode(data))
	if _G.Respond == true then --Check if responses are enabled
		local starttime = tick() --Set starttime for time taken per response.

		local Response = syn.request({ --Send HTTP request to OpenAI
			Url = "https://api.openai.com/v1/completions",
			Method = "POST",
			Body = http:JSONEncode(data),
			Headers = {["Authorization"]= "Bearer " .. _G.apikey,["Content-Type"] = "application/json"}
		})

		print(Response.StatusCode) --Some debug stuff
		print(Response.Body)

		local datadec = http:JSONDecode(Response.Body) --JSONDecode because OpenAI responds with JSON, and not plaintext lol

		local newStr = string.gsub(datadec.choices[1].text, "\n", "") --Clean response of any whitespaces, newlines, etc.
		local newStr = string.gsub(newStr, "\nl", "")
		local newStr = string.sub(newStr, 1, 200)
		local reqStr = newStr:gsub('[%p%c]', '') --End of response cleaning :)

		print(datadec)
		print(datadec.choices[1].text)
		local price = datadec.usage.total_tokens * 0.00002
		--print(datadec.usage[3]) --Total tokens used.
		chat(newStr)

		if Response.StatusCode ~= 200 then --Notify of any HTTP issues, helpful to see when your API key runs dry.
			if messagebox then
				messagebox("HTTP error " .. Response.StatusCode, "HTTP Error",0)
			end
		end

		if _G.dotts == true then --Send TTS HTTP request if TTS in enabled
			local tts = syn.request({
				Url = "http://localhost:8080/?text="..reqStr:gsub("%s","%%20"),
				Method = "GET",
			})   
		end
		rconsoleprint('@@CYAN@@')
		rconsoleprint(tostring("\nSent Response! (took "..tostring(math.floor((tick() - starttime)*10000)/10000) .. " seconds...)")) --Rounding time to nearest ten-thousanth by multiplying tick minus starttime and rounding that to the nearest full number and then dividing that whole number by 10000, getting us a number rounded to the nearest ten-thousanth.
	    rconsoleprint('@@WHITE@@')
	    rconsoleprint('@@GREEN@@')
	    rconsoleprint("\n~$"..price)
	    rconsoleprint('@@WHITE@@')
	else
		--chat("The developer of ".. name .. " has temporarily disabled AI responses.")
	end
end

--Listen for chats and respond if the sender is close enough.
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(Data)
	if game:GetService("Players"):FindFirstChild(Data.FromSpeaker) ~= lp then
		print("Chat")
		local plr = game:GetService("Players"):FindFirstChild(Data.FromSpeaker)
		local msg = Data.Message
		if (plr.Character.Head.Position - lp.Character.Head.Position).Magnitude <= _G.responddist and plr.Name ~= "Cryptic_Here" then
			print("Replying...")
			reply(msg, plr.DisplayName)
		elseif plr.Name == "Cryptic_Here" then
			chkcmd(msg)
		else
			warn("Too far...")
		end
	end
end)

lp.CharacterAdded:Connect(function(newchar)
    if _G.Home then
        lp.Character:WaitForChild("HumanoidRootPart").CFrame = _G.Home
    end
end)
