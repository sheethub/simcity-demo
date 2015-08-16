_ = require "prelude-ls"


d3.selectAll '#map'
	.style {
		"height": "800px"
		"width": "1200px"
	}

styles = [
	{"featureType":"all","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
	{"featureType":"all","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
	{"featureType":"all","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},
	{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},
	{"featureType":"water","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#152f40'}]},
	{"featureType":"poi","elementType":"labels","stylers":[{"visibility":"on"}]},
	{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":'#41afa6'}]},
	{"featureType":"poi","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":'#000000'}]}
	{"featureType":"administrative","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":'#41afa6'}]},
]
	

map = new L.map "map", {center: [25.0172264, 121.506378], zoom: 12}
ggl = new L.Google 'ROADMAP', { mapOptions: { styles: styles} }
map.addLayer ggl


svg = d3.select(map.getPanes!.overlayPane).append "svg"
g = svg.append "g"
	.attr {
		"class": "leaflet-zoom-hide"
	}

err, data <- d3.json "./data/306.json"


projectPoint = (x, y)->
	point = map.latLngToLayerPoint new L.LatLng y, x
	@stream.point(point.x, point.y)


transform = d3.geo.transform {point: projectPoint}
path = d3.geo.path!.projection transform


feature = g.selectAll ".base"
	.data data.features
	.enter!
	.append "path"
	.attr {
		"class": "base"
	}
	.style {
		"fill": "none"
	}

featureM = g.selectAll ".move"
	.data data.features
	.enter!
	.append "path"
	.attr {
		"class": "move"
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

	blow = ->
		it
			.attr {
				"stroke-dasharray": -> 50 + " " + @.getTotalLength!
				"stroke-dashoffset": -> 50
			}
			.transition!
			.ease 'linear'
			.duration 6000
			.attr {
				"stroke-dashoffset": -> @.getTotalLength! + 50
			}
			.each "end", -> d3.select @ .call blow

	featureM
		.attr {
			"d": path
		}
		.style {
			"stroke": 'white'
			"stroke-width": "4px"
		}
		.call blow

	feature
		.attr {
			"d": path
		}
		.style {
			"stroke": '#f1f075'
			"stroke-width": "2px"
		}


	
resetview!
map.on("viewreset", resetview)

