local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")
local typedefs = require "kong.db.schema.typedefs"

return {
  name = plugin_name,
  fields = {
    {
      config = {
        type = "record",
        fields = {
          { xml_src = { type = "string", required = true, default = "body"}},		
          { transforms = { type = "array", required = true, default = {}, elements={
              type = "record",
              fields = {
                { xpath = { type = "string", required = true}},
                { transformer = { type = "string", required = true}},
		{ argument = { type = "string", required = true}}
              }
            }},
          },
        }
      }
    }
  }
}

