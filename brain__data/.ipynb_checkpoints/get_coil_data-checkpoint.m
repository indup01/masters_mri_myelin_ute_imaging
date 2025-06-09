load("Z:\home\mri_fyp\brain\raw_data\raw_data_MID284_TE47us_TI360ms.mat")
% load("/rds/general/user/ip620/home/mri_fyp/brain/raw_data/raw_data_MID284_TE47us_TI360ms.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID284(:, c, :);
first_column_elements = squeeze(first_column_elements);
flattened_data = reshape(first_column_elements, 1,[]);
% save_folder = '/rds/general/user/ip620/home/mri_fyp/brain/sequence/coil_data/TE47us_TI360ms';
save_folder = 'Z:\home\mri_fyp\brain\sequence\coil_data\TE47us_TI360ms';
filename = fullfile(save_folder, sprintf('coil_%d.mat', c));
save(filename, 'flattened_data');
end

%%

load("Z:\home\mri_fyp\brain\raw_data\raw_data_MID287_TE800us_TI360ms.mat")
% load("/rds/general/user/ip620/home/mri_fyp/brain/raw_data/raw_data_MID287_TE800us_TI360ms.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID287(:, c, :);
first_column_elements = squeeze(first_column_elements);
flattened_data = reshape(first_column_elements, 1,[]);
% save_folder = '/rds/general/user/ip620/home/mri_fyp/brain/sequence/coil_data/TE800us_TI360ms';
save_folder = 'Z:\home\mri_fyp\brain\sequence\coil_data\TE800us_TI360ms';
filename = fullfile(save_folder, sprintf('coil_%d.mat', c));
save(filename, 'flattened_data');
end
clear
load("Z:\home\mri_fyp\brain\raw_data\raw_data_MID290_TE1750us_TI360ms.mat")
% load("/rds/general/user/ip620/home/mri_fyp/brain/raw_data/raw_data_MID290_TE1750us_TI360ms.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID290(:, c, :);
first_column_elements = squeeze(first_column_elements);
flattened_data = reshape(first_column_elements, 1,[]);
% save_folder = '/rds/general/user/ip620/home/mri_fyp/brain/sequence/coil_data/TE1750us_TI360ms';
save_folder = 'Z:\home\mri_fyp\brain\sequence\coil_data\TE1750us_TI360ms';
filename = fullfile(save_folder, sprintf('coil_%d.mat', c));
save(filename, 'flattened_data');
end
clear
load("Z:\home\mri_fyp\brain\raw_data\raw_data_MID293_TE1750us_TI370ms.mat")
% load("/rds/general/user/ip620/home/mri_fyp/brain/raw_data/raw_data_MID293_TE1750us_TI370ms.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID293(:, c, :);
first_column_elements = squeeze(first_column_elements);
flattened_data = reshape(first_column_elements, 1,[]);
% save_folder = '/rds/general/user/ip620/home/mri_fyp/brain/sequence/coil_data/TE1750us_TI370ms';
save_folder = 'Z:\home\mri_fyp\brain\sequence\coil_data\TE1750us_TI370ms';
filename = fullfile(save_folder, sprintf('coil_%d.mat', c));
save(filename, 'flattened_data');
end
clear
load("Z:\home\mri_fyp\brain\raw_data\raw_data_MID296_TE1750us_TI380ms.mat")
% load("/rds/general/user/ip620/home/mri_fyp/brain/raw_data/raw_data_MID296_TE1750us_TI380ms.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID296(:, c, :);
size(first_column_elements)
first_column_elements = squeeze(first_column_elements);
size(first_column_elements)
flattened_data = reshape(first_column_elements, 1,[]);
% save_folder = '/rds/general/user/ip620/home/mri_fyp/brain/sequence/coil_data/TE1750us_TI380ms';
save_folder = 'Z:\home\mri_fyp\brain\sequence\coil_data\TE1750us_TI380ms';
filename = fullfile(save_folder, sprintf('coil_%d.mat', c));
save(filename, 'flattened_data');
end
clear
load("Z:\home\mri_fyp\brain\raw_data\raw_data_MID299_TE1750us_TI350ms.mat")
% load("/rds/general/user/ip620/home/mri_fyp/brain/raw_data/raw_data_MID299_TE1750us_TI350ms.mat")
num_elements = 32;
for c = 1:num_elements
first_column_elements = raw_data_MID299(:, c, :);
size(first_column_elements)
first_column_elements = squeeze(first_column_elements);
size(first_column_elements)
flattened_data = reshape(first_column_elements, 1,[]);
% save_folder = '/rds/general/user/ip620/home/mri_fyp/brain/sequence/coil_data/TE1750us_TI350ms';
save_folder = 'Z:\home\mri_fyp\brain\sequence\coil_data\TE1750us_TI350ms';
filename = fullfile(save_folder, sprintf('coil_%d.mat', c));
save(filename, 'flattened_data');
end



