% mandelbrot_boundary_analysis.m

% Create a folder to save results
folder_name = 'mandelbrot_results';
if ~exist(folder_name, 'dir')
    mkdir(folder_name);
end

%% 1. Implement the Mandelbrot Set Function
function it = fractal(c)
    z = 0;
    for it = 1:100
        z = z^2 + c;
        if abs(z) > 2.0
            return;
        end
    end
    it = 100;
end

%% 2. Visualize the Mandelbrot Set
N = 200;
x = linspace(-2.0, 1.0, N);
y = linspace(-1.0, 1.0, N);
[X, Y] = meshgrid(x, y);
C = X + Y * 1i;

IT = zeros(N, N);
for i = 1:N
    for j = 1:N
        IT(i, j) = fractal(C(i, j));
    end
end

figure;
imshow(IT, []);
colormap(jet);
colorbar;
title('Mandelbrot Set');
saveas(gcf, fullfile(folder_name, 'mandelbrot_set.png'));

%% 3. Implement the Bisection Method
function m = bisection(fn_f, s, e)
    tol = 1e-10;
    while abs(e - s) > tol
        m = (s + e) / 2;
        if fn_f(m) * fn_f(s) > 0
            s = m;
        else
            e = m;
        end
    end
end

%% 4. Find the Fractal Boundary
x_values = linspace(-2, 1, 1000);
y_boundary = zeros(size(x_values));

for i = 1:length(x_values)
    x = x_values(i);
    indicator_fn = @(y) (fractal(x + 1i * y) > 0) * 2 - 1;
    y_boundary(i) = bisection(indicator_fn, 0, 1);
end

figure;
plot(x_values, y_boundary, '.');
title('Mandelbrot Set Boundary');
xlabel('Real Part');
ylabel('Imaginary Part');
saveas(gcf, fullfile(folder_name, 'boundary_points.png'));

%% 5. Fit a Polynomial to the Boundary
valid_indices = (x_values > -1.8) & (x_values < 0.5);
x_fit = x_values(valid_indices);
y_fit = y_boundary(valid_indices);

p = polyfit(x_fit, y_fit, 15);

x_plot = linspace(min(x_fit), max(x_fit), 1000);
y_plot = polyval(p, x_plot);

figure;
plot(x_fit, y_fit, '.', x_plot, y_plot, 'r-');
legend('Boundary Points', 'Fitted Polynomial');
title('Polynomial Fit to Mandelbrot Set Boundary');
xlabel('Real Part');
ylabel('Imaginary Part');
saveas(gcf, fullfile(folder_name, 'polynomial_fit.png'));

%% 6. Implement Curve Length Calculation
function l = poly_len(p, s, e)
    dp = polyder(p);
    ds = @(x) sqrt(1 + polyval(dp, x).^2);
    l = integral(ds, s, e);
end

%% 7. Calculate the Boundary Length
s = min(x_fit);
e = max(x_fit);
boundary_length = poly_len(p, s, e);
fprintf('Approximate length of the Mandelbrot set boundary: %.4f\n', boundary_length);

% Save results to a text file
results_file = fullfile(folder_name, 'results.txt');
fid = fopen(results_file, 'w');
fprintf(fid, 'Approximate length of the Mandelbrot set boundary: %.4f\n', boundary_length);
fprintf(fid, '\nPolynomial coefficients:\n');
fprintf(fid, '%.6e\n', p);
fclose(fid);

% Save workspace variables
save(fullfile(folder_name, 'workspace.mat'));

disp(['Results saved in folder: ' folder_name]);