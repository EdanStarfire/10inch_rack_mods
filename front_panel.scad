include <panel_options.scad>

module front_panel_base(
  u = 1) {
  attachable() {
    diff("remove_holes") {
      cube([
        full_width,
        u*u_height,
        panel_thickness],
        center = true, anchor=CENTER) {
          attach(TOP, BOTTOM, align=LEFT, inset=rail_width/2)
          fwd(first_hole_center-hole_diameter/2)
          down(panel_thickness+none)
          rot(90)
          tag("remove_holes")
          rack_holes(u = u);
          attach(TOP, BOTTOM, align=RIGHT, inset=rail_width/2)
          fwd(first_hole_center-hole_diameter/2)
          down(panel_thickness+none)
          rot(-90)
          tag("remove_holes")
          rack_holes(u = u);
        }
      }
    
    children();
  }
}

module front_panel(
  u = 1, 
  grid_type = "none", 
  grid_left = grid_offset_sides,
  grid_right = grid_offset_sides,
  grid_top = grid_offset_top,
  grid_bottom = grid_offset_top,
  depth = box_depth,
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
  mod_list = [],
  mod_opts = []) {
  if(grid_type != "none") {
    fwd_offset = (grid_bottom-grid_top)/2+none;
    left_offset = (grid_right-grid_left)/2+none;
    diff("remove_grid_spot") {
      front_panel_base(u) {
        attach(TOP, BOTTOM)
        fwd(fwd_offset)
        left(left_offset)
        down(panel_thickness/2+none)
        tag("remove_grid_spot")
        cube([
          between_rails-(grid_left + grid_right)+2*none,
          u*u_height-(grid_top + grid_bottom)+2*none,
          panel_thickness+2*none
        ]);
      }
    }
    fwd(fwd_offset)
    left(left_offset)
    down(grid_thickness/2+none)
    up(panel_height_offset(
      grid_type = grid_type,
      height = grid_thickness
    ))

    panel_fill(
      grid_type = grid_type,
      width=between_rails-(grid_left + grid_right)+2*none,
      length=u*u_height-(grid_top + grid_bottom)+2*none,
      height=grid_thickness,
      grid_left = grid_left,
      grid_right = grid_right,
      grid_top = grid_top,
      grid_bottom = grid_bottom,
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
      mod_list = mod_list,
      mod_opts = mod_opts,
    );
  } else {
    front_panel_base(u);
  }
}

box_struct = struct_set([], [
  "depth", 70,
  "thickness", 3,
  "opening_width", 60,
  "opening_length", 10,
  "top_overhang", 10,
  "top_overhang_front", 10,
  "front_lip_inset", 1,
  "front_lip_thickness", 2,
  "bottom_grid_inset", 20,
  "back_tab_depth", 30,
  "back_tab_width", 10,
  "back_tab_slot_width", 1.5,
  ]);
box_struct2 = struct_set([], [
  "depth", 40,
  "thickness", 3,
  "opening_width", 60,
  "opening_length", 10,
  "top_overhang", 5,
  "top_overhang_front", 5,
  "front_lip_inset", 1,
  "front_lip_thickness", 2,
  "bottom_grid_inset", 5,
  "back_tab_depth", 30,
  "back_tab_width", 10,
  "back_tab_slot_width", 1.5,
  ]);
front_panel(
  u = 1, 
  grid_type = "box",
  mod_list = ["box", "open"],
  mod_opts = [box_struct, box_struct2],
  front_lip_inset = 1,
  front_lip_thickness = 1,
  opening_length = 30,
  opening_width = 100,
  depth = 150,
  bottom_grid_inset = 5,
  top_overhang_front = 20,
  top_overhang = 5,
  );

