-- Import body transformer
local body_transformer = require "kong.plugins.xml2json-advanced.body_transformer"

local concat = table.concat
local kong = kong
local ngx = ngx

-- Grab pluginname from module name
local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

-- load the base plugin object and create a subclass
local Xml2JsonAdvancedHandler = require("kong.plugins.base_plugin"):extend()

-- constructor
function Xml2JsonAdvancedHandler:new()
  Xml2JsonAdvancedHandler.super.new(self, plugin_name)
end

function Xml2JsonAdvancedHandler:header_filter(conf)
  Xml2JsonAdvancedHandler.super.header_filter(self)

  --ngx.header["content-encoding"] = "none"
  ngx.header["content-type"] = "application/json"
  ngx.header["content-length"] = nil

end

---[[ runs in the 'access_by_lua_block'
function Xml2JsonAdvancedHandler:body_filter(config)
  Xml2JsonAdvancedHandler.super.body_filter(self)
  
 
  if is_xml_body(kong.response.get_header("Content-Type")) then
    local ctx = ngx.ctx
    local chunk, eof = ngx.arg[1], ngx.arg[2]

    ctx.rt_body_chunks = ctx.rt_body_chunks or {}
    ctx.rt_body_chunk_number = ctx.rt_body_chunk_number or 1

    if eof then
      local chunks = concat(ctx.rt_body_chunks)
      local body = body_transformer.transform_xml_body(conf, chunks)
      ngx.arg[1] = body or chunks

    else
      ctx.rt_body_chunks[ctx.rt_body_chunk_number] = chunk
      ctx.rt_body_chunk_number = ctx.rt_body_chunk_number + 1
      ngx.arg[1] = nil
    end
  end

end 

-- set the plugin priority, which determines plugin execution order
Xml2JsonAdvancedHandler.PRIORITY = 800

-- return our plugin object
return Xml2JsonAdvancedHandler

