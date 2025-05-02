// The various panel options
// I kept running into circular "includes" issues, so I just put them all
// in one file.
include <base.scad>

// Since the panel thickness is dynamic based on parameters, we need a function
// that can calculate the height of the panel based on the grid type and params
// This is used to determine how far to translate it to line it up with the front

function panel_height_offset(
  grid_type = "none",
  height = panel_thickness) = (
    grid_type == "none" ? 0 :
    grid_type == "open" ? 0 :
    grid_type == "hex" ? 0 : 
    grid_type == "hex2" ? 0 :
    grid_type == "xb8_mount" ? 0 :
    grid_type == "mod2" ? height/2 :
    grid_type == "box" ? height/2 : 0
  );

// Fill a spot with any supported panel
module panel_fill(
    grid_type = "none",
    width = 100,
    length = 30,
    height = 3,
    border = grid_border,
    border_height = grid_border_height,
    grid_left = grid_offset_sides,
    grid_right = grid_offset_sides,
    grid_top = grid_offset_top,
    grid_bottom = grid_offset_top,
    mod_list = [],
    mod_opts = [],
    depth = 50,
    thickness = box_thickness,
    opening_width = box_opening_width,
    opening_length = box_opening_length,
    top_overhang = box_top_overhang,
    top_overhang_front = box_top_overhang_front,
    front_lip_inset = box_front_lip_inset,
    front_lip_thickness = box_front_lip_thickness,
    bottom_grid_inset = box_bottom_grid_inset,
    back_tab_depth = box_back_tab_depth,
    back_tab_width = box_back_tab_width,
    back_tab_slot_width = box_back_tab_slot_width,
) {
  assert(
    grid_type == "none"
      || grid_type == "open"
      || grid_type == "hex"
      || grid_type == "hex2"
      || grid_type == "mod2"
      || grid_type == "xb8_mount"
      || grid_type == "box",
    "grid_type must be one of [none, open, hex, hex2, mod2, xb8_mount, box]"
  );
  attachable() {
    if(grid_type == "hex") {
      hex_grid(
        width = width,
        length = length,
        height = height,
        border = border,
        border_height = border_height,
        spacing = grid_hex_spacing,
        strut = grid_hex_strut,
      );
    } else if (grid_type == "hex2") {
      hex_grid2(
        width = width,
        length = length,
        height = height,
        border=border, 
        border_height=border_height,
        diameter=grid_hex2_diameter,
        spacing=grid_hex2_spacing);
    } else if (grid_type == "mod2") {
      mod2_panel(
        width = width,
        length = length,
        height = height,
        mod_list=mod_list,
        mod_opts=mod_opts);
    } else if (grid_type == "xb8_mount") {
      xb8_mount(
        width = width,
        length = length,
        height = panel_thickness);
    } else if (grid_type == "box") {
      box_frame(
        width = width,
        length = length,
        height = panel_thickness,
        depth = depth,
        thickness = thickness,
        opening_width = opening_width,
        opening_length = opening_length,
        top_overhang = top_overhang,
        top_overhang_front = top_overhang_front,
        front_lip_inset = front_lip_inset,
        front_lip_thickness = front_lip_thickness,
        bottom_grid_inset = bottom_grid_inset,
        back_tab_depth = back_tab_depth,
        back_tab_width = back_tab_width,
        back_tab_slot_width = back_tab_slot_width);
    } else if (grid_type == "open") {
    } else if (grid_type == "none") {
      //up(grid_thickness/2+none)
      cube([width, length, panel_thickness], center=true);
    } else {}
        
    children();
  }
}

// Rack Holes - makes the cylinders for the holes
module rack_holes(u = 1) {
  move([-(u-1)*u_height/2, 0, 0])
  for(i=[0: 1: u-1]) {
    move([i*u_height, 0, 0]) {
      move([-u_height/2, 0, 0])
      for(j=[0: 1: 2]) {
        move([j*mount_hole_spacing + first_hole_center, 0, 0])
        cyl(h=rail_thickness+2*bolt_panel_thickness+3*buffer,d=hole_diameter) {
        }
      }
    }
  }
}

// mount_holes - Making holes for mounting something
module mount_holes(
  to_right,
  to_top,
  diameter,
  height,
  symmetric = true) {
    if(symmetric) {
      fwd(to_top)
      right(-to_right)
      cyl(h = height, d = diameter, center=true);
      fwd(to_top)
      right(to_right)
      cyl(h = height, d = diameter, center=true);
    } else {
      fwd(to_top)
      right(-to_right)
      cyl(h = height, d = diameter, center=true);
    }
}

// hex_grid - The built-in hex grid from BOSL2
module hex_grid(
  height = 10, 
  diameter = 15, 
  width = 100,
  length = 100,
  spacing = 20,
  stagger = true,
  border = 4,
  border_height = 0,
  strut = 2) {
  border_height = border_height == 0 ? height : border_height;
  buffer = diameter*2;
  hex_panel([
    width, length, height
    ],
    spacing = spacing,
    strut = strut);
  if (border > 0) {
    diff("remove_border") {
      up((border_height-height)/2+none)
      cube([width, length, border_height+2*none], center=true)
      if (border > 0) {
        tag("remove_border")
        cube([width-border, length-border, border_height+4*none], center=true);
      }
    }
    
  }
}

// hex_grid2 - A hex grid with a different pattern made manually (thicker overall)
// This is a bit of a hack, but it works
module hex_grid2(
  height = 10, 
  diameter = 15, 
  width = 100,
  length = 100,
  spacing = 20,
  stagger = true,
  border = 4,
  border_height = 0) {
  border_height = border_height == 0 ? height : border_height;
  buffer = diameter*2;
  diff("remove_grid") {
    grid_copies(
      spacing, 
      size=[width+buffer, length+buffer],
      stagger=true) 
    tag("remove_grid")
    cyl(h=height+buffer, d=diameter, $fn=6);
    cube([width-border, length-border,height], center=true);
  }
  if (border > 0) {
    diff("remove_border") {
      up((border_height-height)/2)
      cube([width, length, border_height+2*none], center=true)
      if (border > 0) {
        tag("remove_border")
        cube([width-border, length-border, border_height+4*none], center=true);
      }
    }
    
  }
}

// xb8_mount - A mount panel module for the XB8
module xb8_mount(
  height = 3,
  width = 138,
  length = 100) {
  block_width = 49.0-buffer;
  block_length = 65.5-buffer;
  block_height = 3;
  diff("remove_block") {
    diff("remove_holes") {
      up((height-panel_thickness/2)/2)
      cube([
        width,
        length,
        height],
        center=true);
      fwd(10)
      tag("remove_holes")
      mount_holes(
        to_right = 49.875,
        to_top = 17.5,
        diameter = 5,
        height = 10,
        symmetric = true);
      fwd(10)
      tag("remove_holes")
      mount_holes(
        to_right = 38.635,
        to_top = -17.5,
        diameter = 5,
        height = 10,
        symmetric = true);
    }
    back(6.25)
    right(-0.25)
    tag("remove_block")
    cube([
      block_width,
      block_length,
      block_height + height],
      center = true);
  }
  back(6.25)
  right(-0.25)
  up(2*buffer)
  hex_grid(
    height=2,
    width=block_width,
    length=block_length,
    spacing = grid_hex_spacing,
    strut = grid_hex_strut,
    border = grid_border,
    border_height=block_height,
    );
}

// mod2_panel - A panel with two evenly split module spaces
module mod2_panel(
    between = 5, 
    width = 100,
    length = 30,
    height = 3,
    mod_list = [],
    mod_opts = [],
  ) {
  attachable() {
    union() {
      if(mod_list == []) {
        mod_list = ["none", "none"];
      }
      each_wide = (width-between)/2;
      // up(grid_thickness/2+none)
      cube([
        between,
        length,
        panel_thickness],center=true);
      
      for(i = [-1, 1]) {
        mod_type = 
          mod_list == [] ? "none" : 
          mod_list[(i == -1 ? 1 : 0)];
        mod_opt = 
          mod_opts == [] ? [] : 
          mod_opts[(i == -1 ? 1 : 0)];
        left(i*(each_wide+between)/2)
        down(mod_type == "hex" || mod_type == "hex2" || mod_type == "xb8_mount" ? height/2 :0)
        panel_fill(
          grid_type = mod_type,
          width=each_wide,
          length=length,
          height=height,
          grid_left = 0,
          grid_right = 0,
          grid_top = 0,
          grid_bottom = 0,
          depth = struct_val(mod_opt, "depth", 50),
          thickness = struct_val(mod_opt, "thickness", box_thickness),
          opening_width = struct_val(mod_opt, "opening_width", box_opening_width),
          opening_length = struct_val(mod_opt, "opening_length", box_opening_length),
          top_overhang = struct_val(mod_opt, "top_overhang", box_top_overhang),
          top_overhang_front = struct_val(mod_opt, "top_overhang_front", box_top_overhang_front),
          front_lip_inset = struct_val(mod_opt, "front_lip_inset", box_front_lip_inset),
          front_lip_thickness = struct_val(mod_opt, "front_lip_thickness", box_front_lip_thickness),
          bottom_grid_inset = struct_val(mod_opt, "bottom_grid_inset", box_bottom_grid_inset),
          back_tab_depth = struct_val(mod_opt, "back_tab_depth", box_back_tab_depth),
          back_tab_width = struct_val(mod_opt, "back_tab_width", box_back_tab_width),
          back_tab_slot_width = struct_val(mod_opt, "back_tab_slot_width", box_back_tab_slot_width),
        );
      }
    }
    children();
  }
}

module box_frame(
  width = 100,
  length = 30,
  height = 3,
  depth = 50,
  thickness = box_thickness,
  opening_width = box_opening_width,
  opening_length = box_opening_length,
  top_overhang = box_top_overhang,
  top_overhang_front = box_top_overhang_front,
  front_lip_inset = box_front_lip_inset,
  front_lip_thickness = box_front_lip_thickness,
  bottom_grid_inset = box_bottom_grid_inset,
  back_tab_depth = box_back_tab_depth,
  back_tab_width = box_back_tab_width,
  back_tab_slot_width = box_back_tab_slot_width,
  ) {
  diff("remove_border") {
    // Full Box
    cube([
      width, 
      length, 
      height], center=true);
    up(depth/2 - height/2)
    cube([
      opening_width+2*thickness, 
      opening_length+2*thickness, 
      depth], center=true) {
        // Hollow out center
        attach(TOP, BOTTOM)
        down(depth - front_lip_thickness)
        tag("remove_border")
        cube([
          opening_width, 
          opening_length, 
          depth+2*none], center=true);
        // Hollow out top 
        attach(FRONT, BACK)
        down(thickness+none)
        back(top_overhang_front)
        tag("remove_border")
        cube([
          opening_width - 2*(thickness+top_overhang), 
          thickness+2*none, 
          depth+2*none], center=true);
        // Hollow out face
        attach(BOTTOM, TOP)
        down(thickness+none)
        tag("remove_border")
        cube([
          opening_width - 2*front_lip_inset, 
          opening_length - 2*front_lip_inset, 
          thickness+2*none], center=true);
        // Hollow out grid area
        attach(BACK, FRONT, align=BOTTOM)
        down(thickness+none)
        back(top_overhang_front)
        tag("remove_border")
        cube([
          opening_width - 2*bottom_grid_inset, 
          thickness+2*none, 
          depth - top_overhang_front +2*none], center=true);
        // Cut slots for back tabs
        attach(LEFT, RIGHT)
        down(opening_width+2*thickness+none)
        back((depth - back_tab_depth)/2+none)
        left(back_tab_width/2)
        tag("remove_border")
        cube([
          opening_width +2*thickness + 2*none,
          back_tab_slot_width,
          back_tab_depth], center=true);
        attach(LEFT, RIGHT)
        down(opening_width + 2*thickness +none)
        back((depth - back_tab_depth)/2+none)
        right(back_tab_width/2)
        tag("remove_border")
        cube([
          opening_width +2*thickness + 2*none,
          back_tab_slot_width,
          back_tab_depth], center=true);
      }
  }
  // Add bottom hex grid
  up(depth/2 - height/2 + top_overhang/2)
  back((opening_length+thickness)/2)
  xrot(-90)
  panel_fill(
    grid_type = "hex",
    width = opening_width - 2*bottom_grid_inset, 
    height = thickness+2*none, 
    length = depth - top_overhang +2*none,
    border = 0);
  // Add back tabs
  up(depth)
  left(opening_width/2 +.25*thickness)
  cuboid([
    1.5*thickness,
    back_tab_width - back_tab_slot_width,
    thickness],
    rounding = thickness/2,
    edges = [RIGHT+BOTTOM, RIGHT+TOP],
    $fn=20);
  up(depth)
  right(opening_width/2 +.25*thickness)
  cuboid([
    1.5*thickness,
    back_tab_width - back_tab_slot_width,
    thickness],
    rounding = thickness/2,
    edges = [LEFT+BOTTOM, LEFT+TOP],
    $fn=20);
}

// box_struct = struct_set([], [
//   "depth", 70,
//   "thickness", 3,
//   "box_opening_width", 60,
//   "box_opening_length", 10,
//   "top_overhang", 10,
//   "top_overhang_front", 10,
//   "front_lip_inset", 1,
//   "front_lip_thickness", 2,
//   "bottom_grid_inset", 5,
//   "back_tab_depth", 30,
//   "back_tab_width", 10,
//   "back_tab_slot_width", 1.5,
//   ]);
// panel_fill(
//   grid_type = "mod2",
//   mod_list = ["box", "hex2"],
//   mod_opts = [box_struct, []],
//   width = 220,
//   length = 44.5,
//   height = 3,
//   depth = 80,
// );
// box_frame(
//   width = 220,
//   length = 44.5,
//   height = 3,
//   depth = 80,
//   thickness = box_thickness,
//   opening_width = box_opening_width,
//   opening_length = box_opening_length,
//   top_overhang = box_top_overhang,
//   top_overhang_front = box_top_overhang_front,
//   front_lip_inset = box_front_lip_inset,
//   front_lip_thickness = box_front_lip_thickness,
//   bottom_grid_inset = box_bottom_grid_inset,
//   back_tab_depth = box_back_tab_depth,
//   back_tab_width = box_back_tab_width,
//   back_tab_slot_width = box_back_tab_slot_width
// );