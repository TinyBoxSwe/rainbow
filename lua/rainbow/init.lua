local M = {}
local Stack = {}

-- Stack implementation remains the same
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

-- Default colors for rainbow parentheses
local default_colours = {
    { name = "Red",        fg = "#FF5252", bold = true }, -- Material Red
    { name = "Pink",       fg = "#FF4081", bold = true }, -- Material Pink
    { name = "Purple",     fg = "#7E57C2", bold = true }, -- Material Purple
    { name = "DeepPurple", fg = "#6200EA", bold = true }, -- Material Deep Purple
    { name = "Indigo",     fg = "#3F51B5", bold = true }, -- Material Indigo
    { name = "Blue",       fg = "#2196F3", bold = true }, -- Material Blue
    { name = "LightBlue",  fg = "#03A9F4", bold = true }, -- Material Light Blue
    { name = "Cyan",       fg = "#00BCD4", bold = true }, -- Material Cyan
    { name = "Teal",       fg = "#009688", bold = true }, -- Material Teal
    { name = "Green",      fg = "#4CAF50", bold = true }, -- Material Green
    { name = "LightGreen", fg = "#8BC34A", bold = true }, -- Material Light Green
    { name = "Lime",       fg = "#CDDC39", bold = true }, -- Material Lime
    { name = "Yellow",     fg = "#FFEB3B", bold = true }, -- Material Yellow
    { name = "Amber",      fg = "#FFC107", bold = true }, -- Material Amber
    { name = "Orange",     fg = "#FF9800", bold = true }, -- Material Orange
    { name = "DeepOrange", fg = "#FF5722", bold = true }, -- Material Deep Orange
}

local function set_highlights(colours)
    for _, colour in ipairs(colours) do
        vim.api.nvim_set_hl(0, colour.name, { fg = colour.fg, bold = colour.bold })
    end
end

local function rainbow(colour_map)
    local buffer = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local counter = 0
    local ps = Stack:new()
    vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)

    local colours = vim.tbl_keys(colour_map)

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
                local colour_index = counter % #colours
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

local function apply_rainbow(colour_map)
    set_highlights(colour_map)
    rainbow(colour_map)
end

function M.setup(opts)
    opts = opts or {}
    local colour_map = opts.colour_map or default_colours

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufReadPost", "TextChanged", "TextChangedI" }, {
        callback = function()
            apply_rainbow(colour_map)
        end,
        group = vim.api.nvim_create_augroup("RainbowParentheses", { clear = true }),
    })
end

return M
