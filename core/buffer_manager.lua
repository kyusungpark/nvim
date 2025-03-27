local M = {}

-- Function to close empty and unnamed buffers
function M.close_empty_unnamed_buffers()
  -- Get a list of all buffers
  local buffers = vim.api.nvim_list_bufs()

  -- Iterate over each buffer
  for _, bufnr in ipairs(buffers) do
    -- Check if the buffer is empty and doesn't have a name
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) == '' and
        vim.api.nvim_buf_get_option(bufnr, 'buftype') == '' then

      -- Get all lines in the buffer
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      -- Calculate total characters
      local total_characters = 0
      for _, line in ipairs(lines) do
        total_characters = total_characters + #line
      end

      -- Close the buffer if it's empty:
      if total_characters == 0 then
        vim.api.nvim_buf_delete(bufnr, {
          force = true
        })
      end
    end
  end
end

-- Function to handle the clean startup
function M.handle_startup()
  -- Only run this if no arguments were passed (empty startup)
  if vim.fn.argc() == 0 then
    -- First close any empty buffers
    M.close_empty_unnamed_buffers()
    -- Then open NvimTree
    vim.cmd("NvimTreeToggle")
  end
end

return M
