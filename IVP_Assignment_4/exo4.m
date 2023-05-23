% Load the images
sad_image = imread('sad.jpg');
happy_image = imread('happy.jpg');

% Resize the images to have the same dimensions
common_size = [size(sad_image, 1), size(sad_image, 2)];
happy_resized = imresize(happy_image, common_size);

% Define the number of pyramid levels
num_levels = 4;

% Compute the Laplacian pyramid for the sad image
sad_laplacian_pyramid = cell(num_levels, 1);
sad_gaussian_pyramid = cell(num_levels, 1);
sad_gaussian_pyramid{1} = im2double(sad_image);

for i = 2:num_levels
    std_dev = power(2, (i-2));
    blurred = imgaussfilt(sad_gaussian_pyramid{i-1}, std_dev);
    expanded = imresize(blurred, size(sad_gaussian_pyramid{i-1}, 1:2), 'bicubic');
    sad_laplacian_pyramid{i-1} = sad_gaussian_pyramid{i-1} - expanded;
    sad_gaussian_pyramid{i} = blurred;
end
sad_laplacian_pyramid{num_levels} = sad_gaussian_pyramid{num_levels}; % The last level is the same as the top level of the Gaussian pyramid

% Compute the Laplacian pyramid for the resized happy image
happy_laplacian_pyramid = cell(num_levels, 1);
happy_gaussian_pyramid = cell(num_levels, 1);
happy_gaussian_pyramid{1} = im2double(happy_resized);

for i = 2:num_levels
    std_dev = power(2, (i-1));
    blurred = imgaussfilt(happy_gaussian_pyramid{i-1}, std_dev);
    expanded = imresize(blurred, size(happy_gaussian_pyramid{i-1}, 1:2), 'bicubic');
    happy_laplacian_pyramid{i-1} = happy_gaussian_pyramid{i-1} - expanded;
    happy_gaussian_pyramid{i} = blurred;
end
happy_laplacian_pyramid{num_levels} = happy_gaussian_pyramid{num_levels}; % The last level is the same as the top level of the Gaussian pyramid

% Choose the levels to combine for the hybrid image
sad_level = 4; % Choose a level from the sad image
happy_level = 1; % Choose a level from the happy image

% Resize the levels to match in size
resize_sad_level = imresize(sad_laplacian_pyramid{sad_level}, size(happy_laplacian_pyramid{happy_level}, 1:2), 'bicubic');

% Define the weight for the happy level
alpha =2; % Adjust this value to control the contribution of the happy level

% Create the hybrid image by combining the selected levels
hybrid_laplacian = resize_sad_level + alpha * happy_laplacian_pyramid{happy_level};

% Reconstruct the hybrid image from the Laplacian pyramid
hybrid_image = hybrid_laplacian;

% Display the hybrid image and its variations
figure;
subplot(2, 2, 1);
imshow(resize_sad_level);
title('Sad Image');

subplot(2, 2, 2);
imshow(happy_laplacian_pyramid{happy_level});
title('Happy Image (Resized)');

subplot(2, 2, 3);
imshow(hybrid_image);
title('Hybrid Image');

% Provide information about the ideal viewing conditions
image_size = size(hybrid_image); % Size of the image on the screen
distance_sad_face = 1; % Distance to see the sad face (in meters)
viewing_distance_happy_face = 2; %

% Print the information
fprintf('Ideal Viewing Conditions:\n');
fprintf('Image Size on Screen: %d pixels (width) x %d pixels (height)\n', image_size(2), image_size(1));
fprintf('Distance to See Sad Face: %d meters\n', distance_sad_face);
fprintf('Viewing Distance to See Happy Face: %d meters\n', viewing_distance_happy_face);
