function dim2px(dim) {
  return parseInt(dim.substring(0,dim.length - 2), 10);
}

function dimensions(d3sel) {
  var cstyle = window.getComputedStyle(d3sel.node());
  var widthStr = cstyle.width, heightStr = cstyle.height;
  var width = dim2px(widthStr);
  var height = dim2px(heightStr);
  return [width, height];
}

var fig1 = d3.select('#fig1');

var figWidth, figHeight;
[fig1Width, fig1Height] = dimensions(fig1);

var nodes = [
    {name: 'alpha', n_objects: 3},
    {name: 'beta', n_objects: 4},
    {name: 'charlie', n_objects: 5}
  ];

var names = nodes.map(node => node.name);
var max_objects = nodes.reduce(
  (acc, node) => Math.max(acc, node.n_objects), 0);

console.log(max_objects);

var bandScale = d3.scaleBand()
  .domain(names)
  .range([0, fig1Width])
  .paddingOuter(0.5)
  .paddingInner(0.3);

fig1.selectAll('rect')
  .data(nodes)
  .enter()
  .append('rect')
  .attr('x', function(node) {
      return bandScale(node.name)
    })
  .attr('y', 100)
  .attr('width', bandScale.bandwidth())
  .attr('height', 100);

var fig2 = d3.select('#fig2');
