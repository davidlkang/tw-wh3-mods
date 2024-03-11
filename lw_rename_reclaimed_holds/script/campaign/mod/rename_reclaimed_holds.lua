local run_every_start_up = false
local dwarf_culture = "wh_main_sc_dwf_dwarfs"
local dwarf_holds
local run_for_ai = false


local function check_campaign_compatibility()
    local campaign_name = cm:model():campaign_name_key()
    local running_suported_campaign

    if campaign_name == "wh3_main_combi" then
        running_suported_campaign = true
        dwarf_holds = require("script/campaign/mod/hold_names_ie")
    elseif campaign_name == "cr_combi_expanded" then
        running_suported_campaign = true
        dwarf_holds = require("script/campaign/mod/hold_names_ie")
    elseif campaign_name == "cr_oldworld" then
        running_suported_campaign = true
        dwarf_holds = require("script/campaign/mod/hold_names_tow")
    else
        running_suported_campaign = false
        out("You are running a campaign different then IE or TOW. This mod only works with these campaigns.")
    end

    return running_suported_campaign
end


local function check_if_dwarf_player(faction)
    local is_player = faction:is_human()
    local is_dwarf_culture = faction:subculture() == dwarf_culture
    local should_run

    if is_dwarf_culture then
        if run_for_ai then
            should_run = true
        elseif is_player then
            should_run = true
        end
    else
        should_run = false
    end

    return should_run
end


local function rename_new_hold(region)
    local new_region_name = dwarf_holds[region:name()]

    if new_region_name then
        cm:change_custom_settlement_name(region:settlement(), new_region_name)
    end
end


local function rename_owned_holds(faction)
    local region_list = faction:region_list()
    local number_of_regions = region_list:num_items()

    for i = 0, number_of_regions - 1 do
        local new_region_name = dwarf_holds[region_list:item_at(i):name()]

        if new_region_name then
            cm:change_custom_settlement_name(region_list:item_at(i):settlement(), new_region_name)
        end
    end
end


local function rename_owned_holds_all(player_faction)
    local dwarf_factions = player_faction:factions_of_same_subculture()
    local number_of_dwarf_factions = dwarf_factions:num_items()

    for i = 0, number_of_dwarf_factions - 1 do
        rename_owned_holds(dwarf_factions:item_at(i))
    end
end


local function add_dwarf_hold_listener()
    core:add_listener(
        "DwarfFactionGetsRegion",
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


local function add_mct_finalized_listener()
    core:add_listener(
        "RrhMctFinalized",
        "MctFinalized",
        true,
        function(context)
            local mct = context:mct()
            local mod = mct:get_mod_by_key("lw_rename_reclaimed_holds")

            if mod:get_option_by_key("lw_rename_on_every_start_up"):get_finalized_setting() then
                rename_owned_holds(cm:get_local_faction())
            end

            if mod:get_option_by_key("lw_run_for_ai"):get_finalized_setting() then
                rename_owned_holds_all(cm:get_local_faction())
            end
        end,
        true
    )
end


local function init()
    local has_not_renamed_owned_holds = not cm:get_saved_value("has_renamed_owned_holds")
    local player_faction = cm:get_local_faction()

    add_mct_finalized_listener()

    if player_faction:subculture() == dwarf_culture or run_for_ai then
        add_dwarf_hold_listener()

        if has_not_renamed_owned_holds or run_every_start_up then
            if run_for_ai then
                rename_owned_holds_all(player_faction)
            else
                rename_owned_holds(player_faction)
            end

           cm:set_saved_value("has_renamed_owned_holds", true)
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

        run_every_start_up = mod:get_option_by_key("lw_rename_on_every_start_up"):get_finalized_setting()
        run_for_ai = mod:get_option_by_key("lw_run_for_ai"):get_finalized_setting()
    end,
    true
)


cm:add_first_tick_callback(
    function()
        if check_campaign_compatibility() then
            init()
        end
    end
)
