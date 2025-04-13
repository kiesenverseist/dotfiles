local M = {}

M.finder = function()
	local notifs = require("fidget").notification.get_history()
	local items = {}

	for _, notif in ipairs(notifs) do
		items[#items + 1] = {
			text = Snacks.picker.util.text(notif, { "annote", "group_name", "message" }),
			item = notif,
			severity = notif.annote,
			preview = {
				text = notif.message,
				ft = "markdown",
			},
		}
	end

	return items
end

M.format = function(item, picker)
	local a = Snacks.picker.util.align
	local ret = {}
	local notif = item.item ---@type HistoryItem
	ret[#ret + 1] = { a(os.date("%R", notif.last_updated), 5), "SnacksPickerTime" }
	ret[#ret + 1] = { " " }
	if item.severity then
		vim.list_extend(ret, Snacks.picker.format.severity(item, picker))
	else
		ret[#ret + 1] = { "   " }
	end
	-- ret[#ret + 1] = { " " }
	-- ret[#ret + 1] = { notif.group_icon or " ", "SnacksNotifierHistoryTitle" }
	ret[#ret + 1] = { " " }
	ret[#ret + 1] = { a(notif.annote or "", 6), notif.style }
	ret[#ret + 1] = { " " }
	ret[#ret + 1] = { notif.message, "SnacksPickerNotificationMessage" }
	Snacks.picker.highlight.markdown(ret)
	return ret
end

M.preview = "preview"

return M
