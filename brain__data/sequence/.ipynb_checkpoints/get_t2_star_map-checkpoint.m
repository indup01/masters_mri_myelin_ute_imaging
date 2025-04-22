clear
clc
%%
long_data= load("Z:\home\mri_fyp\brain\sequence\long_no_noise.mat");
short_data = load("Z:\home\mri_fyp\brain\sequence\short_no_noise.mat");

long_img = long_data.two_no_noise;
short_img = short_data.one_no_noise;

fov =96;
l = 0.8e-3; 
s = 47e-6;

t2_star = zeros(fov,fov,fov);
for x = 1:fov
    for y = 1:fov
        for z = 1:fov
            ratio = short_img(x, y, z) / long_img(x, y, z);
            if ratio > 0  % Ensure log is valid
                t2_star(x, y, z) = (l - s) / log(ratio);
            else
                t2_star(x, y, z) = NaN;  % Assign NaN for invalid values
            end
        end
    end
end

%%
% Remove NaN values before visualization
t2_star(~isfinite(t2_star)) = 0;
volshow(t2_star)

%%
% Variable to control which slice to display
sliceNumber = 25;  % Example: choose slice 25

% Variable to control the axis (1 = x-axis, 2 = y-axis, 3 = z-axis)
axisChoice = 3;  % 1 for x-axis, 2 for y-axis, 3 for z-axis
% Select slice based on the axis choice for t2_star
if axisChoice == 1
    slice = t2_star(sliceNumber, :, :);  % Slice along x-axis
    short_slice = short_img(sliceNumber, :, :);  % Apply same slicing to short_img
elseif axisChoice == 2
    slice = t2_star(:, sliceNumber, :);  % Slice along y-axis
    short_slice = short_img(:, sliceNumber, :);  % Apply same slicing to short_img
elseif axisChoice == 3
    slice = t2_star(:, :, sliceNumber);  % Slice along z-axis
    short_slice = short_img(:, :, sliceNumber);  % Apply same slicing to short_img
else
    error('Invalid axis choice. Please choose 1, 2, or 3.');
end

% Create a tiled layout with 1 row and 2 columns
tiledlayout(1, 2);  % Create a 1x2 grid for subplots

% First plot: Display slice from t2_star
nexttile;
imshow(slice(:,:,1), []);  % Display the slice from t2_star
title('Slice from t2_star');

% Second plot: Display short_img slice
nexttile;
imshow(short_slice(:,:,1), []);  % Display the corresponding slice from short_img
title('Short Image');
%%
% Ask the user to select a rectangular region in the short_img slice
figure;
imshow(short_slice(:,:,1), []);  % Display the short_img slice
title('Select Rectangular ROI on Short Image');
h = imrect;  % Use the imrect tool for rectangular region selection

% Wait for the user to finish selecting the region
disp('Please select the rectangular region and double-click or press Enter to continue.');
position = wait(h);  % Get the coordinates of the selected rectangle (position = [x, y, width, height])

% Create a binary mask from the selected rectangular region
mask = createMask(h);  % Create binary mask based on the selected rectangle

% Extract the region from the image using the mask
region_with_rectangle = short_slice(:,:,1);  % Get the slice from short_img
masked_image = region_with_rectangle;  % No modification to the original slice
% Now the rectangle will just be drawn on the figure without modifying the image

% Display the image with the rectangle drawn on it
figure;
imshow(region_with_rectangle, []);  % Display the original image slice with no change in brightness
hold on;
rectangle('Position', position, 'EdgeColor', 'r', 'LineWidth', 2);  % Draw rectangle on the image
hold off;
title('Region of Interest');

% Save the image with the rectangle drawn on it
output_filename = 'image_with_rectangle.png';  % Set the filename for the output image
% Use the current image data without re-scaling or modifying it
saveas(gcf, output_filename);  % Save the current figure as an image
disp(['Image saved with rectangle as: ', output_filename]);


% Find the non-zero values in masked_t2_star
non_zero_values = nonzeros(masked_t2_star);

% Compute the mean of the non-zero values
mean_non_zero = mean(non_zero_values);

% Display the result
disp(['Mean of non-zero values in the masked region: ', num2str(mean_non_zero)]);
