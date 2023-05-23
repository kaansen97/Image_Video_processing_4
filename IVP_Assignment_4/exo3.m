% Load the image
sad_image = imread('sad.jpg');
happy_image = imread('happy.jpg');

% Convert the images to grayscale
sad_gray = rgb2gray(sad_image);
happy_gray = rgb2gray(happy_image);

% Define the number of pyramid levels
num_levels = 4;

% Compute the Laplacian pyramid for sad image
sad_laplacian_pyramid = cell(num_levels, 1);
sad_gaussian_pyramid = cell(num_levels, 1);
sad_gaussian_pyramid{1} = im2double(sad_gray);

for i = 2:num_levels
    blurred = imgaussfilt(sad_gaussian_pyramid{i-1}, 2^(i-1));
    expanded = imresize(blurred, size(sad_gaussian_pyramid{i-1}), 'bicubic');
    sad_laplacian_pyramid{i-1} = sad_gaussian_pyramid{i-1} - expanded;
    sad_gaussian_pyramid{i} = blurred;
end
sad_laplacian_pyramid{num_levels} = sad_gaussian_pyramid{num_levels}; % The last level is the same as the top level of the Gaussian pyramid

% Compute the Laplacian pyramid for happy image
happy_laplacian_pyramid = cell(num_levels, 1);
happy_gaussian_pyramid = cell(num_levels, 1);
happy_gaussian_pyramid{1} = im2double(happy_gray);

for i = 2:num_levels
    blurred = imgaussfilt(happy_gaussian_pyramid{i-1}, 2^(i-1));
    expanded = imresize(blurred, size(happy_gaussian_pyramid{i-1}), 'bicubic');
    happy_laplacian_pyramid{i-1} = happy_gaussian_pyramid{i-1} - expanded;
    happy_gaussian_pyramid{i} = blurred;
end
happy_laplacian_pyramid{num_levels} = happy_gaussian_pyramid{num_levels}; % The last level is the same as the top level of the Gaussian pyramid
% Create a figure with subplots for each level of the Laplacian pyramid
figure;

% Display the Laplacian pyramid levels for sad image
for i = 1:num_levels
    subplot(2, num_levels, i);
    imshow(sad_laplacian_pyramid{i}, []);
    title(sprintf('Sad: Level %d', i));
end

% Display the Laplacian pyramid levels for happy image
for i = 1:num_levels
    subplot(2, num_levels, num_levels + i);
    imshow(happy_laplacian_pyramid{i}, []);
    title(sprintf('Happy: Level %d', i));
end

% Adjust the figure size and spacing
set(gcf, 'Position', [100, 100, 1200, 400]);
sgtitle('Laplacian Pyramid');