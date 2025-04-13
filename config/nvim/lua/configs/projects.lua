local M = {}

-- folders
M.dev = { "~/repositories" }

-- individually marked
M.projects = { "~/dotfiles", "~/.config/nvim" }

M.confirm = function(picker, item)
	picker:close()
	if not item then return end

	vim.fn.chdir(item.file)
	local session_found = vim.fn.filereadable(item.file .. "/" .. MiniSessions.config.file)

	if session_found == 1 then
		vim.notify("Project session found!")
		MiniSessions.read(MiniSessions.config.file)
	else
		vim.notify("Creating project session...")
		MiniSessions.write(MiniSessions.config.file)
	end
end

return M
