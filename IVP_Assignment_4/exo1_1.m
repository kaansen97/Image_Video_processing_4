% Step 1: Loading Image in RGB space and transforming it to linear RGB
img = imread('queen.jpg');
linear_image = rgb2lin(img,OutputType="double");
% Reshape the image matrix
image_reshaped = reshape(linear_image, [], 3);

%Perform K-means clustering
num_clusters = 7;
[idx, centroids] = kmeans(image_reshaped, num_clusters);

%Compute the centroid colors
palette_colors = centroids;

% Print the palette colors
disp('Palette Colors:');
disp(palette_colors);

% Create a figure to display the images side by side
figure;

% Plot the original image
subplot(1, num_clusters+1, 1);
imshow(img);
title('Original Image');

% Plot the color strip with the palette colors
color_strip = ones(300, num_clusters*300, 3);
for i = 1:num_clusters
    color_strip(:, (i-1)*300+1:i*300, 1) = palette_colors(i, 1);
    color_strip(:, (i-1)*300+1:i*300, 2) = palette_colors(i, 2);
    color_strip(:, (i-1)*300+1:i*300, 3) = palette_colors(i, 3);
end
subplot(num_clusters+1, 2, 2);
imshow(color_strip);
title('Color Palette');

% Decompose the image into base color layers and translate to HSL color space
for i = 1:num_clusters
    % Create a binary mask for pixels belonging to the current cluster
    mask = reshape(idx == i, size(img, 1), size(img, 2));
    
    % Set pixels not belonging to the current cluster to black
    layer = img;
    layer(repmat(~mask, [1, 1, 3])) = 0;
    
    % Convert the layer to HSL color space
    hsl_layer = rgb2hsv(layer);
    
    % Plot the layer in the HSL color space
    subplot(num_clusters+1, 2, (i+1)*2-1);
    imshow(hsl_layer);
    title(sprintf('Layer %d (HSL)', i));
end

