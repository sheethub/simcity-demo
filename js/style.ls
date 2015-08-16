_ = require "prelude-ls"

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

	map = new google.maps.Map(document.getElementById('map'), mapOptions)
	map


trafficLayer = ->
	trafficLayer = new google.maps.TrafficLayer!
	trafficLayer.setMap map


terrainMap = ->
	map.setMapTypeId google.maps.MapTypeId.TERRAIN

hybridMap = ->
	map.setMapTypeId google.maps.MapTypeId.HYBRID


darkMap = ->
	map.setMapTypeId('darkMap')

# # ###heatmap

styleOption = {
	"pinkMap": [{"featureType": "all","stylers": [{"hue": '#BB1ABB'}]}],
	"removeLabel": {"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},
	"removeFill": {"featureType":"all","elementType":"geometry.fill","stylers":[{"visibility":"off"}]},
	"removeStroke": {"featureType":"all","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},


	"darkMap": [
		{"featureType":"all","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
		{"featureType":"all","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},
		{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},
	]
	"greenLandscape": [
		{"featureType":"landscape","elementType":"all","stylers":[{"visibility":"on"},{"color":'#30b29c'}]}
	]
	"comicsMap": [
		{"featureType":"all","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"color":'#000000'},{"weight":4.83}]},
		{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},
	]
	"darkWater": [
		{"featureType":"water","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#21445c'}]}
	]
	"blueWater": [
		{"featureType":"water","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#3887be'}]}
	]
	"redSchool": [
		{"featureType":"poi.school","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#e55e5e'}]},
		{"featureType":"poi.school","elementType":"labels","stylers":[{"visibility":"on"}]},
		{"featureType":"poi.school","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
		{"featureType":"poi.school","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":'#ffffff'},{"weight":4.62}]}
	]
	"greenPark": [
		{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#33ffd6'},{"saturation":5},{"lightness":-37}]},
		{"featureType":"poi.park","elementType":"labels","stylers":[{"visibility":"on"}]},
		{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
		{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":'#ffffff'},{"weight":4.62}]}
	]
	"transport": [
		{"featureType":"road.arterial","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"color":'#28353d'}]},
		{"featureType":"transit.line","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#fbb03b'},{"weight":4.55},{"lightness":3}]},
		{"featureType":"transit.station.bus","elementType":"labels","stylers":[{"visibility":"on"},{"color":'#3bb2d0'}]}
	]
	"government": [
		{"featureType":"poi.government","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#8a8acb'}]},
		{"featureType":"poi.government","elementType":"labels","stylers":[{"visibility":"on"}]},
		{"featureType":"poi.government","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
		{"featureType":"poi.government","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":'#ffffff'},{"weight":4.62}]}
	]
	"business": [
		{"featureType":"poi.business","elementType":"all","stylers":[{"visibility":"on"},{"color":'#b80eb8'},{"weight":0.27}]},
		{"featureType":"poi.business","elementType":"labels","stylers":[{"visibility":"on"}]},
		{"featureType":"poi.business","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
		{"featureType":"poi.business","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":'#ffffff'},{"weight":4.62}]}
	]
	"man_made": [
		{"featureType":"landscape.man_made","elementType":"all","stylers":[{"visibility":"on"},{"color":'#ffffff'}]}
	]
	"local_road": [
		{"featureType":"road.local","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"color":'#faf7fa'}]}
	]
	"building_stroke": [
		{"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"color":'#000000'},{"weight":1.8}]}
	]
	"high_tech": [
		{"featureType":"all","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
		{"featureType":"all","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"color":'#00ffff'}]},
		{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]}
	]
	"darkMapBuildingStroke": [
		{"featureType":"all","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":'#000000'}]},
		{"featureType":"all","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},
		{"featureType":"all","elementType":"labels","stylers":[{"visibility":"off"}]},
		{"featureType":"landscape.man_made","elementType":"geometry.stroke","stylers":[{"visibility":"on"},{"color":'#ffffff'}]}
	]
	"nullStyle": []
}


setMapStyle = (styleList)->
	styleList
	|> _.map (-> styleOption[it])
	|> _.flatten
	|> (-> map.setOptions {styles: it} )


pinkMap = ["pinkMap"]
darkMapBuildingStroke = ["darkMapBuildingStroke"]
withPOI = ["darkMap" "greenPark" "business" "darkWater" "redSchool" "government"]
withTransport = ["darkMap" "darkWater" "transport"]
redSchool = ["darkMap" "darkWater" "redSchool"]
greenPark = ["darkMap" "greenPark" "blueWater"]
comicsMap = ["comicsMap"]
local_road = ["darkMap" "local_road"]
blueWater = ["darkMap" "blueWater"]  #####池塘
man_made = ["darkMap" "man_made" "blueWater"]
greenLandscape = ["darkMap" "greenLandscape"]
high_tech = ["high_tech"]
removeLabel = ["pinkMap" "removeLabel"]
removeStroke = ["pinkMap" "removeLabel" "removeStroke" "removeFill"]
removeFill = ["pinkMap" "removeLabel" "removeFill"]
nullStyle = ["nullStyle"]


map = initMap!


presentation = [
	nullStyle
	pinkMap
	removeLabel
	removeFill
	removeStroke
	greenLandscape
	blueWater
	greenPark

	man_made
	local_road
	darkMapBuildingStroke
	high_tech
	
	redSchool
	withTransport
]


i = -1

next = ->
	++i
	if i >= presentation.length then i := 0
	presentation[i] |> setMapStyle
	

prev = ->
	--i
	if i <= 0 then i := 0
	presentation[i] |> setMapStyle

	



document.onkeypress = ->
	e = e || window.event
	e.keyCode |> console.log 
	if e.keyCode is 13 then next!
	if e.keyCode is 112 then prev!
