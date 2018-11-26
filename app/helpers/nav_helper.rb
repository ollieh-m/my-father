module NavHelper

	def open_menu_section?(part)
		current_section && current_section.part == part && !initial_load?
	end

end