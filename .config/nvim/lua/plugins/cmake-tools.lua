return {
  "Civitasv/cmake-tools.nvim",
  lazy = true,
  init = function()
    local loaded = false
    local function check()
      local cwd = vim.uv.cwd()

      if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
        require("lazy").load({ plugins = { "cmake-tools.nvim" } })
        loaded = true
      end
    end
    check()
    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        if not loaded then
          check()
        end
      end,
    })
  end,
  opts = {
    cmake_build_directory = "build/",
    cmake_virtual_text_support = false,
  },
  config = function(_, opts)
    require("cmake-tools").setup(opts)
    vim.keymap.set("n", "<F6>", ":CMakeBuild<CR>", { desc = "CMake: Build" })
  end,
}
