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

-- Create a namespace for highlighting
local ns = vim.api.nvim_create_namespace("RainbowNamespace")

-- Default colors for rainbow parentheses
local default_colours = {
    Red = { fg = "#FF5252", rank = 1 },
    Pink = { fg = "#FF4081", rank = 2 },
    Purple = { fg = "#7E57C2", rank = 3 },
    DeepPurple = { fg = "#6200EA", rank = 4 },
    Indigo = { fg = "#3F51B5", rank = 5 },
    Blue = { fg = "#2196F3", rank = 6 },
    LightBlue = { fg = "#03A9F4", rank = 7 },
    Cyan = { fg = "#00BCD4", rank = 8 },
    Teal = { fg = "#009688", rank = 9 },
    Green = { fg = "#4CAF50", rank = 10 },
    LightGreen = { fg = "#8BC34A", rank = 11 },
    Lime = { fg = "#CDDC39", rank = 12 },
    Yellow = { fg = "#FFEB3B", rank = 13 },
    Amber = { fg = "#FFC107", rank = 14 },
    Orange = { fg = "#FF9800", rank = 15 },
    DeepOrange = { fg = "#FF5722", rank = 16 },
}

-- Function to set highlights for specified colors, sorted by `rank` values
local function default_set_highlights(colour_map)
    -- Convert the color map to a sortable list
    local sorted_colours = {}
    for colour_name, colour_attr in pairs(colour_map) do
        table.insert(sorted_colours, { name = colour_name, fg = colour_attr.fg, rank = colour_attr.rank or math.huge })
    end

    -- Sort by `rank`, then by name for consistent ordering if rank is absent
    table.sort(sorted_colours, function(a, b)
        if a.rank == b.rank then
            return a.name < b.name  -- Sort alphabetically if ranks are equal
        else
            return a.rank < b.rank
        end
    end)

    -- Apply highlights in sorted order
    for _, colour in ipairs(sorted_colours) do
        vim.api.nvim_set_hl(0, colour.name, { fg = colour.fg, bold = true })
    end
end

-- Function to apply the rainbow highlighting
local function rainbow(colour_map)
    local buffer = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local counter = 0
    local ps = Stack.new()
    vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)

    local colours = vim.tbl_keys(colour_map)  -- Get the sorted list of color names

    for i, line in ipairs(lines) do
        for j = 1, #line do
            local c = line:sub(j, j)
            if c == "'" or c == '"' then
                if ps:peek() == c then
                    ps:pop()
                else
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

-- Function to apply highlights and invoke rainbow logic
local function apply_rainbow(colour_map, set_highlights)
    set_highlights(colour_map)
    rainbow(colour_map)
end

-- Setup function to configure the plugin
function M.setup(opts)
    opts = opts or {}
    local colour_map = opts.colour_map or default_colours
    local set_highlights = opts.set_highlights or default_set_highlights

    -- Register autocommands for buffer events
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufReadPost", "TextChanged", "TextChangedI" }, {
        callback = function()
            apply_rainbow(colour_map, set_highlights)
        end,
        group = vim.api.nvim_create_augroup("RainbowParentheses", { clear = true }),
    })
end

return M
