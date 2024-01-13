return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.ai").setup()

    -- require("mini.align").setup()
    local align = require('mini.align')
    require("mini.align").setup({
      mappings = {
        start = '<leader>ma',
        start_with_preview = '<leader>mA',
      },
      modifiers = {
        i = function(steps, _) table.insert(steps.pre_split, align.gen_step.ignore_split({ '".-"', "'.-'" })) end,
      },
    })

    require("mini.basics").setup()

    -- require("mini.animate").setup()

    require("mini.bracketed").setup()

    require("mini.bufremove").setup()

    require("mini.comment").setup()

    require("mini.splitjoin").setup()

    require("mini.surround").setup()

    require("mini.indentscope").setup()

    -- require("mini.jump").setup({
    --   delay = {
    --     highlight = 10000000,
    --   },
    -- })

    -- require("mini.jump2d").setup()

    -- require("mini.pairs").setup()

    require("mini.move").setup({
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = "H",
        right = "L",
        down = "J",
        up = "K",

        -- Move current line in Normal mode
        line_left = '',
        line_right = '',
        line_down = '',
        line_up = '',
      },
    })

    -- require("mini.cursorword").setup()

    -- require("mini.tabline").setup()
    -- require("mini.statusline").setup({
    -- 	content = {
    -- 		active = function()
    --         local blocked_filetypes = {
    --           ['neo-tree'] = true,
    --           ['Outline'] = true,
    --           ['lspsagaoutline'] = true,
    --         }
    --         if blocked_filetypes[vim.bo.filetype] then
    --           return MiniStatusline.combine_groups({
    --             { hl = "MiniStatuslineInactive", strings = { "" } },
    --           })
    --         end
    --
    -- 			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
    -- 			local git = MiniStatusline.section_git({ trunc_width = 75 })
    -- 			local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
    -- 			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
    -- 			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
    -- 			local location = MiniStatusline.section_location({ trunc_width = 75 })
    --
    -- 			local git_blame = require("gitblame").get_current_blame_text()
    --         local recording = require("noice").api.statusline.mode.get()
    --
    -- 			return MiniStatusline.combine_groups({
    -- 				{ hl = mode_hl, strings = { mode } },
    -- 				{ hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
    -- 				"%<", -- Mark general truncate point
    -- 				-- { hl = "MiniStatuslineFilename", strings = { filename } },
    -- 				{ hl = "MiniStatuslineFilename", strings = { git_blame } },
    --           "%=", -- End left alignment
    -- 				{ hl = "MiniStatuslineFilename", strings = { recording } },
    -- 				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
    -- 				{ hl = mode_hl, strings = { location } },
    -- 			})
    -- 		end,
    -- 	},
    -- })

    require("mini.trailspace").setup()

    require("mini.sessions").setup()

    -- require("mini.fuzzy").setup()

    require('mini.files').setup({
      mappings = {
        close       = 'q',
        go_in       = 'l',
        go_in_plus  = '<CR>',
        go_out      = 'h',
        go_out_plus = 'H',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '=',
        trim_left   = '<',
        trim_right  = '>',
      },
    })
    vim.keymap.set("n", "-", ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", { desc = "Mini files" })

    local map_split = function(buf_id, lhs, direction)
      local rhs = function()
        -- Make new window and set it as target
        local new_target_window
        vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
          vim.cmd(direction .. ' split')
          new_target_window = vim.api.nvim_get_current_win()
        end)

        MiniFiles.set_target_window(new_target_window)
      end

      -- Adding `desc` will result into `show_help` entries
      local desc = 'Split ' .. direction
      vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak keys to your liking
        map_split(buf_id, 'gs', 'belowright horizontal')
        map_split(buf_id, 'gv', 'belowright vertical')
      end,
    })
    local miniclue = require('mini.clue')
    miniclue.setup({
      triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
      },

      clues = {
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
    });

    -- Mini starter
    local status, starter = pcall(require, "mini.starter")
    if not status then
      return
    end

    starter.setup({
      content_hooks = {
        starter.gen_hook.adding_bullet(""),
        starter.gen_hook.aligning("center", "center"),
        starter.gen_hook.indexing("all", {
          "Telescope",
          "Explorer",
          "Plugins",
          "Builtin actions",
        }),
      },
      evaluate_single = true,
      footer = os.date("%A, %m/%d/%Y %I:%M %p"),

      header = table.concat({
        [[  /\ \▔\___  ___/\   /(●)_ __ ___  ]],
        [[ /  \/ / _ \/ _ \ \ / / | '_ ` _ \ ]],
        [[/ /\  /  __/ (_) \ V /| | | | | | |]],
        [[\_\ \/ \___|\___/ \_/ |_|_| |_| |_|]],
        [[───────────────────────────────────]],
      }, "\n"),
      query_updaters = [[abcdefghilmnopqrstuvwxyz0123456789_-,.ABCDEFGHIJKLMNOPQRSTUVWXYZ]],
      items = {
        starter.sections.recent_files(9, true, false),
        { action = "Telescope find_files",  name = "F: Find Files",  section = "Telescope" },
        { action = "Telescope oldfiles",    name = "O: Old Files",   section = "Telescope" },
        { action = "Telescope live_grep",   name = "G: Grep Files",  section = "Telescope" },
        -- { action = "FzfLua files", name = "F: Find Files", section = "Telescope" },
        -- {
        -- 	action = function()
        -- 		require("fzf-lua").oldfiles({
        -- 			cwd_only = function()
        -- 				return vim.api.nvim_command("pwd") ~= vim.env.HOME
        -- 			end,
        -- 		})
        -- 	end,
        -- 	name = "O: Old Files",
        -- 	section = "Actions",
        -- },
        { action = "Neotree toggle",        name = "E: Neo-tree",    section = "Explorer" },
        { action = ":lua MiniFiles.open()", name = "-: MiniFiles",   section = "Explorer" },
        { action = "Lazy",                  name = "L: Lazy",        section = "Plugins" },
        { action = "Mason",                 name = "M: Mason",       section = "Plugins" },
        { action = "enew",                  name = "N: New Buffer",  section = "Builtin actions" },
        { action = "qall!",                 name = "Q: Quit Neovim", section = "Builtin actions" },
      },
    })

    vim.cmd([[
  augroup MiniStarterJK
    au!
    au User MiniStarterOpened nmap <buffer> j <Cmd>lua MiniStarter.update_current_item('next')<CR>
    au User MiniStarterOpened nmap <buffer> k <Cmd>lua MiniStarter.update_current_item('prev')<CR>
    " au User MiniStarterOpened nmap <buffer> <C-n> <Cmd>lua MiniStarter.update_current_item('next')<CR>
    " au User MiniStarterOpened nmap <buffer> <C-p> <Cmd>lua MiniStarter.update_current_item('prev')<CR>
  augroup END
]])
  end,
}