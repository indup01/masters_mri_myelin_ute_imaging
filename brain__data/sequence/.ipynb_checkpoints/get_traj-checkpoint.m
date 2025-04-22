clc
clear
load('/rds/general/user/ip620/home/mri_fyp/phantom/sequence/azimuth_polar_angles_XYZ.mat')
% load ('Z:\home\mri_fyp\phantom\sequence\azimuth_polar_angles_XYZ.mat')
%%
clc
data = readmatrix('one_spoke_z_only.txt');
data = data(:,[1,4]);

%%
left_col = data(:,1);
right_col = data(:,2);

% Time step (10 microseconds)
dt = 10e-6;

% Perform numerical integration using cumulative trapezoidal rule
integrated_value = cumtrapz(right_col) * dt;

% Define gamma_bar (Set your own value)
%gamma_bar = 42.58*10^6;
gamma_bar = 42577.478518;


% Multiply by gamma_bar
result = integrated_value * gamma_bar;

% Output only when the left column is 1
output_values = result(left_col == 1)*-1;


%%
%compute diff between values
diff_values = diff(output_values); 

% Normalize the diff_values between 0 and 1 using min-max normalization
min_val = min(diff_values);  % Find the minimum value of diff_values
max_val = max(diff_values);  % Find the maximum value of diff_values

% Apply the normalization formula correctly
norm_diff = (diff_values - min_val) / (max_val - min_val);
cs = cumsum(norm_diff);

% Compute min and max of cs
min_val = min(cs);  
max_val = max(cs);

% Apply min-max normalization
norm_cs = (cs - min_val) / (max_val - min_val);


%%

% Apply scaling between -pi and pi
%norm_cs = pi * (2 * norm_cs - 1);

% Initialize the output matrix (224 rows, 28952 columns, 3 for x, y, z)
num_samples = 224;
output_matrix = zeros(num_samples, 28952, 3);  % (224, 28952, 3)

% Calculate the 3D positions for each spoke
for i = 1:28952
    % Get the direction vector for this spoke
    x_dir = X(i);
    y_dir = Y(i);
    z_dir = Z(i);

% Set the first point of the spoke to (0,0,0)
    output_matrix(1, i, :) = [0, 0, 0];

    % Compute 3D positions for each sample along the spoke
    for j = 2:num_samples  % Start from the second sample (j=2)
        t = norm_cs(j - 1);  % Step value along the spoke (using j-1)
        
        % Compute 3D position based on direction and increasing step
        output_matrix(j, i, 1) = t * x_dir;  % x position
        output_matrix(j, i, 2) = t * y_dir;  % y position
        output_matrix(j, i, 3) = t * z_dir;  % z position;
    end
end
%%
% Now output_matrix is a 224 x 28952 x 3 matrix with the (x, y, z) positions.
p = reshape(output_matrix,[], 3);
p1 = p(:,1)';
p2 = p(:,2)';
p3 = p(:,3)';
p = [p1 ;p2 ;p3];
%%
save('radial_3d_correct.mat', 'p');
%%
save('un_flat_radial_3d.mat', 'output_matrix');

%%
% Reshape the data into a 2D matrix of points
Xr = reshape(output_matrix(:,:,1), [], 1);
Yr = reshape(output_matrix(:,:,2), [], 1);
Zr = reshape(output_matrix(:,:,3), [], 1);

% Plot in 3D
scatter3(Xr, Yr, Zr, 36, 'filled');
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Scatter Plot');
grid on;
%%
output_matrix_pi = output_matrix*pi;

Xr = reshape(output_matrix_pi(:,:,1), [], 1);
Yr = reshape(output_matrix_pi(:,:,2), [], 1);
Zr = reshape(output_matrix_pi(:,:,3), [], 1);

% Plot in 3D
scatter3(Xr, Yr, Zr, 36, 'filled');
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Scatter Plot');
grid on;
%%
p_pi = p*pi;
save('radial_3d_correct_pi.mat', 'p_pi');
%%
%load("Z:\home\mri_fyp\phantom\raw_data\raw_data_MID344.mat")
load("/rds/general/user/ip620/home/mri_fyp/phantom/raw_data/raw_data_MID347.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID347(:, c, :);
size(first_column_elements)
first_column_elements = squeeze(first_column_elements);
size(first_column_elements)
flattened_data = reshape(first_column_elements, 1,[]);
save_folder = '/rds/general/user/ip620/home/mri_fyp/phantom/sequence/s_te';
filename = fullfile(save_folder, sprintf('s_te_coil_%d.mat', c));
save(filename, 'flattened_data');
end
load("/rds/general/user/ip620/home/mri_fyp/phantom/raw_data/raw_data_MID344.mat")

num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID344(:, c, :);
size(first_column_elements)
first_column_elements = squeeze(first_column_elements);
size(first_column_elements)
flattened_data = reshape(first_column_elements, 1,[]);
save_folder = '/rds/general/user/ip620/home/mri_fyp/phantom/sequence/l_te';
filename = fullfile(save_folder, sprintf('l_te_coil_%d.mat', c));
save(filename, 'flattened_data');
end
%%
clf
spoke = 28952;
hold on
for i = 1:spoke
ft = fftshift(fft(ifftshift(output_matrix(:,i,1))));
% plot(abs(ft))
imshow(abs(ft))
end
hold off
