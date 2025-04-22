load("Z:\home\mri_fyp\brain\raw_data\raw_data_MID284_TE47us_TI360ms.mat")
%load("/rds/general/user/ip620/home/mri_fyp/brain/raw_data/raw_data_MID347.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID284(:, c, :);
size(first_column_elements)
first_column_elements = squeeze(first_column_elements);
size(first_column_elements)
flattened_data = reshape(first_column_elements, 1,[]);
save_folder = '/rds/general/user/ip620/home/mri_fyp/main/sequence/coil_data/TE47us_TI360ms';
filename = fullfile(save_folder, sprintf('coil_%d.mat', c));
save(filename, 'flattened_data');
end
%%
load("Z:\home\mri_fyp\brain\raw_data\raw_data_MID284_TE47us_TI360ms.mat")
%load("/rds/general/user/ip620/home/mri_fyp/brain/raw_data/raw_data_MID347.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID284(:, c, :);
size(first_column_elements)
first_column_elements = squeeze(first_column_elements);
size(first_column_elements)
flattened_data = reshape(first_column_elements, 1,[]);
save_folder = '/rds/general/user/ip620/home/mri_fyp/main/sequence/coil_data/TE47us_TI360ms';
filename = fullfile(save_folder, sprintf('coil_%d.mat', c));
save(filename, 'flattened_data');
end