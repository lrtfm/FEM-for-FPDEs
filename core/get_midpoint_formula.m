function qformula = get_midpoint_formula(interval, num)   
    a = interval(1);
    b = interval(2);
    h = (b - a)/num;
    qformula.alpha = a + ((1:num)'-1/2)*h;
    qformula.w = h*ones(num, 1);
end