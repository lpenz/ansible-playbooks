--
-- Notion core configuration file
--


-- 
-- Bindings. This includes global bindings and bindings common to
-- screens and all types of frames only. See modules' configuration 
-- files for other bindings.
--


-- WScreen context bindings
--
-- The bindings in this context are available all the time.
--
-- The variable META should contain a string of the form 'Mod1+'
-- where Mod1 maybe replaced with the modifier you want to use for most
-- of the bindings. Similarly ALTMETA may be redefined to add a 
-- modifier to some of the F-key bindings.

defbindings("WScreen", {
    bdoc("Display the main menu."),
    kpress(META.."F12", "mod_query.query_menu(_, 'mainmenu', 'Main menu: ')"),
    --kpress(ALTMETA.."F12", "mod_menu.menu(_, _sub, 'mainmenu', {big=true})"),
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'mainmenu')"),

    bdoc("Display the window list menu."),
    mpress("Button2", "mod_menu.pmenu(_, _sub, 'windowlist')"),


    bdoc("Go to previous active object."),
    kpress(META.."Tab", "ioncore.goto_previous()"),

    bdoc("Go to first region demanding attention or previously active one."),
    kpress(META.."A", "ioncore.activity_goto()"),

    bdoc("Clear all tags."),
    kpress(META.."Y", "ioncore.clear_tags()"),
})


-- Client window bindings
--
-- These bindings affect client windows directly.

defbindings("WClientWin", {
	bdoc("Send next key press to the client window. Some programs may not allow this by default."),
	kpress(META.."Q", "WClientWin.quote_next(_)"),
})


-- Client window group bindings

defbindings("WGroupCW", {
    bdoc("Toggle client window group full-screen mode"),
    kpress_wait(META.."Return", "WGroup.set_fullscreen(_, 'toggle')"),
})


-- WMPlex context bindings
--
-- These bindings work in frames and on screens. The innermost of such
-- contexts/objects always gets to handle the key press. 

defbindings("WMPlex", {
    bdoc("Close current object."),
    kpress_wait(META.."End", "WRegion.rqclose_propagate(_, _sub)"),
    kpress_wait(META.."F4",  "WRegion.rqclose_propagate(_, _sub)"),

    --bdoc("Nudge current client window. This might help with some programs' resizing problems."),
    --kpress_wait(META.."L", "WClientWin.nudge(_sub)", "_sub:WClientWin"),

	bdoc("Kill client owning current client window."),
	kpress(META.."Delete", "WClientWin.kill(_sub)", "_sub:WClientWin"),

	bdoc("Send next key press to current client window. Some programs may not allow this by default."),
	kpress(META.."Q", "WClientWin.quote_next(_sub)", "_sub:WClientWin"),

    bdoc("Go to frame above/below/right/left of current frame."),
    kpress(META.."Up"    , "ioncore.goto_next(_, 'up')"),
    kpress(META.."Down"  , "ioncore.goto_next(_, 'down')"),
    kpress(META.."Right" , "ioncore.goto_next(_, 'right')"),
    kpress(META.."Left"  , "ioncore.goto_next(_, 'left')"),
})

-- Frames for transient windows ignore this bindmap
defbindings("WMPlex.toplevel", {
	-- Look at /usr/include/X11/keysymdef.h

    bdoc("Go to next/previous screen on multihead setup."),
    kpress(META.."Mod1+Left", "ioncore.goto_prev_screen()"),
    kpress(META.."Mod1+Right", "ioncore.goto_next_screen()"),
    kpress(META.."Shift+comma", "ioncore.goto_prev_screen()"),
    kpress(META.."Shift+period", "ioncore.goto_next_screen()"),
    kpress(META.."Shift+1", "ioncore.goto_nth_screen(0)"),
    kpress(META.."Shift+2", "ioncore.goto_nth_screen(1)"),
    kpress(META.."Shift+3", "ioncore.goto_nth_screen(2)"),

    bdoc("Create a new workspace of chosen default type."),
    kpress(META.."H", "ioncore.create_ws(_:screen_of(),{name='',switchto=true},'empty')"),

    bdoc("Toggle client window full-screen mode"),
    kpress_wait(META.."Return", 
                "WClientWin.set_fullscreen(_sub, 'toggle')", 
                "_sub:WClientWin"),

    bdoc("Terminal"),
    kpress(META.."F1", "ioncore.exec_on(_, 'x-terminal-emulator')"),

    bdoc("Mail"),
    kpress(META.."F2", "ioncore.exec_on(_, 'x-terminal-emulator -e mutt')"),

    bdoc("Sound volume increase"),
    kpress(META.."KP_Add", "ioncore.exec_on(_, 'amixer sset Master 5%+')"),
    bdoc("Sound volume decrease"),
    kpress(META.."KP_Subtract", "ioncore.exec_on(_, 'amixer sset Master 5%-')"),

    bdoc("Sound volume increase"),
    kpress("XF86AudioRaiseVolume", "ioncore.exec_on(_, 'amixer sset Master 5%+')"),
    bdoc("Sound volume decrease"),
    kpress("XF86AudioLowerVolume", "ioncore.exec_on(_, 'amixer sset Master 5%-')"),

    bdoc("Run a terminal emulator."),
    kpress("Menu", "ioncore.exec_on(_, 'x-terminal-emulator')"),
    kpress("Multi_key", "ioncore.exec_on(_, 'x-terminal-emulator')"),

    bdoc("Toggles Touchpad."),
    kpress(META.."slash", "ioncore.exec_on(_, 'touchpad-toggle')"),

    bdoc("Toggles MPD."),
    kpress(META.."c", "ioncore.exec_on(_, 'mpc toggle')"),

    bdoc("Display pidgin pending event"),
    kpress(META.."equal", "ioncore.exec_on(_, '/home/penz/bin/pidgin-click')"),

    bdoc("Turn on all displays"),
    kpress(META.."Z", "ioncore.exec_on(_, '/home/penz/bin/xrandr-all-on')"),

    bdoc("Run a screen lock."),
    kpress(META.."Scroll_Lock", "ioncore.exec_on(_, 'xscreensaver-command -lock')"),

    bdoc("X selection save"),
    kpress(META.."Page_Up", "ioncore.exec_on(_, 'xselctrl.py -s')"),

    bdoc("X selection load"),
    kpress(META.."Page_Down", "ioncore.exec_on(_, 'xselctrl.py -g')"),

    bdoc("Run warn."),
    kpress(META.."W", "ioncore.exec_on(_, 'warnready')"),

    bdoc("Query for command line to execute."),
    kpress(META.."R", "mod_query.query_exec(_)"),

    bdoc("Query for Lua code to execute."),
    kpress(META.."P", "mod_query.query_lua(_)"),

    bdoc("Query for file to edit."),
    kpress(META.."E", "mod_query.query_editfile(_, 'gvim')"),

    bdoc("Query for a client window to go to."),
    kpress(META.."G", "mod_query.query_gotoclient(_)"),

    bdoc("Query for a client window to attach."),
    kpress(META.."F", "mod_query.query_attachclient(_)"),
})


-- WFrame context bindings
--
-- These bindings are common to all types of frames. Some additional
-- frame bindings are found in some modules' configuration files.

defbindings("WFrame", {
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'ctxmenu')"),

    bdoc("Switch the frame to display the object indicated by the tab."),
    mclick("Button1@tab", "WFrame.p_switch_tab(_)"),
    mclick("Button2@tab", "WFrame.p_switch_tab(_)"),

    bdoc("Resize the frame."),
    mdrag("Button1@border", "WFrame.p_resize(_)"),
    mdrag(META.."Button3", "WFrame.p_resize(_)"),

    bdoc("Move the frame."),
    mdrag(META.."Button1", "WFrame.p_move(_)"),

    bdoc("Move objects between frames by dragging and dropping the tab."),
    mdrag("Button1@tab", "WFrame.p_tabdrag(_)"),
    mdrag("Button2@tab", "WFrame.p_tabdrag(_)"),

})

-- Frames for transient windows ignore this bindmap

local wframetoplevel = {
}

local mykeys = {
	{ key = "1"      , strfunc = "p_:switch_nth(0)" },
	{ key = "2"      , strfunc = "p_:switch_nth(1)" },
	{ key = "3"      , strfunc = "p_:switch_nth(2)" },
	{ key = "4"      , strfunc = "p_:switch_nth(3)" },
	{ key = "5"      , strfunc = "p_:switch_nth(4)" },
	{ key = "6"      , strfunc = "p_:switch_nth(5)" },
	{ key = "7"      , strfunc = "p_:switch_nth(6)" },
	{ key = "8"      , strfunc = "p_:switch_nth(7)" },
	{ key = "9"      , strfunc = "p_:switch_nth(8)" },
	{ key = "I"      , strfunc = "p_:attach_new({type='WTiling'})" },
	{ key = "O"      , strfunc = "p_:attach_new({type='WGroupWS'})" },
	{ key = "period" , strfunc = "p_:switch_next()" },
	{ key = "comma"  , strfunc = "p_:switch_prev()" },
	{ key = "K"      , strfunc = "m_:dec_index(m_sub)" },
	{ key = "L"      , strfunc = "m_:inc_index(m_sub)" },
	{ key = "X"      , strfunc = "ioncore.tagged_attach(_)" },
	{ key = "N"      , strfunc = "mod_query.query(m_, 'Enter name:', m_:manager():name(), function(mplex, string) print(mplex:manager():name(), string); mplex:manager():set_name(string); end)" },
	{ key = "B"      , strfunc = "p_:set_mode('tiled-alt')" },
	{ key = "V"      , strfunc = "p_:set_mode('tiled')" },
	{ key = "S"      , strfunc = "p_:begin_kbresize()" },
	{ key = "M"      , strfunc = "mod_query.query_menu(m_, 'ctxmenu', 'Context menu: ')" },
	{ key = "J"      , strfunc = "mod_query.show_clientwin(m_, m_sub)" },
	{ key = "T"      , strfunc = "m_sub:set_tagged('toggle')" },
}

for level,key in pairs({ META, META.."Mod1+" , META.."Control+", META.."Mod1+Control+", }) do
	local xhood = function(level, x)
		if level == 0 then
			return "_sub"
		end
		local rv = "_"
		for i=2,level do
			rv = rv .. ":"..x.."()"
		end
		return rv
	end
	for _,map in pairs(mykeys) do
		local strfunc = map.strfunc
		strfunc = string.gsub(strfunc, "p_sub", xhood(level - 1, "parent"))
		strfunc = string.gsub(strfunc, "m_sub", xhood(level - 1, "manager"))
		strfunc = string.gsub(strfunc, "p_", xhood(level, "parent"))
		strfunc = string.gsub(strfunc, "m_", xhood(level, "manager"))
		--print(key..map.key, strfunc)
		table.insert(wframetoplevel, kpress(key..map.key, strfunc))
	end
end


defbindings("WFrame", wframetoplevel)

-- WMoveresMode context bindings
-- 
-- These bindings are available keyboard move/resize mode. The mode
-- is activated on frames with the command begin_kbresize (bound to
-- META.."R" above by default).

defbindings("WMoveresMode", {
    bdoc("Cancel the resize mode."),
    kpress("AnyModifier+Escape","WMoveresMode.cancel(_)"),

    bdoc("End the resize mode."),
    kpress("AnyModifier+Return","WMoveresMode.finish(_)"),

    bdoc("Grow in specified direction."),
    kpress("Left",  "WMoveresMode.resize(_, 1, 0, 0, 0)"),
    kpress("Right", "WMoveresMode.resize(_, 0, 1, 0, 0)"),
    kpress("Up",    "WMoveresMode.resize(_, 0, 0, 1, 0)"),
    kpress("Down",  "WMoveresMode.resize(_, 0, 0, 0, 1)"),
    kpress("F",     "WMoveresMode.resize(_, 1, 0, 0, 0)"),
    kpress("B",     "WMoveresMode.resize(_, 0, 1, 0, 0)"),
    kpress("P",     "WMoveresMode.resize(_, 0, 0, 1, 0)"),
    kpress("N",     "WMoveresMode.resize(_, 0, 0, 0, 1)"),

    bdoc("Shrink in specified direction."),
    kpress("Shift+Left",  "WMoveresMode.resize(_,-1, 0, 0, 0)"),
    kpress("Shift+Right", "WMoveresMode.resize(_, 0,-1, 0, 0)"),
    kpress("Shift+Up",    "WMoveresMode.resize(_, 0, 0,-1, 0)"),
    kpress("Shift+Down",  "WMoveresMode.resize(_, 0, 0, 0,-1)"),
    kpress("Shift+F",     "WMoveresMode.resize(_,-1, 0, 0, 0)"),
    kpress("Shift+B",     "WMoveresMode.resize(_, 0,-1, 0, 0)"),
    kpress("Shift+P",     "WMoveresMode.resize(_, 0, 0,-1, 0)"),
    kpress("Shift+N",     "WMoveresMode.resize(_, 0, 0, 0,-1)"),

    bdoc("Move in specified direction."),
    kpress(META.."Left",  "WMoveresMode.move(_,-1, 0)"),
    kpress(META.."Right", "WMoveresMode.move(_, 1, 0)"),
    kpress(META.."Up",    "WMoveresMode.move(_, 0,-1)"),
    kpress(META.."Down",  "WMoveresMode.move(_, 0, 1)"),
    kpress(META.."F",     "WMoveresMode.move(_,-1, 0)"),
    kpress(META.."B",     "WMoveresMode.move(_, 1, 0)"),
    kpress(META.."P",     "WMoveresMode.move(_, 0,-1)"),
    kpress(META.."N",     "WMoveresMode.move(_, 0, 1)"),
})


--
-- Menu definitions
--


-- Main menu
defmenu("mainmenu", {
    menuentry("Run...",         "mod_query.query_exec(_)"),
    menuentry("Terminal",       "mod_query.exec_on_merr(_, XTERM or 'x-terminal-emulator')"),
    menuentry("Lock screen",    
        "notioncore.exec_on(_, notioncore.lookup_script('notion-lock'))"),
    menuentry("Help",           "mod_query.query_man(_)"),
    menuentry("About Notion",      "mod_query.show_about_ion(_)"),
    submenu("Styles",           "stylemenu"),
    submenu("Debian",           "Debian"),
    submenu("Session",          "sessionmenu"),
})


-- Session control menu
defmenu("sessionmenu", {
    menuentry("Save",           "ioncore.snapshot()"),
    menuentry("Restart",        "ioncore.restart()"),
    menuentry("Restart TWM",    "ioncore.restart_other('twm')"),
    menuentry("Exit",           "ioncore.shutdown()"),
})


-- Context menu (frame actions etc.)
defctxmenu("WFrame", "Frame", {
    -- Note: this propagates the close to any subwindows; it does not
    -- destroy the frame itself, unless empty. An entry to destroy tiled
    -- frames is configured in cfg_tiling.lua.
    menuentry("Close",          "WRegion.rqclose_propagate(_, _sub)"),
    -- Low-priority entries
    menuentry("Attach tagged", "ioncore.tagged_attach(_)", { priority = 0 }),
    menuentry("Clear tags",    "ioncore.tagged_clear()", { priority = 0 }),
    menuentry("Window info",   "mod_query.show_tree(_, _sub)", { priority = 0 }),
})


-- Context menu for groups (workspaces, client windows)
defctxmenu("WGroup", "Group", {
    menuentry("Toggle tag",     "WRegion.set_tagged(_, 'toggle')"),
    menuentry("De/reattach",    "ioncore.detach(_, 'toggle')"), 
})


-- Context menu for workspaces
defctxmenu("WGroupWS", "Workspace", {
    menuentry("Close",          "WRegion.rqclose(_)"),
    menuentry("Rename",         "mod_query.query_renameworkspace(nil, _)"),
    menuentry("Attach tagged",  "ioncore.tagged_attach(_)"),
})


-- Context menu for client windows
defctxmenu("WClientWin", "Client window", {
    menuentry("Kill",           "WClientWin.kill(_)"),
})

-- Auto-generated Debian menu definitions
if os then
   havemenus = os.execute("test -x /usr/bin/update-menus")
   if havemenus == 0 or havemenus == true then
      if ioncore.is_i18n() then
         dopath("debian-menu-i18n")
      else
         dopath("debian-menu")
      end
   end
end
