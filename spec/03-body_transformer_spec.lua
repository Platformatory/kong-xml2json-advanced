local body_transformer = require "kong.plugins.xml2json-advanced.body_transformer"
local cjson = require("cjson.safe").new()
cjson.decode_array_with_array_mt(true)

describe("Plugin: xml2json-advanced", function()
  describe("transform_xml_body()", function()
    describe("add", function()
      local conf = {
        remove   = {
          json   = {},
        },
        replace  = {
          json   = {}
        },
        add      = {
          json   = {"p1.p8:v8", "p3:value:3", "p4:\"v1\"", "p5:-1", "p6:false", "p7:true"},
          json_types = {"string", "string", "string", "number", "boolean", "boolean"}
        },
        append   = {
          json   = {}
        },
      }

      it("parameter", function()
        local xml = [[<p2>v1</p2>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p1 = {p8 = "v8"}, p2 = "v1", p3 = "value:3", p4 = '"v1"', p5 = -1, p6 = false, p7 = true}, body_json)
      end)

    end)

    describe("append", function()
      local conf = {
        remove   = {
          json   = {}
        },
        replace  = {
          json   = {}
        },
        add      = {
          json   = {}
        },
        append   = {
          json   = {"p1:v1", "p3:\"v1\"", "p4:-1", "p5:false", "p6:true", "p8.p9:v8"},
          json_types = {"string", "string", "number", "boolean", "boolean", "string"}
        },
      }
      it("new key:value if key does not exists", function()
        local xml = [[<p2>v1</p2>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({ p2 = "v1", p1 = {"v1"}, p3 = {'"v1"'}, p4 = {-1}, p5 = {false}, p6 = {true}, p8 = {p9 = {"v8"}}}, body_json)
      end)
      it("value if key exists", function()
       local xml = [[<p1>v2</p1><p8><p9>v9</p9></p8>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({ p1 = {"v2","v1"}, p3 = {'"v1"'}, p4 = {-1}, p5 = {false}, p6 = {true}, p8 = {p9 = {"v9", "v8"}}}, body_json)
      end)
      it("value in double quotes", function()
        local xml = [[<p3>v2</p3>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p1 = {"v1"}, p3 = {"v2",'"v1"'}, p4 = {-1}, p5 = {false}, p6 = {true}, p8 = {p9 = {"v8"}}}, body_json)
      end)
      it("number", function()
        local xml = [[<?xml version='1.0' encoding='us-ascii'?>
          <p4>v2</p4>
        ]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p1 = {"v1"}, p3 = {'"v1"'}, p4={"v2", -1}, p5 = {false}, p6 = {true}, p8 = {p9 = {"v8"}}}, body_json)
      end)
      it("boolean", function()
        local xml = [[<?xml version='1.0' encoding='us-ascii'?>
          <p5>v5</p5>
          <p6>v6</p6>
        ]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p1 = {"v1"}, p3 = {'"v1"'}, p4={-1}, p5 = {"v5", false}, p6 = {"v6", true}, p8 = {p9 = {"v8"}}}, body_json)
      end)

    end)

    describe("remove", function()
      local conf = {
        remove   = {
          json   = {"p1", "p2"}
        },
        replace  = {
          json   = {}
        },
        add      = {
          json   = {}
        },
        append   = {
          json   = {}
        }
      }
      it("parameter", function()
        local xml = [[<?xml version='1.0' encoding='us-ascii'?>
          <p1>v1</p1>
          <p2>v1</p2>
        ]]
        local body = body_transformer.transform_xml_body(conf, xml)
        assert.equals("{}", body)
      end)

    end)

    describe("replace", function()
      local conf = {
        remove   = {
          json   = {}
        },
        replace  = {
          json   = {"p1:v2", "p2:\"v2\"", "p3:-1", "p4:false", "p5:true"},
          json_types = {"string", "string", "number", "boolean", "boolean"}
        },
        add      = {
          json   = {}
        },
        append   = {
          json   = {}
        }
      }
      it("parameter if it exists", function()
        local xml = [[<p1>v1</p1><p2>v1</p2>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p1 = "v2", p2 = '"v2"'}, body_json)
      end)
      it("does not add value to parameter if parameter does not exists", function()
        local xml = [[<p1>v1</p1>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p1 = "v2"}, body_json)
      end)
      it("double quoted value", function()
        local xml = [[<p2>v1</p2>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p2 = '"v2"'}, body_json)
      end)

      it("number", function()
        local xml = [[<p3>v1</p3>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p3 = -1}, body_json)
      end)
      it("boolean", function()
        local xml = [[<p4>v4</p4><p5>v5</p5>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p4 = false, p5 = true}, body_json)
      end)
    end)

    describe("remove, replace, add, append", function()
      local conf = {
        remove   = {
          json   = {"p1"}
        },
        replace  = {
          json   = {"p2:v2"}
        },
        add      = {
          json   = {"p3:v1"}
        },
        append   = {
          json   = {"p3:v2"}
        },
      }
      it("combination", function()
        local xml = [[<p1>v1</p1><p2>v1</p2>]]
        local body = body_transformer.transform_xml_body(conf, xml)
        local body_json = cjson.decode(body)
        assert.same({p2 = "v2", p3 = {"v1", "v2"}}, body_json)
      end)
    end)
  end)

  describe("is_xml_body()", function()
    it("is truthy when content-type application/xml passed", function()
      assert.truthy(body_transformer.is_xml_body("application/xml"))
      assert.truthy(body_transformer.is_xml_body("application/xml; charset=utf-8"))
    end)
    it("is truthy when content-type is multiple values along with application/xml passed", function()
      assert.truthy(body_transformer.is_xml_body("application/x-www-form-urlencoded, application/xml"))
    end)
    it("is falsy when content-type not application/xml", function()
      assert.falsy(body_transformer.is_xml_body("application/x-www-form-urlencoded"))
    end)
  end)

end)
