return {
  "stevearc/oil.nvim",
  init = function()
    vim.keymap.set("n", "-", "<Cmd>lua require('oil').toggle_float()<CR>", { noremap = true, silent = true })
  end,
  opts = {
    default_file_explorer = false,
    float = {
      max_width = 50,
      max_height = 20,
    },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<leader><c-v>"] = "actions.select_vsplit",
      ["<leader><c-s>"] = "actions.select_split",
      ["<leader><c-t>"] = "actions.select_tab",
      ["<leader><c-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<leader><c-r>"] = "actions.refresh",
      ["<BS>"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["g."] = "actions.toggle_hidden",
    },
    use_default_keymaps = false,
  },
}