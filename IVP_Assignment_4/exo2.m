% Step 1: Loading Image in RGB space
img = imread('queen.jpg');

image_reshaped = double(reshape(img, [], 3));

% Step 3: Perform K-means clustering to find 32 representative colors
num_colors = 32;
max_iterations = 400; % maximum number of iterations
options = statset('MaxIter', max_iterations);
[indices, centroids] = kmeans(image_reshaped, num_colors, 'Options', options, 'Replicates',4);

% Step 4: Quantizing RGB image
quantized_image = reshape(centroids(indices, :), size(img));

% Step 5: Convert the quantized RGB image to grayscale based on luminance
grayscale_image = rgb2gray(uint8(quantized_image));

figure;
subplot(1, 3, 1);
imshow(uint8(img));
title('Original Color Image');

subplot(1, 3, 2);
imshow(uint8(quantized_image));
title('Quantized Color Image');

% Display the resulting grayscale image
subplot(1, 3, 3);
imshow(grayscale_image);
title('Grayscale Image (based on luminance)');
