% Step 1: Loading Image in linear RGB space
img = imread('queen.jpg');
linear_rgb_im = im2double(img);

% step 2: Perform K-means clustering
num_clusters = 7;
[idx, centroids] = kmeans(reshape(linear_rgb_im, [], 3), num_clusters);
palette_colors_rgb = centroids;

% Create a figure to display the images side by side
figure;

% Plot the original image
subplot(1, num_clusters+1, 1);
imshow(img);
title('Original Image');

% Plot the color strip with the palette colors
color_strip = ones(50, num_clusters*50, 3);
for i = 1:num_clusters
    color_strip(:, (i-1)*50+1:i*50, :) = repmat(reshape(palette_colors_rgb(i, :), [1, 1, 3]), [50, 50, 1]);
end
subplot(num_clusters+1, 2, 2);
imshow(color_strip);
title('Color Palette');

% Decompose the image into base color layers and apply modifications
for i = 1:num_clusters
    % Create a binary mask for pixels belonging to the current cluster
    mask = reshape(idx == i, size(img, 1), size(img, 2));
    
    % Set pixels not belonging to the current cluster to black
    layer = img;
    layer(repmat(~mask, [1, 1, 3])) = 0;
    
    normalized_layer = double(layer) ./ 255;
    % Convert the normalized layer to the HSL color space
    hsl_layer = rgb2hsv(normalized_layer);
    
    hsl_layer(:, :, 2) = hsl_layer(:, :, 2) * 1.5; % Increase saturation by a factor of 1.5
    
    % Convert the modified layer back to the RGB color space
    modified_layer = hsv2rgb(hsl_layer);
    
    % Plot the modified layer
    subplot(num_clusters+1, 2, (i+1)*2-1);
    imshow(modified_layer);
    title(sprintf('Layer %d (HSL)', i));
end
