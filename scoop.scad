/* [main settings] */

// in g/cm³
density = 13;

// in grams
scoop_amount = 25;

// percentage of depth, relative to the diameter in percent (0.00 - 1)
scoop_depth = 0.5;

// in mm
wall_thickness = 1;

// in mm
handle_length = 30;

// in mm
handle_width = 10;

// in mm
handle_height = 1.5;

//----

volume = scoop_amount / density;
radius = (((3 * volume) / (4 * PI)) ^ (1/3)) * 10;

radius_multiplier = 1 / scoop_depth;
radius_inner = radius * radius_multiplier;
radius_outer = radius_inner + wall_thickness;

// set quality, 64 for testing, 128 for rendering
$fn = $preview ? 64 : 128;

module inner_sphere() sphere(r = radius_inner);
module outer_sphere() sphere(r = radius_outer);

module baseplate_cutoff() {
  translate([-radius_outer, -radius_outer, -radius_outer])
  cube(size = [radius_outer * 2, radius_outer * 2, radius_outer]);
}

module shovel() difference() {
  difference() {
    outer_sphere();
    inner_sphere();
  }

  baseplate_cutoff();
}

module handle_footprint() difference() {
  hull() {
    translate([radius_outer - (handle_width / 2), 0])
    circle(d = handle_width);

    translate([radius_outer + (handle_width / 2) + handle_length, 0])
    circle(d = handle_width);
  }

  circle(radius_outer);
}

union() {
  linear_extrude(handle_height) handle_footprint();
  shovel();
}