package = "kong-plugin-xml2json-advanced"

version = "1.0.0-1"

supported_platforms = {"linux"}

source = {
  url = "https://github.com/Platformatory/kong-xml2json-advanced",
}

description = {
  summary = "XML2JSON Advanced enables creating declarative facades to legacy APIs through controlled XML manipulation",
  license = "MIT",
  maintainer = "Kong"
}

dependencies = {

}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.xml2json-advanced.handler"] = "kong/plugins/xml2json-advanced/handler.lua",
    ["kong.plugins.xml2json-advanced.schema"] = "kong/plugins/xml2json-advanced/schema.lua",
  }
}
