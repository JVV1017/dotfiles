require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

vim.keymap.set("n", "<leader>rn", function()
   local file_name = vim.api.nvim_buf_get_name(0)
   local file_type = vim.bo.filetype
   local command

   if file_type == "lua" then
      command = "lua " .. file_name
   elseif file_type == "c" then
      local temp_output = os.tmpname() -- Create a temporary file name
      command = "gcc " .. file_name .. " -o " .. temp_output .. " && " .. temp_output .. " && rm " .. temp_output
   elseif file_type == "cpp" then
      local temp_output = os.tmpname() -- Create a temporary file name
      command = "g++ " .. file_name .. " -o " .. temp_output .. " && " .. temp_output .. " && rm " .. temp_output
   elseif file_type == "python" then
      command = "python3 " .. file_name
   elseif file_type == "java" then
      local class_name = vim.fn.fnamemodify(file_name, ":t:r") -- Get the class name without the .java extension
      local dir_name = vim.fn.fnamemodify(file_name, ":h") -- Get the directory of the file
      local class_file = class_name .. ".class" -- The .class file to remove
      command = "cd "
         .. dir_name
         .. " && javac "
         .. vim.fn.fnamemodify(file_name, ":t")
         .. " && java "
         .. class_name
         .. " && rm "
         .. class_file
   elseif file_type == "cs" then
      local exe_name = vim.fn.fnamemodify(file_name, ":r") .. ".exe"
      command = "mcs " .. file_name .. " -out:" .. exe_name .. " && mono " .. exe_name .. " && rm " .. exe_name
   else
      print("Unsupported file type: " .. file_type)
      return
   end

   -- Run the command in a terminal
   vim.cmd(":terminal " .. command)
end)

-- Uncomment the following line if you want to map <C-s> to save in normal, insert, and visual modes
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
