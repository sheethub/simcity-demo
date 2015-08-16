var _;
_ = require("prelude-ls");
d3.json("./data/taipeiCOUNTY.json", function(err, data){
  var topo2Geo, map, mapOffset, svg, pathProjection, googleProjection, initMap, addOverlay, draw;
  topo2Geo = function(topoData, accessor){
    return topojson.feature(topoData, topoData["objects"][accessor]);
  };
  data = topo2Geo(data, "VILLAGE");
  map = null;
  mapOffset = 4000;
  svg = null;
  pathProjection = null;
  googleProjection = null;
  initMap = function(){
    var TaipeiLatLng, mapOptions;
    d3.selectAll('#map').style({
      "height": "800px",
      "width": "1200px"
    });
    TaipeiLatLng = new google.maps.LatLng(25.0216193, 121.5401722);
    mapOptions = {
      zoom: 13,
      center: TaipeiLatLng
    };
    map = new google.maps.Map(document.getElementById('map'), mapOptions);
    return map;
  };
  addOverlay = function(map){
    var overlay;
    overlay = new google.maps.OverlayView();
    overlay.onAdd = function(){
      return svg = d3.select(this.getPanes().overlayMouseTarget).append("svg").attr({
        "class": "svgOverlay",
        "width": mapOffset * 2,
        "height": mapOffset * 2
      }).style({
        "position": "absolute",
        "top": -1 * mapOffset + "px",
        "left": -1 * mapOffset + "px"
      }).append("g");
    };
    overlay.draw = function(){
      var projection;
      projection = this.getProjection();
      googleProjection = function(coordinates){
        var googleCoordinates, pixelCoordinates;
        googleCoordinates = new google.maps.LatLng(coordinates[1], coordinates[0]);
        pixelCoordinates = projection.fromLatLngToDivPixel(googleCoordinates);
        return [pixelCoordinates.x + mapOffset, pixelCoordinates.y + mapOffset];
      };
      pathProjection = d3.geo.path().projection(googleProjection);
      return draw(svg, pathProjection, data);
    };
    return overlay.setMap(map);
  };
  draw = function(svg, pathProjection, data){
    var d;
    d = svg.selectAll(".dots").data(data.features);
    d.attr({
      "d": pathProjection
    });
    return d.enter().append("path").attr({
      "d": pathProjection,
      "class": "dots"
    }).style({
      "stroke": function(it, i){
        return "red";
      },
      "fill": "none",
      "stroke-width": "1px"
    });
  };
  return addOverlay(
  initMap());
});