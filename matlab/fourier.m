



x = linspace(-1, 1, 100);
y = linspace(-1, 1, 100);

[x, y, f] = fourierTexture(x, y, [1 2 3], [3 4 5], [0.01 0.05 0.1], [0.1 0.05 0.01], [-90 30 20], [-180 50 45], 0.01);

surf(f);


function [x, y, f] = fourierTexture(x, y, frequencyX, frequencyY, amplitudeX, amplitudeY, phaseX, phaseY, k)
%%
%Generates a 2D Fourier texture.
%
[x, y] = meshgrid(x, y);

f1 = zeros(size(x, 1), size(y, 1));
f2 = zeros(size(x, 1), size(y, 1));


for k = 1:length(frequencyX)
	
	f1 = f1 + amplitudeX(k) * sin(2 * pi * frequencyX(k) * x + phaseX(k) * pi / 180);
	f2 = f2 + amplitudeY(k) * sin(2 * pi * frequencyY(k) * y + phaseY(k) * pi / 180);
	
end

f = k .* (f1 .* f2);

end
