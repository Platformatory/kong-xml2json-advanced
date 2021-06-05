# Plugin Overview

This plugin allows configuration against routes or services with an array of tuples of an xpath, (callable) Lua transformation function and an argument (a JSON literal supported now); Each transformation results in an update of the XML document in the req/response, applied serially. Finally the updated structure is serialized as JSON and sent on it's way.

# Use-cases

Enable building API facades from legacy upstream APIs. Process the XML with a library of transformation functions in Lua and wrangle it the desired JSON. 

# Development

- Setup kong-pongo locally
- To up your development environment, run ```pongo up --expose```
- You can manipulate Kong manually in it's container: Get a shell into the container via ```pongo shell```; Subsequently, you can ```kong migrations bootstrap``` and ```kong start``` to start kong.
- You can run local spec tests with busted or with ```pongo run```. You can also debug with ```pongo logs -f```
- A basic test scaffold is in ```spec/```
- For convenience, you can run Konga. Bring it up with ```docker-compose up -d```. Configure the Kong Admin URL on the host with ```http://host.docker.internal:8001```

