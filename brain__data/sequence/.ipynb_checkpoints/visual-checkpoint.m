clear
clc
% Define the main folder and subfolders
data_f = 'Z:\home\mri_fyp\brain\sequence\images_matlab';
subfolder = { ...
    'TE47us_TI360ms', ...
    'TE800us_TI360ms', ...
    'TE1750us_TI360ms', ...
    'TE1750us_TI370ms', ...
    'TE1750us_TI380ms', ...
    'TE1750us_TI350ms' ...
};

% Manually set the subfolder index (1 to 6)
subfolderIndex = 1; % Set this to any number between 1 and 6 to select the subfolder

% Get the selected subfolder path
selectedFolder = fullfile(data_f, subfolder{subfolderIndex});

% Read the image index from the file
imageIndex = 10;

% Construct the image file name based on the image index
imageFileName = sprintf('imagesharp%d.txt', imageIndex); % Modify the file extension if necessary

% Get the full path to the image
selectedImage = fullfile(selectedFolder, imageFileName);

%%

% Open the file for reading
fileID = fopen(selectedImage, 'r');
if fileID == -1
    error('Failed to open the file.');
end

% Initialize arrays for the real and imaginary parts of the complex numbers
realData = zeros(884736, 1);
imagData = zeros(884736, 1);

% Read the file line-by-line and parse the complex numbers
lineIdx = 1;
while ~feof(fileID)
    % Read a line of the file
    line = fgetl(fileID);
    
    % Use regular expression to match the complex number format
    % Updated regex: real part can start with space or -; imaginary part must have a sign and end with j
    tokens = regexp(line, '\(([-\s]?\d*\.\d+|\d+)([+-]?\d*\.\d+|\d+)(j)\)', 'tokens');
    
    % Ensure that the line contains a valid complex number
    if ~isempty(tokens)
        % Extract the real and imaginary parts
        realData(lineIdx) = str2double(tokens{1}{1});  % Real part
        imagData(lineIdx) = str2double(tokens{1}{2});  % Imaginary part
        
        lineIdx = lineIdx + 1;
    else
        warning('Skipping invalid line: %s', line);
    end
end

% Close the file after reading
fclose(fileID);

% Check that we have exactly 884736 complex numbers
if lineIdx - 1 ~= 884736
    error('The number of complex numbers in the file does not match the expected size (884736).');
end

% Combine real and imaginary parts into a complex array
complexData = complex(realData, imagData);

% Reshape the data into a 96x96x96 3D volume
volumeData = abs(reshape(complexData, [96, 96, 96]));

%%
% Visualize the 3D volume using volshow
volshow(volumeData);
fov = 96;
figure;
slice(double(volumeData), fov/2, fov/2, fov/2);
title('Square Root of Sum of Squared Images');
xlabel('X'); ylabel('Y'); zlabel('Z');
colorbar;

%%
one = load("Z:\home\mri_fyp\brain\sequence\resultImage_TE47us_TI360ms.mat");
two = load("Z:\home\mri_fyp\brain\sequence\resultImage_TE800us_TI360ms.mat");
three = load("Z:\home\mri_fyp\brain\sequence\resultImage_TE1750us_TI360ms.mat");
four = load("Z:\home\mri_fyp\brain\sequence\resultImage_TE1750us_TI350ms.mat");
five = load("Z:\home\mri_fyp\brain\sequence\resultImage_TE1750us_TI370ms.mat");
six = load("Z:\home\mri_fyp\brain\sequence\resultImage_TE1750us_TI380ms.mat");

%%
% Assuming the variable containing the 3D image data is named 'resultImage' in each file
images = {one.resultImage, two.resultImage, three.resultImage, four.resultImage, five.resultImage, six.resultImage};

% Variable to control which slice to display
sliceNumber = 20;  % Example: middle slice is 48 in a 96x96x96 volume (can be modified)

% Variable to control the axis (1 = x-axis, 2 = y-axis, 3 = z-axis)
axisChoice = 3;  % 1 for x-axis, 2 for y-axis, 3 for z-axis

% Create a figure for subplots
figure;

% Loop through each image and display the middle slice
for i = 1:length(images)
    % Extract the image volume
    img = images{i};
    
    % Get the slice based on the chosen axis
    switch axisChoice
        case 1  % x-axis (slice along x, looking at y and z)
            slice = squeeze(img(sliceNumber, :, :));
        case 2  % y-axis (slice along y, looking at x and z)
            slice = squeeze(img(:, sliceNumber, :));
        case 3  % z-axis (slice along z, looking at x and y)
            slice = squeeze(img(:, :, sliceNumber));
        otherwise
            error('Invalid axis choice. Use 1 for x, 2 for y, or 3 for z.');
    end
    
    % Create subplot for each image slice
    subplot(2, 3, i);  % Creates a 2x3 grid of subplots
    imagesc(abs(slice));  % Use abs() to visualize the magnitude of the complex values
    axis image;
    colormap('gray');
    title(['Image ' num2str(i)]);
    colorbar;
end

%%
one_no_noise = images{1} - images{3};
two_no_noise = images{2} - images{3};

images_no_noise = {one_no_noise,two_no_noise};

% Variable to control which slice to display
sliceNumber = 20;  % Example: middle slice is 48 in a 96x96x96 volume (can be modified)

% Variable to control the axis (1 = x-axis, 2 = y-axis, 3 = z-axis)
axisChoice = 3;  % 1 for x-axis, 2 for y-axis, 3 for z-axis

% Create a figure for subplots
figure;

% Loop through each image and display the middle slice
for i = 1:length(images_no_noise)
    % Extract the image volume
    img = images_no_noise{i};
    
    % Get the slice based on the chosen axis
    switch axisChoice
        case 1  % x-axis (slice along x, looking at y and z)
            slice = squeeze(img(sliceNumber, :, :));
        case 2  % y-axis (slice along y, looking at x and z)
            slice = squeeze(img(:, sliceNumber, :));
        case 3  % z-axis (slice along z, looking at x and y)
            slice = squeeze(img(:, :, sliceNumber));
        otherwise
            error('Invalid axis choice. Use 1 for x, 2 for y, or 3 for z.');
    end
    
    % Create subplot for each image slice
    subplot(1, 2, i);  % Creates a 2x3 grid of subplots
    imagesc(abs(slice));  % Use abs() to visualize the magnitude of the complex values
    axis image;
    colormap('gray');
    title(['Image ' num2str(i)]);
    colorbar;
end
%%
volshow(one_no_noise)

%%
save('short_no_noise.mat','one_no_noise')
save('long_no_noise.mat','two_no_noise')