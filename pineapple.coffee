in_range = (x, a, b) =>
	(a <= x) == (x <= b)

is_cjk_punctuation = (char_code) ->
	in_range(char_code, 0x3000, 0x303f) or
	in_range(char_code, 0xff00, 0xffef)

is_cjk_character = (char_code) ->
	in_range(char_code, 0x3040, 0x312f) or
	in_range(char_code, 0x3200, 0x32ff) or
	in_range(char_code, 0x3400, 0x4dbf) or
	in_range(char_code, 0x4e00, 0x9fff) or
	in_range(char_code, 0x9fff, 0xf900)

insert_space = (text) ->
	segments = []
	start = 0
	end = 0
	previous_cjk_mode = false
	previous_cjk_pun_mode = false
	while start < text.length and end < text.length
		c = text.charCodeAt(end)
		current_cjk_pun_mode = is_cjk_punctuation(c)
		current_cjk_mode = current_cjk_pun_mode or is_cjk_character(c)
		if current_cjk_mode != previous_cjk_mode
			segments.push text.substring(start, end)
			if (current_cjk_mode and not current_cjk_pun_mode) or not (current_cjk_mode or previous_cjk_pun_mode)
				segments.push ' '
			start = end
		previous_cjk_mode = current_cjk_mode
		previous_cjk_pun_mode = current_cjk_pun_mode
		end++
	segments.push text.substring(start)
	segments.join('')
