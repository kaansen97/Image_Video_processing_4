% Step 1: Loading Image in sRGB space and transforming it to CIELAB
img = imread('queen.jpg');
Cielab_im = rgb2lab(img);

% Reshape the image matrix
image_reshaped = reshape(Cielab_im, [], 3);

% Perform K-means clustering
num_clusters = 7;
[idx, centroids] = kmeans(image_reshaped, num_clusters);

% Compute the centroid colors in CIELAB space
palette_colors_lab = centroids;

% Convert the palette colors from CIELAB to sRGB
palette_colors_rgb = lab2rgb(palette_colors_lab);

% Print the palette colors
disp('Palette Colors:');
disp(palette_colors_rgb);

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
    
    % Normalize the layer to the range of 0 to 1
    normalized_layer = double(layer) ./ 255;
    
    % Convert the normalized layer to the HSL color space
    lab_layer = rgb2lab(normalized_layer);
    
    
    % Convert the modified layer back to the RGB color space
    modified_layer = lab2rgb(lab_layer);
    
    % Plot the modified layer
    subplot(num_clusters+1, 2, (i+1)*2-1);
    imshow(modified_layer);
    title(sprintf('Layer %d (CIELab)', i));
end
