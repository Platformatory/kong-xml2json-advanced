local plugin_name = "xml2json-advanced"
local helpers = require "spec.helpers"

for _, strategy in helpers.each_strategy() do
  describe("XML2JSON Advanced", function()

    local bp = helpers.get_db_utils(strategy)

    setup(function()

      local xml_service = bp.services:insert {
        name = "XMLService",
        url = "http://httpbin.org" -- Dummy
      }

      local xml_route = bp.routes:insert({
        paths = { "/xml-upstream" },
        service = { id = xml_service.id }
      })

      local auth_plugin = assert(bp.plugins:insert({
        name     = "xml2json-advanced",
        route = { id = xml_route.id },
        config   = {
      		   
        },
      }))


      -- start Kong with your testing Kong configuration (defined in "spec.helpers")
      assert(helpers.start_kong( { plugins = "bundled,xml2json-advanced" }))
      admin_client = helpers.admin_client()

    end)

    teardown(function()
      if admin_client then
        admin_client:close()
      end

      helpers.stop_kong()
    end)

    before_each(function()
      proxy_client = helpers.proxy_client()

    end)

    after_each(function()
      if proxy_client then
        proxy_client:close()
      end
      if proxy_ssl_client then
        proxy_ssl_client:close()
      end
    end)

    describe("Happy Path - XML2JSON Advanced", function()

      it("should remove configured xpath", function()
      
      end)

      it("should prepend to configured xpath with JSON literal in args", function()

      end)

      it("should append to configured xpath with JSON literal in args", function()

      end)

      it("should replace to configured xpath with JSON literal in args", function()

      end)      

    end)
  end)
end
