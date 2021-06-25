(function (d3) {
    'use strict';

    /*

      The DOM structure looks like this:

      <select>
        <option value="volvo">Volvo</option>
        <option value="saab">Saab</option>
        <option value="mercedes">Mercedes</option>
        <option value="audi">Audi</option>
      </select>

    */
	let last

    const dropdownMenu = (selection, props) => {
      const {
        options,
        onOptionClicked,
        selectedOption
      } = props;

      let select = selection.selectAll('select').data([null]);
      select = select.enter().append('select')
        .merge(select)
          .on('change', function() {
            onOptionClicked(this.value);
          });

      const option = select.selectAll('option').data(options);
      option.enter().append('option')
        .merge(option)
          .attr('value', d => d)
          .property('selected', d => d === selectedOption)
          .text(d => d);
    };

    const scatterPlot = (selection, props) => {
      const {
        xValue,
        xAxisLabel,
        yValue,
        circleRadius,
        yAxisLabel,
        margin,
        width,
        height,
        data
      } = props;

      const innerWidth = width - margin.left - margin.right;
      const innerHeight = height - margin.top - margin.bottom;

      const xScale = d3.scaleLinear()
        .domain(d3.extent(data, xValue))
        .range([0, innerWidth])
        .nice();

      const yScale = d3.scaleLinear();
      yScale.domain(d3.extent(data, yValue));
      yScale.range([innerHeight, 0]);
      yScale.nice();

      const g = selection.selectAll('.container').data([null]);
      const gEnter = g
        .enter().append('g')
          .attr('class', 'container');
      gEnter
        .merge(g)
          .attr('transform',
            `translate(${margin.left},${margin.top})`
          );

      const xAxis = d3.axisBottom(xScale)
        .tickSize(-innerHeight)
        .tickPadding(15);

      const yAxis = d3.axisLeft(yScale)
        .tickSize(-innerWidth)
        .tickPadding(10);

      const yAxisG = g.select('.y-axis');
      const yAxisGEnter = gEnter
        .append('g')
          .attr('class', 'y-axis');
      yAxisG
        .merge(yAxisGEnter)
          .call(yAxis)
          .selectAll('.domain').remove();

      const yAxisLabelText = yAxisGEnter
        .append('text')
          .attr('class', 'axis-label')
          .attr('y', -93)
          .attr('fill', 'black')
          .attr('transform', `rotate(-90)`)
          .attr('text-anchor', 'middle')
        .merge(yAxisG.select('.axis-label'))
          .attr('x', -innerHeight / 2)
          .text(yAxisLabel);


      const xAxisG = g.select('.x-axis');
      const xAxisGEnter = gEnter
        .append('g')
          .attr('class', 'x-axis');
      xAxisG
        .merge(xAxisGEnter)
          .attr('transform', `translate(0,${innerHeight})`)
          .call(xAxis)
          .selectAll('.domain').remove();

      const xAxisLabelText = xAxisGEnter
        .append('text')
          .attr('class', 'axis-label')
          .attr('y', 75)
          .attr('fill', 'black')
        .merge(xAxisG.select('.axis-label'))
          .attr('x', innerWidth / 2)
          .text(xAxisLabel);


      const circles = g.merge(gEnter)
        .selectAll('circle').data(data);
      circles
        .enter().append('circle')
          .attr('cx', innerWidth / 2)
          .attr('cy', innerHeight / 2)
          .attr('r', 0)
        .merge(circles)
        .transition()
        .delay((d, i) => i * 2)
          .attr('cy', d => yScale(yValue(d)))
          .attr('cx', d => xScale(xValue(d)))
          .attr('r', circleRadius);
		d3.selectAll('circle').filter(function(d, i) {return i > last - 1}).remove()
    };

    const svg = d3.select('svg');
    const width = +svg.attr('width');
    const height = +svg.attr('height');

    let data;
    let xColumn;
    let yColumn;
	let year = "2017"
	let half = "firstHalf"

    const onXColumnClicked = column => {
      xColumn = column;
      render();
    };

	const onYearColumnClicked = column => {
		year = column
		scatterLoadData()
		linearLoadData()

	}
	const onHalfColumnClicked = column => {
		half = column
		scatterLoadData()
		linearLoadData()
	}

    const render = () => {

      d3.select('#x-menu')
        .call(dropdownMenu, {
          options: data.columns,
          onOptionClicked: onXColumnClicked,
          selectedOption: xColumn


        });

		d3.select("#year")
		.call(dropdownMenu, {
			options: ['2017', '2018', '2019', '2020', '2021'],
			onOptionClicked: onYearColumnClicked,
			selectedOption: year
		});

	d3.select("#half")
		.call(dropdownMenu, {
			options: ['firstHalf', 'secondHalf'],
			onOptionClicked: onHalfColumnClicked,
			selectedOption: half
		});


      svg.call(scatterPlot, {
        xValue: d => d[xColumn],
        xAxisLabel: xColumn,
        yValue: d => d[yColumn],
        circleRadius: 10,
        yAxisLabel: data.columns[0],
        margin: { top: 20, right: 100, bottom: 96, left: 140 },
        width,
        height,
        data
      });
    };
	function linearLoadData() {
		if (year == 2021)
			half = "firstHalf"
		let file = "https://localhost:8080/"+ half + '_' +   year + '.html'
		d3.select(".bottom-left").select("iframe").attr("src", file)
	}
	function scatterLoadData() {
		if (year == 2021)
			half = "firstHalf"
		let file = 'https://raw.githubusercontent.com/jun-yu172/h-data/main/' + half + '_' +   year +'.csv'
		d3.csv(file)
		.then(loadedData => {
			data = loadedData;
			data.forEach(d => {
				d.tempHigh = +d.tempHigh;
				d.tempAvg = +d.tempAvg;
				d.VPAvg = +d.VPAvg;
				d.RHAvg = +d.RHAvg;
				d.groundTempAvg = +d.groundTempAvg;
				d.temp_5 = +d.temp_5;
				d.temp1_5 = +d.temp1_5;
			});
			last = data.length
			render();
		});
	}

    d3.csv('https://raw.githubusercontent.com/jun-yu172/h-data/main/firstHalf_2017.csv')
      .then(loadedData => {
        data = loadedData;
        data.forEach(d => {
            d.tempHigh = +d.tempHigh;
            d.tempAvg = +d.tempAvg;
            d.VPAvg = +d.VPAvg;
            d.RHAvg = +d.RHAvg;
            d.groundTempAvg = +d.groundTempAvg;
            d.temp_5 = +d.temp_5;
            d.temp1_5 = +d.temp1_5;
        });

        xColumn = data.columns[4];
        yColumn = data.columns[0];
		last = data.length
        render();
      });

  }(d3));

