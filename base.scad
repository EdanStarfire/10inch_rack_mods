$fs = $preview ? 1 : 0.1;
$fa = $preview ? 3 : 0.1;
include <BOSL2/std.scad>
include <BOSL2/walls.scad>

none = 0.001;
buffer = 0.125;

// Dimensions on https://upload.wikimedia.org/wikipedia/commons/8/84/19_inch_vs_10_inch_rack_dimensions.svg
center_mount_holes = 236.525;
full_width = 250.00; // Modified for Natalie T's rack setup
u_height = 44.50;
first_hole_center = 6.35;
hole_diameter = 6.5;
between_rails = 222.25; // Modified for Natalie T's rack setup
mount_hole_spacing = 15.875;
rail_width = 15.875;
between_rails_front = 168;
rail_thickness = 16.0;
outside_rails_front =between_rails_front + 2*rail_thickness+buffer;

// Front/Side Panel Defaults
panel_thickness = 3;
bolt_panel_thickness=3;

// Grid Defaults
grid_offset_sides = 10;
grid_offset_top = 5;
grid_thickness = panel_thickness/2;
grid_border = 3;
grid_border_height = panel_thickness+2;
grid_hex_spacing = 10;
grid_hex_strut = 2;
grid_hex2_spacing = 6;
grid_hex2_diameter = 5;

// Box Defaults
box_thickness = 3;
box_depth = 60;
box_opening_width = 60;
box_opening_length = 20;
box_top_overhang = 10;
box_top_overhang_front = 10;
box_front_lip_inset = 1;
box_front_lip_thickness = 2;
box_bottom_grid_inset = 20;
box_back_tab_depth = 30;
box_back_tab_width = 10;
box_back_tab_slot_width = 1.5;

