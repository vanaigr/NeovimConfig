vim.opt.signcolumn = 'yes:1'

local ms = require('mark-signs')

ms.mark_builtin_options({ priority = 10, sign_hl = 'Comment' })
ms.mark_lower_options  ({ priority = 11, sign_hl = 'Normal', number_hl = 'CursorLineNr' })
ms.mark_upper_options  ({ priority = 12, sign_hl = 'Normal', number_hl = 'CursorLineNr' })
ms.mark_options('.', { hidden = true })

local function update()
    -- don't display marks in cmdwin
    if vim.fn.getcmdwintype() ~= '' then return end

    ms.update_marks()
end

if MarkSignsTimer then MarkSignsTimer:stop() end
local timer = vim.uv.new_timer()
MarkSignsTimer = timer

timer:start(0, 400, vim.schedule_wrap(function()
    local ok, msg = pcall(update)
    if not ok then
        timer:stop()
        vim.notify('mark-signs error: '..vim.inspect(msg), vim.log.levels.ERROR, {})
    end
end))
