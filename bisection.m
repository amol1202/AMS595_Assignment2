function m = bisection(fn_f, s, e)
    tol = 1e-5;
    while (abs(e - s) > tol)
        m = (s + e) / 2;
        if fn_f(m) * fn_f(s) < 0
            e = m;
        else
            s = m;
        end
    end
    m = (s + e) / 2;
end
