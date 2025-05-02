include <panel_options.scad>
include <front_panel.scad>
include <side_panel.scad>

// *************** Side Panels ***************

/* side_panel_1u_vented.stl
side_panel(
    u = 1,
    grid_type = "hex"
);
//*/

/* side_panel_3u_xb8_mount.stl
side_panel(
    u = 3,
    grid_type = "xb8_mount"
);
//*/

// *************** Front Panels ***************

/* front_panel_1u_hex.stl
front_panel(
    u = 1,
    grid_type = "hex"
);
//*/

/* front_panel_4u_ds423plus.stl
front_panel(
    u = 4,
    grid_type = "open",
    grid_bottom = 0-none,
    grid_top = 13,
    grid_left = 11,
    grid_right = 11,
);
//*/

/* front_panel_1u_lutron_hubitat.stl
lutron = struct_set([], [
    "depth", 71,
    "thickness", 3,
    "opening_width", 70,
    "opening_length", 31,
    "top_overhang", 10,
    "top_overhang_front", 10,
    "front_lip_inset", 1,
    "front_lip_thickness", 1,
    "bottom_grid_inset", 20,
    "back_tab_depth", 30,
    "back_tab_width", 10,
    "back_tab_slot_width", 1.5,
]);
hubitat = struct_set([], [
    "depth", 77,
    "thickness", 3,
    "opening_width", 76,
    "opening_length", 18,
    "top_overhang", 10,
    "top_overhang_front", 10,
    "front_lip_inset", 1,
    "front_lip_thickness", 1,
    "bottom_grid_inset", 20,
    "back_tab_depth", 30,
    "back_tab_width", 10,
    "back_tab_slot_width", 1.5,
]);
front_panel(
    u = 1,
    grid_type = "mod2",
    mod_list = ["box", "box"],
    mod_opts = [lutron, hubitat],
    front_lip_inset = 1,
    front_lip_thickness = 1,
);
//*/

/* front_panel_2u_vzw_extender.stl
grid_hex_spacing = 20;
grid_hex_strut = 4;
front_panel(
    u = 2,
    grid_type = "box",
    depth = 183,
    thickness = 3,
    opening_width = 181,
    opening_length = 61,
    top_overhang = 10,
    top_overhang_front = 10,
    front_lip_inset = 5,
    front_lip_thickness = 2,
);
//*/