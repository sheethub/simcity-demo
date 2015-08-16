_ = require "prelude-ls"


# err, data <- d3.json "./data/臺北市受保護樹木.json"
# err, data <- d3.json "./data/306.json"
err, data <- d3.json "./data/taipeiCOUNTY.json"


topo2Geo = (topoData, accessor)->
	topojson.feature topoData, topoData["objects"][accessor]

data = (topo2Geo data, "VILLAGE")


map = null
mapOffset  = 4000
svg = null
pathProjection = null
googleProjection = null



initMap = ->

	d3.selectAll '#map'
		.style {
			"height": "800px"
			"width": "1200px"
		}

	TaipeiLatLng = new google.maps.LatLng(25.0216193, 121.5401722)

	mapOptions = {
		zoom: 13,
		center: TaipeiLatLng
	}

	map := new google.maps.Map(document.getElementById('map'), mapOptions)
	# google.maps.event.addListener map, 'idle', ->
	map


addOverlay = (map)->

	overlay = new google.maps.OverlayView!

	overlay.onAdd = ->

		svg := d3.select @getPanes!.overlayMouseTarget
			.append "svg"
			.attr {
				"class": "svgOverlay"
				"width": mapOffset * 2
				"height": mapOffset * 2
			}
			.style {
				"position": "absolute"
				"top": -1 * mapOffset + "px"
				"left": -1 * mapOffset + "px"
			}
			.append "g"

	overlay.draw = ->
		# "ya" |> console.log 
		projection = @getProjection!

		googleProjection := (coordinates)->
			googleCoordinates = new google.maps.LatLng coordinates[1], coordinates[0]
			pixelCoordinates = projection.fromLatLngToDivPixel googleCoordinates
			[pixelCoordinates.x + mapOffset, pixelCoordinates.y + mapOffset]

		pathProjection := d3.geo.path!
			.projection googleProjection

		draw svg, pathProjection, data

	overlay.setMap map




draw = (svg, pathProjection, data)->

	d = svg
		.selectAll ".dots"
		.data data.features

	d
		.attr {
			"d": pathProjection
		}

	d
		.enter!
		.append "path"
			.attr {
				"d": pathProjection
				"class": "dots"
			}
			.style {
				"stroke": (it, i)->
					"red"
				"fill": "none"
				"stroke-width": "1px"
			}



initMap! |> addOverlay 