function l = poly_len(p, s, e)
    ds = @(x) sqrt(1 + (polyval(polyder(p), x)).^2);
    l = integral(ds, s, e);
end
