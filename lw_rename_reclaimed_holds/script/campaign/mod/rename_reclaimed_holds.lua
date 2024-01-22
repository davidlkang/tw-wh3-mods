local dwarf_culture = "wh_main_sc_dwf_dwarfs"
local dwarven_holds = {
    ["cr_oldworld_region_pillars_of_grungni"] = "Test",
    ["cr_oldworld_region_karaz_a_karak"] = "Test",
    ["cr_oldworld_region_gundriksons_mines"] = "Test"
}


local function check_if_dwarf_player(context)
    local is_player = context:region():owning_faction():is_human()
    local is_dwarf_culture = context:region():owning_faction():subculture() == dwarf_culture

    if is_player and is_dwarf_culture then
        return true
    end
end


local function rename_new_hold(context)
    local new_region_name = dwarven_holds[context:region():name()]

    if new_region_name then
        cm:change_custom_settlement_name(context:region():settlement(), new_region_name)
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
        check_if_dwarf_player,
        rename_new_hold,
        true
    )
end


local function init()
    local has_not_renamed_owned_holds = not cm:get_saved_value("has_renamed_owned_holds")
    local player_faction = cm:get_local_faction()

    if player_faction:subculture() == dwarf_culture then
        add_dwarf_hold_listener()

        if has_not_renamed_owned_holds then
            rename_owned_holds(player_faction)
        end
    end
end


cm:add_first_tick_callback(
    init
)
