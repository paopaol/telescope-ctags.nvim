local telescope_installed, telescope = pcall(require, 'telescope')

if not telescope_installed then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

local actions = require('telescope.actions')
local actions_set = require 'telescope.actions.set'
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')

function string:split(sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields + 1] = c end)
  return fields
end

local function ctags_function(opts)
  local find_command = function()
    return {
      "ctags", "-u", "-x", "--c++-kinds=fp", "--language-force=C++", "-f", "-",
      vim.fn.expand("%")
    }
  end

  local display_items = {{width = 4}, {remaining = true}}
  table.insert(display_items, 2, {width = 100})

  local displayer = entry_display.create {
    separator = " │ ",
    items = display_items
  }

  local make_display = function(entry)
    return displayer {
      {entry.lnum, 'TelescopeResultsSpecialComment'},
      {entry.value, 'TelescopeResultsFunction'}
    }
  end

  opts.entry_maker = function(line)
    local t = string.split(line, " ")
    table.remove(t, 1);
    table.remove(t, 1);
    local number = table.remove(t, 1);
    local path = table.remove(t, 1);
    local text = table.concat(t, " ");
    return {
      display = make_display,
      value = text,
      ordinal = text,
      filename = path,
      lnum = number and tonumber(number) or 1
    }
  end

  pickers.new(opts, {
    prompt_title = 'Ctags Function',
    finder = finders.new_oneshot_job(find_command(), opts),
    sorter = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function()
        local entry = actions.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd(string.format('e %s', entry.filename))
        vim.cmd(string.format('normal! %dG', entry.lnum))
      end)
      return true
    end
  }):find()
end

return telescope.register_extension {exports = {functions = ctags_function}}
