include <panel_options.scad>

module side_panel_base(u = 1) {
  // Panel Front
  attachable() {
    diff("remove_holes")
    cube([
      outside_rails_front+2*bolt_panel_thickness,
      u * u_height,
      panel_thickness
    ], center=true) {
      // Panel rail holders
      attach(TOP, BOTTOM, align=[LEFT, RIGHT])
      cube([
        bolt_panel_thickness,
        u * u_height,
        rail_width-buffer
      ]);
      attach(TOP, BOTTOM, align=[LEFT, RIGHT], inset=rail_thickness+bolt_panel_thickness)
      cube([
        bolt_panel_thickness,
        u * u_height,
        rail_width-buffer
      ]);
      attach([LEFT,RIGHT], BOTTOM, align=BOTTOM, inset=rail_width/2)
      down(rail_thickness+2*bolt_panel_thickness+2*buffer)
      tag("remove_holes")
      rack_holes(u);
    }
  
    children();
  }
}

module side_panel(
  u = 1, 
  grid_type = "none",
  grid_left = grid_offset_sides,
  grid_right = grid_offset_sides,
  grid_top = grid_offset_top,
  grid_bottom = grid_offset_top,
  mod_list = []) {
  if(grid_type != "none") {
    fwd_offset = (grid_bottom-grid_top)/2+none;
    left_offset = (grid_right-grid_left)/2+none;
    // Remove a bare spot in the panel for the grid to go
    diff("remove_grid_spot") {
      side_panel_base(u) {
        attach(TOP, BOTTOM)
        fwd(fwd_offset)
        left(left_offset)
        down(panel_thickness/2+none)
        tag("remove_grid_spot")
        cube([
          between_rails_front-2*bolt_panel_thickness-(grid_left+grid_right)+buffer+2*none,
          u*u_height-(grid_top+grid_bottom)+2*none,
          panel_thickness+4*none
        ]);
      }
    }
    fwd(fwd_offset)
    left(left_offset)
    down(grid_type == "hex" || grid_type == "hex2" || grid_type == "xb8_mount" ? grid_thickness/2 : 0)
    panel_fill(
      grid_type = grid_type,
      width=between_rails_front-2*bolt_panel_thickness-(grid_left+grid_right)+buffer+2*none,
      length=u*u_height-(grid_top+grid_bottom)+2*none,
      height=grid_thickness,
      grid_left = grid_left,
      grid_right = grid_right,
      grid_top = grid_top,
      grid_bottom = grid_bottom,
      mod_list = mod_list
    );
  } else {
    side_panel_base(u);
  }
}

side_panel(
  u = 1, 
  grid_type="hex",
  mod_list = ["hex", "hex"],
);