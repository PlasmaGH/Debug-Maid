-- Parent = maid
return function(longitude) -- Logic by: Wravager

	if not longitude then
		return "Unknown";
	end

	if(longitude>-180 and longitude<=-105)then
		return "West US"
	elseif(longitude>-105 and longitude<=-90)then
		return "Central US"
	elseif(longitude>-90 and longitude<=0)then
		return "East US"
	elseif(longitude<=75 and longitude>0)then
		return "Europe"
	elseif(longitude<=180 and longitude>75)then
		return "Australia"
	else
		return "Unknown"
	end

end
