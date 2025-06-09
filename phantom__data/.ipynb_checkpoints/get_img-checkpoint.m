clc
clear

% folderPath = '/rds/general/user/ip620/home/mri_fyp/phantom/sequence/images_l_te';  % Replace with your actual folder path
% fileName = fullfile(folderPath, 'imagesharp1.txt');
% fileID = fopen(fileName, 'r');
% if fileID == -1
%     error('File not found or could not be opened: %s', fileName);
% end
% firstLines = textscan(fileID, '%s', 10);  % Read first 10 lines as strings
% fclose(fileID);
% 
% % Display the first few lines to understand the format
% disp(firstLines{1});

%%
clc
% Folder path (use absolute path if needed)
folderPath = 'images_l_te';

% Field of view (image dimensions)
fov = 96;

% Initialize sum of squares as a 3D array of zeros
sumOfSquares = zeros(fov, fov, fov);

% Loop through each image file
for i = 1:32
    % Construct file name
    fileName = fullfile(folderPath, sprintf('imagesharp%d.txt', i));
    fprintf('Processing file: %s\n', fileName);  % Debugging line to show file name

    % Open the file for reading
    fileID = fopen(fileName, 'r');
    if fileID == -1
        error('Could not open file: %s', fileName);
    end
    
    % Read each line as a string
    data = textscan(fileID, '%s');
    fclose(fileID);
    
    % Extract the complex numbers from the strings
    complexData = cellfun(@(x) sscanf(x, '(%f%fi)'), data{1}, 'UniformOutput', false);
    complexData = cell2mat(complexData);
    
    % Combine real and imaginary parts to form complex numbers
    realParts = complexData(1:2:end);  % Real parts
    imagParts = complexData(2:2:end);  % Imaginary parts
    img = complex(realParts, imagParts);
    
    % Check if the number of elements is correct
    if numel(img) ~= fov^3
        error('Incorrect number of elements in file %s: expected %d, got %d', fileName, fov^3, numel(img));
    end
    
    % Reshape the data back to 3D (96x96x96)
    img = reshape(img, [fov, fov, fov]);

    % Sum the square of the image elements (voxel-wise)
    sumOfSquares = sumOfSquares + abs(img).^2;
end

% Take the square root of the sum at each voxel to get the final image
resultImage_l = sqrt(sumOfSquares);

% Display the result (slice through the middle as an example)
figure;
slice(double(resultImage_l), fov/2, fov/2, fov/2);
title('Square Root of Sum of Squared Images');
xlabel('X'); ylabel('Y'); zlabel('Z');
colorbar;

% Optionally save the result as a .mat file or image file
save('resultImage_l_te.mat', 'resultImage_l');

%%
% Folder path (use absolute path if needed)
folderPath = 'images_s_te';

% Field of view (image dimensions)
fov = 96;

% Initialize sum of squares as a 3D array of zeros
sumOfSquares = zeros(fov, fov, fov);

% Loop through each image file
for i = 1:32
    % Construct file name
    fileName = fullfile(folderPath, sprintf('imagesharp%d.txt', i));
    fprintf('Processing file: %s\n', fileName);  % Debugging line to show file name

    % Open the file for reading
    fileID = fopen(fileName, 'r');
    if fileID == -1
        error('Could not open file: %s', fileName);
    end
    
    % Read each line as a string
    data = textscan(fileID, '%s');
    fclose(fileID);
    
    % Extract the complex numbers from the strings
    complexData = cellfun(@(x) sscanf(x, '(%f%fi)'), data{1}, 'UniformOutput', false);
    complexData = cell2mat(complexData);
    
    % Combine real and imaginary parts to form complex numbers
    realParts = complexData(1:2:end);  % Real parts
    imagParts = complexData(2:2:end);  % Imaginary parts
    img = complex(realParts, imagParts);
    
    % Check if the number of elements is correct
    if numel(img) ~= fov^3
        error('Incorrect number of elements in file %s: expected %d, got %d', fileName, fov^3, numel(img));
    end
    
    % Reshape the data back to 3D (96x96x96)
    img = reshape(img, [fov, fov, fov]);

    % Sum the square of the image elements (voxel-wise)
    sumOfSquares = sumOfSquares + abs(img).^2;
end

% Take the square root of the sum at each voxel to get the final image
resultImage_s = sqrt(sumOfSquares);

% Display the result (slice through the middle as an example)
figure;
slice(double(resultImage_s), fov/2, fov/2, fov/2);
title('Square Root of Sum of Squared Images');
xlabel('X'); ylabel('Y'); zlabel('Z');
colorbar;

% Optionally save the result as a .mat file or image file
save('resultImage_s_te.mat', 'resultImage_s');

%%
volshow(resultImage_l)
%%
volshow(resultImage_s)
%%
diff = resultImage_s - resultImage_l;

volshow(diff*-1)
%%
volshow(image_full_3d_lte)

%%
volshow(image_full_3d_ste)

%%
diff = image_full_3d_ste - image_full_3d_lte;

volshow(diff)
