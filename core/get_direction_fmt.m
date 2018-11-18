function fmt = get_direction_fmt(direction)
    fmt = ['([', repmat('%g ,', 1, length(direction)-1), '%g])'];
end