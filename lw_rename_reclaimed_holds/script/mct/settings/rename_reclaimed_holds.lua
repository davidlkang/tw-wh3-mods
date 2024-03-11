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

local run_for_ai_settings = {
    name = "run_for_ai",
    default_value = false,
    text = "Run for AI dwarfs",
    tooltip_text = "When this is enabled, the script will also run for AI dwarfs." ..
        "I would not recommend to also have the run-every-startup setting active." ..
        "It is not that something breaks, but your game might load a bit longer if you do."
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


local run_for_ai = mct_mod:add_new_option("lw_run_for_ai", "checkbox")

run_for_ai:set_default_value(run_for_ai_settings.default_value)
run_for_ai:set_text(run_for_ai_settings.text)
run_for_ai:set_tooltip_text(run_for_ai_settings.tooltip_text)
