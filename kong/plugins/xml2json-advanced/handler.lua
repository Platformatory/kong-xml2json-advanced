local concat = table.concat
local kong = kong
local ngx = ngx


local Xml2JsonAdvancedHandler = {
  PRIORITY = 800,
  VERSION = "1.0.0.1",
}


function Xml2JsonAdvancedHandler:response(conf)
end


return Xml2JsonAdvancedHandler
