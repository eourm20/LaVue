var w = 310,
	h = 350;

var colorscale = d3.scale.category10();

//Legend titles
var LegendOptions = ['1일 후 최고기온 예측 모델','2일 후 최고기온 예측 모델','3일 후 최고기온 예측 모델','4일 후 최고기온 예측 모델','5일 후 최고기온 예측 모델','6일 후 최고기온 예측 모델','7일 후 최고기온 예측 모델'];

var d = [
  [
    {axis:"temp5Avg",value: Math.log2(1.15 +0.139679832)},
    {axis:"temp30Avg",value: 0},
    {axis:"sunlightTimeSum",value: Math.log2(1.15 +0.031189502)},
    {axis:"windMaxInstantDir",value: Math.log2(1.15 +0.00881525)},
    {axis:"windMaxDir",value: 0},
    {axis:"VPAvg",value: 0},
    {axis:"seaAPAvg",value: 0},
    {axis:"LocalAPAvg",value: Math.log2(1.15 +0.001802721)},
    {axis:"tempHigh",value: Math.log2(1.15 +0.808549304)},
    {axis:"RHAvg",value:0},
    {axis:"windAvg",value: 0},
    {axis:"RHMin",value: Math.log2(1.15 +0.037171291)},
    {axis:"windMax",value: Math.log2(1.15 +0.031625683)},
  ],[
    {axis:"temp5Avg",value: Math.log2(1.15 +0.208588786)},
    {axis:"temp30Avg",value: 0},
    {axis:"sunlightTimeSum",value: Math.log2(1.15 +0.032532146)},
    {axis:"windMaxInstantDir",value: Math.log2(1.15 +0.023073948)},
    {axis:"windMaxDir",value: 0},
    {axis:"VPAvg",value: Math.log2(1.15 +0.14134518)},
    {axis:"seaAPAvg",value: Math.log2(1.15 +0.024523033)},
    {axis:"LocalAPAvg",value: Math.log2(1.15 +0.006833214)},
    {axis:"tempHigh",value: Math.log2(1.15 +0.59357998)},
    {axis:"RHAvg",value: Math.log2(1.15 +0.019278778)},
    {axis:"windAvg",value: 0},
    {axis:"RHMin",value:0},
    {axis:"windMax",value: Math.log2(1.15 +0.023073948)},
  ],[
    {axis:"temp5Avg",value: Math.log2(1.15 +0.249472143)},
    {axis:"temp30Avg",value: 0},
    {axis:"sunlightTimeSum",value: Math.log2(1.15 +0.01621531)},
    {axis:"windMaxInstantDir",value: Math.log2(1.15 +0.037247041)},
    {axis:"windMaxDir",value: Math.log2(1.15 +0.013485724)},
    {axis:"VPAvg",value: Math.log2(1.15 +0.156638623)},
    {axis:"seaAPAvg",value: Math.log2(1.15 +0.037926659)},
    {axis:"LocalAPAvg",value: Math.log2(1.15 +0.0146254)},
    {axis:"tempHigh",value: Math.log2(1.15 +0.536753592)},
    {axis:"RHAvg",value: Math.log2(1.15 +0.031681688)},
    {axis:"windAvg",value: Math.log2(1.15 +0.027557121)},
    {axis:"RHMin",value: 0},
    {axis:"windMax",value: 0},
  ],[
    {axis:"temp5Avg",value: Math.log2(1.15 +0.26732703)},
    {axis:"temp30Avg",value: 0},
    {axis:"sunlightTimeSum",value: Math.log2(1.15 +0.012174362)},
    {axis:"windMaxInstantDir",value: Math.log2(1.15 +0.041261284)},
    {axis:"windMaxDir",value: Math.log2(1.15 +0.01647404)},
    {axis:"VPAvg",value: Math.log2(1.15 +0.168490887)},
    {axis:"seaAPAvg",value: Math.log2(1.15 +0.052102849)},
    {axis:"LocalAPAvg",value: Math.log2(1.15 +0.018632107)},
    {axis:"tempHigh",value: Math.log2(1.15 +0.499098327)},
    {axis:"RHAvg",value: Math.log2(1.15 +0.040037285)},
    {axis:"windAvg",value: Math.log2(1.15 +0.037406749)},
    {axis:"RHMin",value: 0},
    {axis:"windMax",value: 0},
  ],[
    {axis:"temp5Avg",value: Math.log2(1.15 +0.271446051)},
    {axis:"temp30Avg",value: 0},
    {axis:"sunlightTimeSum",value: Math.log2(1.15 +0.007513765)},
    {axis:"windMaxInstantDir",value: Math.log2(1.15 +0.042799757)},
    {axis:"windMaxDir",value: Math.log2(1.15 +0.017247152)},
    {axis:"VPAvg",value: Math.log2(1.15 +0.170339621)},
    {axis:"seaAPAvg",value: Math.log2(1.15 +0.060987949)},
    {axis:"LocalAPAvg",value: Math.log2(1.15 +0.020707219)},
    {axis:"tempHigh",value: Math.log2(1.15 +0.487152746)},
    {axis:"RHAvg",value: Math.log2(1.15 +0.043635076)},
    {axis:"windAvg",value: Math.log2(1.15 +0.041817222)},
    {axis:"RHMin",value: 0},
    {axis:"windMax",value: 0},
  ],[
    {axis:"temp5Avg",value: 0},
    {axis:"temp30Avg",value: Math.log2(1.15 +0.100732279)},
    {axis:"sunlightTimeSum",value:0},
    {axis:"windMaxInstantDir",value: Math.log2(1.15 +0.037915236)},
    {axis:"windMaxDir",value: Math.log2(1.15 +0.016482411)},
    {axis:"VPAvg",value: Math.log2(1.15 +0.241417736)},
    {axis:"seaAPAvg",value: Math.log2(1.15 +0.07839887)},
    {axis:"LocalAPAvg",value: Math.log2(1.15 +0.023869405)},
    {axis:"tempHigh",value: Math.log2(1.15 +0.604244351)},
    {axis:"RHAvg",value: Math.log2(1.15 +0.064502482)},
    {axis:"windAvg",value: Math.log2(1.15 +0.048593432)},
    {axis:"RHMin",value: 0},
    {axis:"windMax",value: 0},
  ],[
    {axis:"temp5Avg",value: 0},
    {axis:"temp30Avg",value: Math.log2(1.15 +0.097438944)},
    {axis:"sunlightTimeSum",value: 0},
    {axis:"windMaxInstantDir",value: Math.log2(1.15 +0.037625283)},
    {axis:"windMaxDir",value: Math.log2(1.15 +0.014234937)},
    {axis:"VPAvg",value: Math.log2(1.15 +0.249635922)},
    {axis:"seaAPAvg",value: Math.log2(1.15 +0.084058922)},
    {axis:"LocalAPAvg",value: Math.log2(1.15 +0.024746131)},
    {axis:"tempHigh",value: Math.log2(1.15 +0.593034684)},
    {axis:"RHAvg",value: Math.log2(1.15 +0.070119418)},
    {axis:"windAvg",value: Math.log2(1.15 +0.050445543)},
    {axis:"RHMin",value: 0},
    {axis:"windMax",value: 0},
  ]
 ];


//Options for the Radar chart, other than default
var mycfg = {
  w: w,
  h: h,
  maxValue: 1,
  levels: 10,
  ExtraWidthX: 600
}

//Call function to draw the Radar chart
//Will expect that data is in %'s
RadarChart.draw("#chart", d, mycfg);



////////////////////////////////////////////
/////////// Initiate legend ////////////////
////////////////////////////////////////////

var svg = d3.select('#body')
	.selectAll('svg')
	.append('svg')
	.attr("width", w+800)
	.attr("height", h)

//Create the title for the legend
var text = svg.append("text")
	.attr("class", "title")
	.attr('transform', 'translate(120,0)') 
	.attr("x", w - 20)
	.attr("y", 10)
	.attr("font-size", "12px")
	.attr("fill", "#404040")
	.text("Estimated % of variable");
		
//Initiate Legend	
var legend = svg.append("g")
	.attr("class", "legend")
	.attr("height", 100)
	.attr("width", 200)
	.attr('transform', 'translate(170,25)') 
	;
	//Create colour squares
	g = d3.select("#chart").select("svg").select("g")

	legend.selectAll('rect')
	  .data(LegendOptions)
	  .enter()
	  .append("rect")
	  .attr("x", w - 65)
	  .attr("y", function(d, i){ return i * 20;})
	  .attr("width", 10)
	  .attr("height", 10)
	  .style("fill", function(d, i){ return colorscale(i);})
    .on('mouseover', function(d, i){
    		g.select("polygon.radar-chart-serie"+i)
					.transition(200)
					.style("fill-opacity", .9);
    		h = "circle.radar-chart-serie"+i
  			g.selectAll("circle")
					.transition(200)
					.style("fill-opacity", .3);
    		g.selectAll(h)
					.transition(200)
					.style("fill-opacity", 1);
  			})
  			
				
		.on("mouseout", function(d, i){ 
    		g.select("polygon.radar-chart-serie"+i)
					.transition(200)
					.style("fill-opacity", 0);
  			g.selectAll("circle")
      			.transition(200)
						.style("fill-opacity", 1); })
          
  
	//Create text next to squares
	legend.selectAll('text')
	  .data(LegendOptions)
	  .enter()
	  .append("text")
	  .attr("x", w - 52)
	  .attr("y", function(d, i){ return i * 20 + 9;})
	  .attr("font-size", "11px")
	  .attr("fill", "#737373")
	  .text(function(d) { return d; })
		.on('mouseover', function(d, i){
    		g.select("polygon.radar-chart-serie"+i)
					.transition(200)
					.style("fill-opacity", .9);
    		h = "circle.radar-chart-serie"+i
  			g.selectAll("circle")
					.transition(200)
					.style("fill-opacity", .3);
    		g.selectAll(h)
					.transition(200)
					.style("fill-opacity", 1);
  			})
  			
				
        .on("mouseout", function(d, i){ 
          g.select("polygon.radar-chart-serie"+i)
          .transition(200)
          .style("fill-opacity", 0);
          g.selectAll("circle")
            .transition(200)
            .style("fill-opacity", 1); })