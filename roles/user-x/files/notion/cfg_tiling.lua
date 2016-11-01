--
-- Notion tiling module configuration file
--

-- Bindings for the tilings. 

defbindings("WTiling", {
    bdoc("Split current frame."),
    kpress(META.."KP_Down",  "WTiling.split_at(_, _sub, 'bottom', true)"),
	kpress(META.."KP_Right", "WTiling.split_at(_, _sub, 'right', true)"),
	kpress(META.."KP_Up",    "WTiling.split_at(_, _sub, 'up', true)"),
	kpress(META.."KP_Left",  "WTiling.split_at(_, _sub, 'left', true)"),
    
	bdoc("Destroy current frame."),
	kpress(META.."KP_Begin", "WTiling.unsplit_at(_, _sub)"),
})


-- Frame bindings

defbindings("WFrame.floating", {
})


-- Context menu for tiled workspaces.

defctxmenu("WTiling", "Tiling", {
    menuentry("Destroy frame", 
              "WTiling.unsplit_at(_, _sub)"),

    menuentry("Split vertically", 
              "WTiling.split_at(_, _sub, 'bottom', true)"),
    menuentry("Split horizontally", 
              "WTiling.split_at(_, _sub, 'right', true)"),
    
    menuentry("Flip", "WTiling.flip_at(_, _sub)"),
    menuentry("Transpose", "WTiling.transpose_at(_, _sub)"),
    
    menuentry("Untile", "mod_tiling.untile(_)"),
    
    submenu("Float split", {
        menuentry("At left", 
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'left')"),
        menuentry("At right", 
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'right')"),
        menuentry("Above",
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'up')"),
        menuentry("Below",
                  "WTiling.set_floating_at(_, _sub, 'toggle', 'down')"),
    }),

    submenu("At root", {
        menuentry("Split vertically", 
                  "WTiling.split_top(_, 'bottom')"),
        menuentry("Split horizontally", 
                  "WTiling.split_top(_, 'right')"),
        menuentry("Flip", "WTiling.flip_at(_)"),
        menuentry("Transpose", "WTiling.transpose_at(_)"),
    }),
})


-- Extra context menu extra entries for floatframes. 

defctxmenu("WFrame.floating", "Floating frame", {
    append=true,
    menuentry("New tiling", "mod_tiling.mkbottom(_)"),
})

