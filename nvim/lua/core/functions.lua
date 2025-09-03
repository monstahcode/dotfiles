local M = {}

--- Go to or create the *`n`*th tab
---@param n integer
function M.tabnm(n)
	return function()
		local tabs = vim.api.nvim_list_tabpages()
		if n > #tabs then
			vim.cmd("$tabnew")
		else
			local tabpage = tabs[n]
			vim.api.nvim_set_current_tabpage(tabpage)
		end
	end
end

--- Put the `char` variable at the beginning of the line. If present, remove it
---@param chars string
function M.put_at_end(chars)
	local pos = vim.api.nvim_win_get_cursor(0)
	local row = pos[1] - 1
	local current_line = vim.api.nvim_get_current_line()
	local col = #current_line
	local entry_length = string.len(chars)
	---@diagnostic disable-next-line: param-type-mismatch
	local cline = vim.fn.getline(".")
	---@diagnostic disable-next-line: param-type-mismatch
	local endchar = vim.fn.getline("."):sub(cline:len() - (entry_length - 1))
	if endchar == chars then
		---@diagnostic disable-next-line: param-type-mismatch
		vim.api.nvim_set_current_line(cline:sub(1, cline:len() - entry_length))
	else
		vim.api.nvim_buf_set_text(0, row, col, row, col, { chars })
	end
end

--- Put the `char` variable at the end of the line. If present, remove it
---@param chars string
function M.put_at_beginning(chars)
	---@diagnostic disable-next-line: param-type-mismatch
	local cline = vim.fn.getline(".")
	---@diagnostic disable-next-line: param-type-mismatch
	-- vim.api.nvim_set_current_line(cline:sub(1, cline:len()-1))
	local pos = vim.api.nvim_win_get_cursor(0)
	local row = pos[1] - 1
	local col = 0
	local entry_length = string.len(chars)
	---@diagnostic disable-next-line: param-type-mismatch
	local start_chars = string.sub(vim.fn.getline("."), 0, entry_length)
	if start_chars == chars then
		---@diagnostic disable-next-line: param-type-mismatch
		vim.api.nvim_set_current_line(cline:sub((entry_length + 1), cline:len()))
	else
		vim.api.nvim_buf_set_text(0, row, col, row, col, { chars })
	end
end

--- Dumb but useful function to increase markdown headers
function M.increase_header()
	---@diagnostic disable-next-line: param-type-mismatch
	local cline = vim.fn.getline(".")
	---@diagnostic disable-next-line: param-type-mismatch
	local header = vim.fn.getline("."):sub(1, 8)
	if header:find("# ") then
		---@diagnostic disable-next-line: param-type-mismatch
		vim.api.nvim_set_current_line("#" .. cline)
	else
		vim.notify("No headers, creating one")
		vim.api.nvim_set_current_line("# " .. cline)
	end
end

--- Dumb but useful function to decrease markdown headers
function M.decrease_header()
	---@diagnostic disable-next-line: param-type-mismatch
	local cline = vim.fn.getline(".")
	---@diagnostic disable-next-line: param-type-mismatch
	local header = vim.fn.getline("."):sub(1, 8)
	if string.match(header, "# ") or string.match(header, " ") then
		---@diagnostic disable-next-line: param-type-mismatch
		vim.api.nvim_set_current_line(cline:sub(2, cline:len()))
	else
		vim.notify("No headers, not removing anything")
	end
end

--- Navigate to other windows in the tab by window number, not ID
---@param num integer
function M.navigate(num)
	local nrs = {}
	local ids = {}
	---@type table<integer>
	local windows = vim.tbl_filter(function(id)
		return vim.api.nvim_win_get_config(id).relative == ""
	end, vim.api.nvim_tabpage_list_wins(0))

	for _, win in ipairs(windows) do
		local number = vim.api.nvim_win_get_number(win)

		table.insert(nrs, number)
		ids[number] = win
	end
	vim.api.nvim_set_current_win(ids[num])
end

--- Moves [count] up and down the selected lines
function M.visual_move(count, min_count, pos_1, pos_2, fix_num, cmd_start)
	vim.cmd([[execute "normal! \<esc>"]])

	local get_to_move = function()
		if count <= min_count then
			return min_count
		else
			return count - (vim.fn.line(pos_1) - vim.fn.line(pos_2)) + fix_num
		end
	end

	local to_move = get_to_move()
	vim.cmd(cmd_start .. to_move)

	local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))

	vim.cmd("normal! `]")
	local end_cursor_pos = vim.api.nvim_win_get_cursor(0)
	local end_row = end_cursor_pos[1]
	local end_line = vim.api.nvim_get_current_line()
	local end_col = #end_line
	vim.api.nvim_buf_set_mark(0, "z", end_row, end_col, {})

	vim.cmd("normal! `[")
	local start_cursor_pos = vim.api.nvim_win_get_cursor(0)
	local start_row = start_cursor_pos[1]
	vim.api.nvim_win_set_cursor(0, { start_row, 0 })

	vim.cmd("normal! =`z")
	vim.api.nvim_win_set_cursor(0, { cur_row, cur_col })
	vim.cmd("normal! gv")
end


--- Swap current char with the previous one
function M.swap_char_b()
	local pos = vim.api.nvim_win_get_cursor(0)
	local prev_colnr = pos[2]
	local colnr = pos[2] + 1
	if not prev_colnr then
		print("Go forward a char to swap")
		return
	end
	---@diagnostic disable-next-line: param-type-mismatch
	local curchar = vim.fn.getline("."):sub(colnr, colnr)
	---@diagnostic disable-next-line: param-type-mismatch
	local prevchar = vim.fn.getline("."):sub(prev_colnr, prev_colnr)
	local concatted = curchar .. prevchar
	vim.api.nvim_buf_set_text(0, pos[1] - 1, (prev_colnr - 1), pos[1] - 1, colnr, { concatted })
end

--- Swap current char with the next one
function M.swap_char_f()
	local pos = vim.api.nvim_win_get_cursor(0)
	local colnr = pos[2] + 1
	local next_colnr = pos[2] + 2
	---@diagnostic disable-next-line: param-type-mismatch
	local curchar = vim.fn.getline("."):sub(colnr, colnr)
	---@diagnostic disable-next-line: param-type-mismatch
	local nextchar = vim.fn.getline("."):sub(next_colnr, next_colnr)
	local concatted = nextchar .. curchar
	vim.api.nvim_buf_set_text(0, pos[1] - 1, (colnr - 1), pos[1] - 1, next_colnr, { concatted })
end

--- Code runner
---@param height integer
function M.runner(height)
	local fts = {
		rust = "cargo run",
		python = "python3 %",
		javascript = "npm start",
		c = "make",
		cpp = "make",
		java = "java %",
	}

	local cmd = fts[vim.bo.filetype]
  -- stylua: ignore
  vim.cmd(
    cmd and ("w | " .. (height or "") .. "sp | term " .. cmd)
    or "echo 'No runner for this filetype'")
end

--- Markdown codeblock machine using `vim.ui.input`
function M.md_block()
	vim.ui.input({ prompt = "Block language?" }, function(lang)
		local enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
		local escape = vim.api.nvim_replace_termcodes("<C-o>k", true, false, true)
		vim.api.nvim_feedkeys([[o```]] .. lang .. enter .. enter .. [[```]] .. escape, "n", true)
	end)
end

--- Cursor lock for navigating code - Credit to @b0o
function M.cursor_lock(lock)
	return function()
		local win = vim.api.nvim_get_current_win()
		local augid = vim.api.nvim_create_augroup("user_cursor_lock_" .. win, { clear = true })
		if not lock or vim.w.cursor_lock == lock then
			vim.w.cursor_lock = nil
			vim.notify("Cursor lock disabled")
			return
		end
		local cb = function()
			if vim.w.cursor_lock then
				vim.print("no error")
				vim.cmd("silent normal z" .. vim.w.cursor_lock)
				vim.print("after error")
			end
		end
		vim.w.cursor_lock = lock
		vim.api.nvim_create_autocmd("CursorMoved", {
			desc = "Cursor lock for window " .. win,
			buffer = 0,
			group = augid,
			callback = cb,
		})
		cb()
		vim.notify("Cursor lock enabled")
	end
end

--- Registry cleaner
function M.clear_reg()
	print("Clearing registers")
	vim.cmd([[
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
    call setreg(r, [])
    endfor
    ]])
end
-- Clearing the registers?
vim.api.nvim_create_user_command("ClearReg", function()
	M.clear_reg()
end, {})
vim.keymap.set("n", "<leader>cr", "<cmd>ClearReg<CR>", { desc = "Clear registers" })

vim.api.nvim_create_user_command("SF", function()
	vim.cmd("'<,'>!sql-formatter")
end, {})

return M
