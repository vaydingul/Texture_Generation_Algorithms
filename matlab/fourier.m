% Set x and y distance
x = linspace(-1, 1, 1000);
y = linspace(-1, 1, 1000);

% General constant to multiply the whole sginal
k = 1;

%! All of the below parameters must have the same size!

frequencyX = [1 2 3]; % Frequency of the signals in x-drection
frequencyY = [3 4 5]; % Frequency of the signals in y-direction
amplitudeX = [1 1 1]; % Amplitude of the signals in x-direction
amplitudeY = [1 1 1]; % Amplitude of the signals in y-direction
phaseX = [-90 30 20]; % Phase of the signals in x-direction
phaseY = [-180 50 45]; % Phase of the signals in y-direction



[x, y, f] = fourierTexture(x, y, frequencyX, frequencyY, amplitudeX, amplitudeY, phaseX, phaseY, k );

% Plot the result
figure;
s = surf(f);
s.EdgeColor = 'none';
figure;
imshow(f / 5);



function [x, y, f] = fourierTexture(x, y, frequencyX, frequencyY, amplitudeX, amplitudeY, phaseX, phaseY, k)
%%
%Generates a 2D Fourier texture.
%

% Mesh for working in 2D
[x, y] = meshgrid(x, y);

% Initialization of the output
f1 = zeros(size(x, 1), size(y, 1));
f2 = zeros(size(x, 1), size(y, 1));


for k = 1:length(frequencyX)
	% For each frequency, amplitude and phase, calculate
	% the inverse fourier of the sinusoidals

	f1 = f1 + amplitudeX(k) * sin(2 * pi * frequencyX(k) * x + phaseX(k) * pi / 180);
	f2 = f2 + amplitudeY(k) * sin(2 * pi * frequencyY(k) * y + phaseY(k) * pi / 180);
	
end

% Multiply the expression with a general constant
f = k .* (f1 .* f2);

end
