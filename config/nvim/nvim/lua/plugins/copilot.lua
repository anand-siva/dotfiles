-- lua/plugins/copilot.lua
return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-j>",
            next = "<C-l>",
            prev = "<C-h>",
            dismiss = "<C-k>",
          },
        },
        panel = { enabled = false },
      })

      -- 🔮 Dracula pink / purple Copilot ghost text
      vim.api.nvim_set_hl(0, "CopilotSuggestion", {
        fg = "#ff79c6", -- Dracula pink
        italic = true,
        nocombine = true,
      })
    end,
  },
}
