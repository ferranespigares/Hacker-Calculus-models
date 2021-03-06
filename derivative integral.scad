xmin = -2;
xmax = 2;
step = (xmax - xmin) / 100;

c = 0;

xunit = 50;
thick = 2.4;

xmark = .2;


function f(x) = sin(x * 180 / PI) * 15;
function d(x) = cos(x * 180 / PI) * 15;

function f(x) = .5 * (pow(((x-5)), 3) + 126);
function d(x) = .5 * (3 * pow(((x-5)), 2));

function f(x) = 25 * (pow(((x)), 2)) + 0;
function d(x) = 25 * (2 * pow(((x)), 1));
/**/

x = [for(x = [xmin:step:xmax + step / 2]) x];
integral = integrate([for(x = x) d(x) * step], c);
	
$fs = .2;
$fa = 2;

translate([0, 0, xunit * xmax]) rotate([0, 90 ,0]) {
	difference() {
		union() {
			linear_extrude(thick, center = true) offset(xmax / 1000) offset(-xmax / 1000) polygon(concat([for(x = x) [x * xunit, f(x)]], [[xmax * xunit, 0], [xmin * xunit, 0]]));
			rotate([90, 0, 0]) linear_extrude(thick, center = true) offset(xmax / 1000) offset(-xmax / 1000) polygon(concat([for(x = x) [x * xunit, d(x)]], [[xmax * xunit, 0], [xmin * xunit, 0]]));
		rotate([0, 90, 0]) translate([0, 0, xmin * xunit]) cylinder(r = thick / 2, h = (xmax - xmin) * xunit);
		}
		for(x = [0:xmax]) translate([x * xunit, 0, 0]) cube([1, 1000, 1000], center = true);
	}
		
	#%translate([0, 0, xmark / 2]) linear_extrude(thick, center = true) offset(xmax / 1000) offset(-xmax / 1000) polygon(concat([for(i = [0:len(x) - 1]) [x[i] * xunit, integral[i]]], [[xmax * xunit, 0], [xmin * xunit, 0]]));
	#%rotate([90, 0, 0]) translate([0, 0, -xmark / 2]) linear_extrude(thick, center = true) offset(xmax / 1000) offset(-xmax / 1000) polygon(concat([for(x = x) [x * xunit, ((f(x) - f(x - step)) + (f(x + step) - f(x))) / 2 / step]], [[xmax * xunit, 0], [xmin * xunit, 0]]));
		
	intersection() {
		union() {
			translate([0, 0, xmark]) linear_extrude(thick, center = true) offset(xmax / 1000) offset(-xmax / 1000) polygon(concat([for(x = x) [x * xunit, f(x)]], [[max(x) * xunit, 0], [0, 0]]));
			rotate([90, 0, 0]) translate([0, 0, -xmark]) linear_extrude(thick, center = true) offset(xmax / 1000) offset(-xmax / 1000) polygon(concat([for(x = x) [x * xunit, d(x)]], [[max(x) * xunit, 0], [0, 0]]));
			rotate([0, 90, 0]) translate([-xmark, xmark, xmin * xunit]) cylinder(r = thick / 2, h = (xmax - xmin) * xunit);
		}
		for(x = [0:xmax]) translate([x * xunit, 0, 0]) cube([1, 1000, 1000], center = true);
	}
}

function integrate(v, c = 0, sum = []) = (len(v) == len(sum)) ? sum : integrate(v, c, concat(sum, [len(sum) ? sum[len(sum) - 1] + v[len(sum)] : v[0] + c]));