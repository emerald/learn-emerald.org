function dim2px(dim) {
  return parseInt(dim.substring(0,dim.length - 2), 10);
}

function dimensions(d3sel) {
  var cstyle = window.getComputedStyle(d3sel.node());
  var width_str = cstyle.width, height_str = cstyle.height;
  var width = dim2px(width_str);
  var height = dim2px(height_str);
  return [width, height];
}

var fig1 = d3.select('#fig1');

console.log(dimensions(fig1));

fig1.append('rect')
  .attr('x', 100)
  .attr('y', 100)
  .attr('width', 100)
  .attr('height', 100);

var fig2 = d3.select('#fig2');
