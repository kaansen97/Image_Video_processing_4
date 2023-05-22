% Step 1: Loading Image in RGB space and transforming it to linear RGB
img = imread('queen.jpg');
% Transform the image to linear RGB space
img = im2double(img);
linear_image =(img/12.92).*(img<= 0.04045) + (((img+0.055) / 1.055) .^ 2.4).*(img>0.04045);
figure;
imshow(linear_image);

% Reshape the image matrix
image_reshaped = reshape(linear_image, [], 3);

%Perform K-means clustering
num_clusters = 7;
[idx, centroids] = kmeans(image_reshaped, num_clusters);

%Compute the centroid colors
palette_colors = centroids / 255.0;

% Print the palette colors
disp('Palette Colors:');
disp(palette_colors);

