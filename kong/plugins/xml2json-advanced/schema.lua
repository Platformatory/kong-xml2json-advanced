local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")
local typedefs = require "kong.db.schema.typedefs"

local string_array = {
  type = "array",
  default = {},
  required = true,
  elements = { type = "string" },
}


local colon_string_array = {
  type = "array",
  default = {},
  required = true,
  elements = { type = "string", match = "^[^:]+:.*$" },
}


local string_record = {
  type = "record",
  fields = {
    { json = string_array },
    { headers = string_array },
  },
}


local colon_string_record = {
  type = "record",
  fields = {
    { json = colon_string_array },
    { json_types = {
      type = "array",
      default = {},
      required = true,
      elements = {
        type = "string",
        one_of = { "boolean", "number", "string" }
      }
    } },
    { headers = colon_string_array },
  },
}


return {
  name = "xml2json-advanced",
  fields = {
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { transforms = colon_string_record },
        },
      },
    },
  },
}
