local HttpService = game:GetService("HttpService")

local SoundSearch = {}

local url = "https://rprxy.xyz/proxy/api/searchmusic/"

function SoundSearch:Search(input)
	if not input then
		error("No input was given...")
	end
	
	
	local Songs = {}
	
	local t = nil
	
	for i = 1,10 do --We will retry 10 times.
		local success, msg = pcall(function()
			t = HttpService:RequestAsync({
				["Url"] = url..input, -- My UID
				["Method"] = "GET"
			})
		end)
		if success and t then
			break
		else
			warn(msg)
		end
		wait(1)
	end
	
	if not t then
		return Songs
	end
	
	local decodedT = HttpService:JSONDecode(t.Body)
	
	for _, song in ipairs(decodedT) do --Returning a max of 100 songs.
		if #Songs == 100 then
			break
		end
		
		if song.IsThumbnailUnapproved == false then --Checking if the song is moderated
			table.insert(Songs, song.AssetId)
		end
	end
	
	return Songs	
end

return SoundSearch
