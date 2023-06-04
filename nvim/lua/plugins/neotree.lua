return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v2.x",
  opts = {
    close_if_last_window = false,
    popup_border_style = "NC",
    filesystem = {
      follow_current_file = true,
      use_libuv_file_watcher = true,
      mappings = {
        ["/"] = "",
      },
    },
    window = {
      mappings = {
        ["o"] = function(state)
          local node = state.tree:get_node()
          if node and node.type == "file" then
            local file_path = node:get_id()
            -- reuse built-in commands to open and clear filter
            local cmds = require("neo-tree.sources.filesystem.commands")
            cmds.open(state)
            cmds.clear_filter(state)
            -- reveal the selected file without focusing the tree
            require("neo-tree.sources.filesystem").navigate(state, state.path, file_path)
          end
        end,
        ["="] = function(state)
          local node = state.tree:get_node()
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end,
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          --auto close
          require("neo-tree").close_all()
        end
      },
    }
  },
  init = function()
    vim.keymap.set("n", "<leader>e", ":Neotree toggle left<cr>", { desc = "Neotree toggle left" })
    vim.keymap.set("n", "<leader>E", ":Neotree toggle float<cr>", { desc = "Neotree toggle float" })
  end,
}
