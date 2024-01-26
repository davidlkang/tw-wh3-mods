local dwarven_holds = require("script/campaign/mod/hold_names")
local dwarf_culture = "wh_main_sc_dwf_dwarfs"
local settings = {
    run_every_start_up = false,
}


local function check_if_dwarf_player(faction)
    local is_player = faction:is_human()
    local is_dwarf_culture = faction:subculture() == dwarf_culture

    if is_player and is_dwarf_culture then
        return true
    end
end


local function rename_new_hold(region)
    local new_region_name = dwarven_holds[region:name()]

    if new_region_name then
        cm:change_custom_settlement_name(region:settlement(), new_region_name)
    end
end


local function rename_owned_holds(player_faction)
    local region_list = player_faction:region_list()
    local number_of_regions = region_list:num_items()

    for i = 0, number_of_regions - 1 do
        local new_region_name = dwarven_holds[region_list:item_at(i):name()]

        if new_region_name then
            cm:change_custom_settlement_name(region_list:item_at(i):settlement(), new_region_name)
        end
    end

    cm:set_saved_value("has_renamed_owned_holds", true)
end


local function add_dwarf_hold_listener()
    core:add_listener(
        "DwarfPlayerGetsRegion",
        "RegionFactionChangeEvent",
        function(context)
            return check_if_dwarf_player(context:region():owning_faction())
        end,
        function(context)
            rename_new_hold(context:region())
        end,
        true
    )
end


local function init()
    local has_not_renamed_owned_holds = not cm:get_saved_value("has_renamed_owned_holds")
    local player_faction = cm:get_local_faction()
    local run_every_start_up = settings.run_every_start_up

    if player_faction:subculture() == dwarf_culture then
        add_dwarf_hold_listener()

        if has_not_renamed_owned_holds or run_every_start_up then
            rename_owned_holds(player_faction)
        end
    end
end


core:add_listener(
    "RrhMctInitialized",
    "MctInitialized",
    true,
    function(context)
        local mct = context:mct()
        local mod = mct:get_mod_by_key("lw_rename_reclaimed_holds")

        local run_every_start_up = mod:get_option_by_key("lw_rename_on_every_start_up")
:get_finalized_setting()
        settings.run_every_start_up = run_every_start_up
    end,
    true
)


core:add_listener(
    "RrhMctFinalized",
    "MctFinalized",
    true,
    function(context)
        local mct = context:mct()
        local mod = mct:get_mod_by_key("lw_rename_reclaimed_holds")

        local run_every_start_up = mod:get_option_by_key("lw_rename_on_every_start_up"):get_finalized_setting()

        if run_every_start_up then
            rename_owned_holds(cm:get_local_faction())
        end
    end,
    true
)


cm:add_first_tick_callback(
    function()
        init()
    end
)
