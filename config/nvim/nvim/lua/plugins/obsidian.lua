-- lua/plugins/obsidian.lua
--
-- Neovim-first Obsidian vault integration (leader = "o" for Obsidian stuff)

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },

    opts = {
      ui = {
        enable = false,
      },
      workspaces = {
        { name = "vault", path = "~/notes/obsidian" },
      },

      -- Default location for new notes (ObsidianNew, link-follow creation, etc.)
      notes_subdir = "notes",

      -- Daily notes
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
      },

      -- Use Obsidian-style [[wikilinks]]
      preferred_link_style = "wiki",

      -- If you use nvim-cmp, this enables completion for [[links]]
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      picker = {
        name = "telescope.nvim",
      },

      -- Turn wiki links into nice URLs when needed
      follow_url_func = function(url)
        vim.ui.open(url)
      end,

      -- Optional: keep frontmatter minimal and predictable
      -- (You can delete this whole block if you don't want frontmatter at all.)
      note_frontmatter_func = function(note)
        -- Only add frontmatter if you set tags or aliases later
        if (note.tags and #note.tags > 0) or (note.aliases and #note.aliases > 0) then
          return {
            aliases = note.aliases,
            tags = note.tags,
          }
        end
        return nil
      end,
    },

    config = function(_, opts)
      require("obsidian").setup(opts)

      -- Keymaps: <leader>o... is "Obsidian stuff"
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
      end

      map("<leader>od", "<cmd>ObsidianToday<CR>", "Obsidian: Today")
      map("<leader>oy", "<cmd>ObsidianYesterday<CR>", "Obsidian: Yesterday")
      map("<leader>ot", "<cmd>ObsidianTomorrow<CR>", "Obsidian: Tomorrow")

      map("<leader>on", "<cmd>ObsidianNew<CR>", "Obsidian: New note")
      map("<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", "Obsidian: Quick switch")

      map("<leader>ob", "<cmd>ObsidianBacklinks<CR>", "Obsidian: Backlinks")
      map("<leader>ol", "<cmd>ObsidianLinks<CR>", "Obsidian: Outgoing links")

      map("<leader>oo", "<cmd>ObsidianOpen<CR>", "Obsidian: Open in app")
      map("<leader>os", "<cmd>ObsidianSearch<CR>", "Obsidian: Search vault")
    end,
  },
}
