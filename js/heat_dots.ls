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
osm = new L.tileLayer 'http://{s}.tile.thunderforest.com/transport-dark/{z}/{x}/{y}.png'
# 'http://{s}.tile.osm.org/{z}/{x}/{y}.png'
map.addLayer osm

# ggl = new L.Google 'ROADMAP', { mapOptions: { styles: styles} }



err, data <- d3.json "./data/臺北市受保護樹木.json"

data = data["features"]
|> _.map (->
	c = it["geometry"]["coordinates"]
	return [c[1], c[0]]
	)


L.heatLayer data, {"radius": 50} .addTo map



