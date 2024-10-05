function it = fractal(c)
    z = 0;
    it = 0;
    maxIter = 100;
    while (abs(z) <= 2.0 && it < maxIter)
        z = z^2 + c;
        it = it + 1;
    end
    if (it == maxIter)
        it = 0; % Remains within the Mandelbrot set
    end
end
