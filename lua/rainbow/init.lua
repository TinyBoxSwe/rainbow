local M = {}
local Stack = {}

function Stack.new()
    return setmetatable({ items = {}, size = 0 }, { __index = Stack })
end

function Stack:push(item)
    self.size = self.size + 1
    table.insert(self.items, item)
end

function Stack:get_size()
    return self.size
end

function Stack:pop()
    if self.size <= 0 then
        error("Size of the stack is already at the lowest allowed size!")
    end
    local item = self.items[self.size]
    self.items[self.size] = nil
    self.size = self.size - 1
    return item
end

function Stack:peek()
    if self.size == 0 then
        return nil
    end
    return self.items[self.size]
end

local ns = vim.api.nvim_create_namespace("RainbowNamespace")

local function set_highlights()
    vim.api.nvim_set_hl(0, 'Red', { fg = "#FF5252", bold = true })                      
    vim.api.nvim_set_hl(0, 'Pink', { fg = "#FF4081", bold = true })                     
    vim.api.nvim_set_hl(0, 'Purple', { fg = "#7E57C2", bold = true })                   
    vim.api.nvim_set_hl(0, 'DeepPurple', { fg = "#6200EA", bold = true })               
    vim.api.nvim_set_hl(0, 'Indigo', { fg = "#3F51B5", bold = true })                   
    vim.api.nvim_set_hl(0, 'Blue', { fg = "#2196F3", bold = true })                     
    vim.api.nvim_set_hl(0, 'LightBlue', { fg = "#03A9F4", bold = true })                
    vim.api.nvim_set_hl(0, 'Cyan', { fg = "#00BCD4", bold = true })                     
    vim.api.nvim_set_hl(0, 'Teal', { fg = "#009688", bold = true })                     
    vim.api.nvim_set_hl(0, 'Green', { fg = "#4CAF50", bold = true })                    
    vim.api.nvim_set_hl(0, 'LightGreen', { fg = "#8BC34A", bold = true })               
    vim.api.nvim_set_hl(0, 'Lime', { fg = "#CDDC39", bold = true })                     
    vim.api.nvim_set_hl(0, 'Yellow', { fg = "#FFEB3B", bold = true })                   
    vim.api.nvim_set_hl(0, 'Amber', { fg = "#FFC107", bold = true })                    
    vim.api.nvim_set_hl(0, 'Orange', { fg = "#FF9800", bold = true })                   
    vim.api.nvim_set_hl(0, 'DeepOrange', { fg = "#FF5722", bold = true })               

    vim.api.nvim_set_hl(0, 'Fallback', { fg = "#FFFFFF", bold = true, bg = "#FF0000" }) 
end

local colours = {
    "Red", "Pink", "Purple", "DeepPurple", "Indigo", "Blue", 
    "LightBlue", "Cyan", "Teal", "Green", "LightGreen", 
    "Lime", "Yellow", "Amber", "Orange", "DeepOrange"
}

local function rainbow()
    local buffer = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local counter = 0
    local ps = Stack:new()
    vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)

    for i, line in ipairs(lines) do
        for j = 1, #line do
            local c = line:sub(j, j)
            if c == "'" or c == '"' then
                if ps:peek() == c then
                    ps:pop()
                elseif ps:get_size() == 0 then
                    ps:push(c)
                end
            end

            if ps:get_size() > 0 then
                goto continue
            end

            if c == '(' or c == '[' or c == '{' then
                counter = counter + 1
                local colour_index = (counter - 1) % #colours + 1
                vim.api.nvim_buf_set_extmark(buffer, ns, i - 1, j - 1, {
                    hl_group = colours[colour_index],
                    end_line = i - 1,
                    end_col = j,
                })
            elseif c == ')' or c == ']' or c == '}' then
                local colour_index = counter % #colours + 1
                vim.api.nvim_buf_set_extmark(buffer, ns, i - 1, j - 1, {
                    hl_group = colours[colour_index],
                    end_line = i - 1,
                    end_col = j,
                })
                counter = math.max(counter - 1, 0)
            end

            ::continue::
        end
    end
end

local function apply_rainbow()
    set_highlights()
    rainbow()
end

function M.setup()
    -- Register autocommands for buffer events
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufReadPost", "TextChanged", "TextChangedI" }, {
        callback = apply_rainbow,
        group = vim.api.nvim_create_augroup("RainbowParentheses", { clear = true }),
    })
end

return M
