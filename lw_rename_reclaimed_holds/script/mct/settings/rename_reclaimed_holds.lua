local mod_settings = {
    title = "Rename Reclaimed Holds",
    author = "LoneWanderer",
    descrpition = "This mod auto-renames certain settlements to have names in Khazalid. " ..
        "Only active for the Player-Dwarf faction. Renames on every transition " ..
        "to the players faction - e.g. occupation, trading, confederation, console-commands."
}

local run_every_start_up_settings = {
    name = "run_every_start_up",
    default_value = false,
    text = "Rename now and on every session start",
    tooltip_text = "Whether the script to rename owned settlements should run every time " ..
        "the campaign is launched. Disable if you want to keep your custom settlement " ..
        "names. Enable if you want to have the latest update, as by default the mod " ..
        "will run the script to rename owned settlements just once per campaign."
}


local mct = get_mct()
local mct_mod = mct:register_mod("lw_rename_reclaimed_holds")

mct_mod:set_title(mod_settings.title)
mct_mod:set_author(mod_settings.author)
mct_mod:set_description(mod_settings.descrpition)

local run_every_start_up = mct_mod:add_new_option("lw_rename_on_every_start_up", "checkbox")

run_every_start_up:set_default_value(run_every_start_up_settings.default_value)
run_every_start_up:set_text(run_every_start_up_settings.text)
run_every_start_up:set_tooltip_text(run_every_start_up_settings.tooltip_text)
