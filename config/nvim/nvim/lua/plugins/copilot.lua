return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",

    -- ✅ allow :Copilot ... to exist even before InsertEnter (lazy-load on command)
    cmd = "Copilot",

    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false, -- disabled by default
          auto_trigger = false,
          keymap = {
            accept = "<C-j>",
            next = "<C-l>",
            prev = "<C-h>",
            dismiss = "<C-k>",
          },
        },
        panel = { enabled = false },
      })

      vim.api.nvim_set_hl(0, "CopilotSuggestion", {
        fg = "#ff79c6",
        italic = true,
        nocombine = true,
      })
    end,
  },
}
