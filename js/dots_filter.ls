_ = require "prelude-ls"


d3.selectAll '#map'
	.style {
		"height": "500px"
		"width": "500px"
	}

styles = 	[
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
	

map = new L.map "map", {center: [25.0172264, 121.506378], zoom: 14}
ggl = new L.Google 'ROADMAP', { mapOptions: { styles: styles} }
map.addLayer ggl


svg = d3.select(map.getPanes!.overlayPane).append "svg"
g = svg.append "g"
	.attr {
		"class": "leaflet-zoom-hide"
	}

err, data <- d3.json "./data/臺北市受保護樹木.json"


data.features.filter(-> 
	it.properties['description\/樹齡'] = +it.properties['description\/樹齡']
	true
	)


projectPoint = (x, y)->
	point = map.latLngToLayerPoint new L.LatLng y, x
	@stream.point(point.x, point.y)


transform = d3.geo.transform {point: projectPoint}
path = d3.geo.path!.projection transform


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


	p = g.selectAll "path"
		.data ageDim.top Infinity

	p
		.enter!
		.append "path"
		.attr {
			"class": "area"
		}
		.style {
			"fill": "none"
		}
		.attr {
			"d": path
		}
		.style {
			"fill": '#f1f075'
			"opacity": 0.2
		}

	p
		.exit!
		.remove!


map.on("viewreset", resetview)


#### crossfilter

filterDiv = dc.barChart '#filter'
ndx = crossfilter data.features
groupAll = ndx.groupAll!

ageDim = ndx.dimension( ->	~~(it.properties['description\/樹齡'] / 10) * 10)
# typDim = ndx.dimension( ->	it.properties['description\/樹種中文名'])
lngDim = ndx.dimension( -> it.geometry.coordinates[0] )
latDim = ndx.dimension( -> it.geometry.coordinates[1] )

ageGroup = ageDim.group!.reduceCount!
# typGroup = typDim.group!.reduceCount!


barWidth = 350
barHeight = 100
barMargin = {
	"top": 10,
	"right": 10,
	"left": 30,
	"bottom": 20
}


filterDiv.width barWidth
	.height 100
	.margins barMargin
	.dimension ageDim
	.group ageGroup
	.x(d3.scale.ordinal!.domain([0 to 100 by 10]))
	.xUnits(dc.units.ordinal)
	.elasticY true
	.colors '#f1f075'
	.on("filtered", (c, f)-> resetview!)
	.yAxis!
	.ticks 4

map.on "moveend", ->
	b = map.getBounds!
	lngDim.filterRange([b._southWest.lng, b._northEast.lng])
	latDim.filterRange([b._southWest.lat, b._northEast.lat])
	dc.redrawAll!

dc.renderAll!
resetview!