-- Send selections, buffer mentions and prompts to the agent tmux panes
-- created by ~/.config/tmux/agent-layout.sh (coder / reviewer / architect,
-- tagged with the @agent_role pane option). Delivery goes through
-- ~/.config/tmux/agent-msg.sh: bracketed paste into the agent's input box,
-- then Enter to submit.

local MSG = vim.fn.expand("~/.config/tmux/agent-msg.sh")
local ROLES = { "coder", "planner", "architect" }

local function send(text, submit)
  if not text or text == "" then
    vim.notify("agent-panes: nothing to send", vim.log.levels.WARN)
    return
  end
  vim.ui.select(ROLES, { prompt = "Send to agent:" }, function(role)
    if not role then
      return
    end
    local cmd = { MSG }
    if not submit then
      cmd[#cmd + 1] = "--no-submit"
    end
    cmd[#cmd + 1] = role
    cmd[#cmd + 1] = text
    vim.system(cmd, { text = true }, function(res)
      if res.code ~= 0 then
        vim.notify("agent-panes: " .. vim.trim(res.stderr or "send failed"), vim.log.levels.ERROR)
      end
    end)
  end)
end

-- Live visual selection via getpos("v")/getpos(".") — captured while still in
-- visual mode, no need to leave it first.
local function visual_text()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" then
    return nil
  end
  local srow, scol = unpack(vim.fn.getpos("v"), 2, 3)
  local erow, ecol = unpack(vim.fn.getpos("."), 2, 3)
  if srow > erow or (srow == erow and scol > ecol) then
    srow, scol, erow, ecol = erow, ecol, srow, scol
  end
  local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
  if #lines == 0 then
    return nil
  end
  if mode == "v" then
    lines[#lines] = string.sub(lines[#lines], 1, ecol)
    lines[1] = string.sub(lines[1], scol)
  end
  return table.concat(lines, "\n")
end

local function leave_visual()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "n", false)
end

local ok, wk = pcall(require, "which-key")
if ok then
  wk.add({ { "<leader>a", group = "agents" } })
end

vim.keymap.set("x", "<leader>as", function()
  local text = visual_text()
  leave_visual()
  send(text, true)
end, { desc = "Send selection to agent" })

vim.keymap.set("n", "<leader>ab", function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  if path == "" then
    vim.notify("agent-panes: buffer has no file name", vim.log.levels.WARN)
    return
  end
  -- No submit: the @mention waits in the input box, question gets typed in the TUI.
  send("@" .. path .. " ", false)
end, { desc = "Mention buffer in agent" })

vim.keymap.set("n", "<leader>ap", function()
  vim.ui.input({ prompt = "Agent prompt: " }, function(text)
    send(text, true)
  end)
end, { desc = "Prompt agent" })
