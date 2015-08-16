_ = require "prelude-ls"


d3.selectAll '#map'
	.style {
		"height": "800px"
		"width": "1200px"
	}

styles = undefined

map = new L.map "map", {center: [25.0172264, 121.506378], zoom: 12}
ggl = new L.Google 'ROADMAP', { mapOptions: { styles: styles} }
map.addLayer ggl


svg = d3.select(map.getPanes!.overlayPane).append "svg"
g = svg.append "g"
	.attr {
		"class": "leaflet-zoom-hide"
	}

# err, data <- d3.json "./data/臺北市受保護樹木.json"
# # err, data <- d3.json "./data/306.json"
err, data <- d3.json "./data/taipeiCOUNTY.json"
data = topojson.feature data, data["objects"]["VILLAGE"]


projectPoint = (x, y)->
	point = map.latLngToLayerPoint new L.LatLng y, x
	@stream.point(point.x, point.y)


transform = d3.geo.transform {point: projectPoint}
path = d3.geo.path!.projection transform


feature = g.selectAll "path"
	.data data.features
	.enter!
	.append "path"
	.attr {
		"class": "area"
	}
	.style {
		"fill": "none"
	}

resetview = ->
	bounds = path.bounds data
	topLeft = bounds[0]
	bottomRight = bounds[1]

	svg
		.attr {
			"width": bottomRight[0] - topLeft[0]
			"height": bottomRight[1] - topLeft[1]
		}
		.style {
			"left": topLeft[0] + "px"
			"top": topLeft[1] + "px"
		}

	g
		.attr {
			"transform": "translate(" + (-topLeft[0]) + "," + (-topLeft[1]) + ")"
		}

	feature
		.attr {
			"d": path
		}
		.style {
			"stroke": "red"
			"stroke-width": "5px"
		}
	
resetview!
map.on("viewreset", resetview)


# err, fillData <- d3.csv "./data/2012_立法委員選舉_台北.csv"

# vote_data = fillData
# |> _.map (->
# 	# it["地區"] = it["地區"].replace "臺北", "台北"
# 	it["得票率"] = +((it["得票率"].split "%")[0])
# 	it
# 	)
# |> _.group-by (-> it["地區"])
# |> _.Obj.map (->
# 	k = null
# 	d = null
# 	it |> _.map ((c)->
# 		if c["政黨"] is "中國國民黨" then k := c
# 		if c["政黨"] is "民主進步黨" then d := c
# 		)
# 	k["得票率"] - d["得票率"]
# 	)



# color = d3.scale.linear!
# 	.domain [-50, 50]
# 	.range ["green", "blue"]
# 	.interpolate(d3.interpolateLab)


# feature
# 	.style {
# 		"fill": -> 
# 			p = it["properties"]
# 			n = p["COUNTY"] + p["TOWN"] + p["VILLAGE"]
# 			color vote_data[n]
# 		"opacity": 0.5
# 	}