require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

require("augment-command"):setup({
    prompt = false,
    default_item_group_for_prompt = "hovered",
    smart_enter = true,
    smart_paste = true,
    smart_tab_create = true,
    smart_tab_switch = false,
    confirm_on_quit = true,
    open_file_after_creation = false,
    enter_directory_after_creation = false,
    use_default_create_behaviour = false,
    enter_archives = true,
    extract_retries = 3,
    recursively_extract_archives = true,
    preserve_file_permissions = false,
    encrypt_archives = false,
    encrypt_archive_headers = false,
    reveal_created_archive = true,
    remove_archived_files = false,
    must_have_hovered_item = true,
    skip_single_subdirectory_on_enter = false,
    skip_single_subdirectory_on_leave = false,
    smooth_scrolling = false,
    scroll_delay = 0.02,
    wraparound_file_navigation = false,
})

require("git"):setup()
