% Parameters

xStart = 0;
yStart = 0;
xEnd = 5;
yEnd = 5;
nxPoints = 1000;
nyPoints = 1000;

% Change this one to see the changing complication in the pattern
octaves = [3];

% To see the effect of different octave parameter
for octave = octaves
       
    % Create texture
    [f] = perlinTexture2D(xStart, xEnd, yStart, yEnd, nxPoints, nyPoints, octave);
    
    % Plot it!
    figure;
    s = surf(f);
    s.EdgeColor = 'none';
    figure;
    imshow(f);
end

function y = interpolate(a0, a1, t)
% 1D interpolation
y = a0 + t .* (a1 - a0);

end

function y = smoothstep(t)
% Smoothstep function
y = t .* t .* (3 - 2 .* t);

end

function gridGradient = generateGridGradient(ix, iy)
% Random gradient generator.
% It is basically a random unit vector generator.
gridGradient = rand(ix, iy) * 2 * pi;

gridGradient = cat(3, cos(gridGradient), sin(gridGradient));

end

function noise = generatePerlinNoiseForPoint(gridGradient, p)


% Seperate x and y coordinates
x = p(1);
y = p(2);

% Get the grid coordinates for 4 corner
ps = cat(1, [floor(x), ceil(y)], ...
    [ceil(x), ceil(y)], ...
    [floor(x), floor(y)], ...
    [ceil(x), floor(y)]);


% Fetch the gradients from the look-up table for these corner points
for k = 1:size(ps, 1)
    
   grad_(k, :) = [gridGradient(ps(k, 1), ps(k, 2),1) gridGradient(ps(k, 1), ps(k, 2),1)];
    
end

% Get the distances between the points and the grid points and
% calculate the dot product between gradients
pDotVector = sum((grad_ .* (p - ps)), 2);


% Calculate the interpolation ratios
s1 = smoothstep(x - floor(x));
s2 = smoothstep(y - floor(y));

% First, interpolate between left and right points;
% then, interpolate between top and bottom parts.
x1 = interpolate(pDotVector(3), pDotVector(4), s1);
x2 = interpolate(pDotVector(1), pDotVector(2), s1);

noise = interpolate(x1, x2, s2);

end

function [f] = perlinTexture2D(xStart, xEnd, yStart, yEnd, nxPoints, nyPoints, octaves)


% Initialize the result tensor
f = zeros(nxPoints, nyPoints);

% For each octave (i.e., grid size)
for octave = 1:octaves
    
    % Calculate the x and y transformation
    x_ = xEnd * octave;
    y_ = yEnd * octave;
    
    % Calculate the grid gradients
    gridGradient = generateGridGradient(x_, y_);
    
    % Calculate the x and y vectors to work with it
    x = linspace(xStart+1, x_, nxPoints);
    y = linspace(yStart+1, y_, nyPoints);
    

    % Generate the Perlin noise and add it to the result
    for i = 1:length(x)
        
        for j = 1:length(y)
            
            f(i, j) = f(i, j) + generatePerlinNoiseForPoint(gridGradient, [x(i), y(j)]);
            
        end
        
    end
    
    
end

end
