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
% data_f = "/rds/general/user/ip620/home/mri_fyp/brain/sequence/images_matlab";
data_f = "Z:\home\mri_fyp\brain\sequence\images_matlab";
subfolder = { ...
    'TE47us_TI360ms', ...
    'TE800us_TI360ms', ...
    'TE1750us_TI360ms', ...
    'TE1750us_TI370ms', ...
    'TE1750us_TI380ms', ...
    'TE1750us_TI350ms' ...
};

for x = 1:length(subfolder)
current_subfolder = subfolder{x};
% Folder path (use absolute path if needed)
folderPath = fullfile(data_f, current_subfolder);

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

    % Initialize arrays for the real and imaginary parts of the complex numbers
    realData = zeros(fov^3, 1);
    imagData = zeros(fov^3, 1);
    
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
    
    % Combine real and imaginary parts into a complex array
    complexData = complex(realData, imagData);
    
    % Reshape the data into a 96x96x96 3D volume
    volumeData = reshape(complexData, [96, 96, 96]);

    % Sum the square of the image elements (voxel-wise)
    sumOfSquares = sumOfSquares + abs(volumeData).^2;
end

% Take the square root of the sum at each voxel to get the final image
resultImage = sqrt(sumOfSquares);

% % Display the result (slice through the middle as an example)
% figure;
% slice(double(resultImage), fov/2, fov/2, fov/2);
% title('Square Root of Sum of Squared Images');
% xlabel('X'); ylabel('Y'); zlabel('Z');
% colorbar;

% Optionally save the result as a .mat file or image file
% Construct the filename using sprintf (not fprintf)
fileName = sprintf('resultImage_%s.mat', current_subfolder);  % Use %s for string formatting

% Save the resultImage to the .mat file
save(fileName, 'resultImage');

end

% %%
% data_f = "Z:\home\mri_fyp\brain\sequence\images_matlab";
% % data_f = "/rds/general/user/ip620/home/mri_fyp/brain/sequence/images_matlab";
% subfolder = { ...
%     '47us_subtracted', ...
%     '800us_subtracted', ...
% };

% for x = 1:length(subfolder)
% current_subfolder = subfolder{x};
% % Folder path (use absolute path if needed)
% folderPath = fullfile(data_f, current_subfolder);

% % Field of view (image dimensions)
% fov = 96;

% % Initialize sum of squares as a 3D array of zeros
% sumOfSquares = zeros(fov, fov, fov);

% % Loop through each image file
% for i = 1:32
%     % Construct file name
%     fileName = fullfile(folderPath, sprintf('imagesharp%d.txt', i));
%     fprintf('Processing file: %s\n', fileName);  % Debugging line to show file name

%     % Open the file for reading
%     fileID = fopen(fileName, 'r');
%     if fileID == -1
%         error('Could not open file: %s', fileName);
%     end

%     % Initialize arrays for the real and imaginary parts of the complex numbers
%     realData = zeros(fov^3, 1);
%     imagData = zeros(fov^3, 1);
    
%     % Read the file line-by-line and parse the complex numbers
%     lineIdx = 1;
%     while ~feof(fileID)
%         % Read a line of the file
%         line = fgetl(fileID);
        
%         % Use regular expression to match the complex number format
%         % Updated regex: real part can start with space or -; imaginary part must have a sign and end with j
%         tokens = regexp(line, '\(([-\s]?\d*\.\d+|\d+)([+-]?\d*\.\d+|\d+)(j)\)', 'tokens');
        
%         % Ensure that the line contains a valid complex number
%         if ~isempty(tokens)
%             % Extract the real and imaginary parts
%             realData(lineIdx) = str2double(tokens{1}{1});  % Real part
%             imagData(lineIdx) = str2double(tokens{1}{2});  % Imaginary part
            
%             lineIdx = lineIdx + 1;
%         else
%             warning('Skipping invalid line: %s', line);
%         end
%     end
    
%     % Close the file after reading
%     fclose(fileID);
    
%     % Combine real and imaginary parts into a complex array
%     complexData = complex(realData, imagData);
    
%     % Reshape the data into a 96x96x96 3D volume
%     volumeData = reshape(complexData, [96, 96, 96]);

%     % Sum the square of the image elements (voxel-wise)
%     sumOfSquares = sumOfSquares + abs(volumeData).^2;
% end

% % Take the square root of the sum at each voxel to get the final image
% resultImage = sqrt(sumOfSquares);

% % % Display the result (slice through the middle as an example)
% % figure;
% % slice(double(resultImage), fov/2, fov/2, fov/2);
% % title('Square Root of Sum of Squared Images');
% % xlabel('X'); ylabel('Y'); zlabel('Z');
% % colorbar;

% % Optionally save the result as a .mat file or image file
% % Construct the filename using sprintf (not fprintf)
% fileName = sprintf('resultImage_%s.mat', current_subfolder);  % Use %s for string formatting

% % Save the resultImage to the .mat file
% save(fileName, 'resultImage');

% end
% %%
