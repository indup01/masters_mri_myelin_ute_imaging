clear all
clc
addpath(genpath('./external'));
% %% Load raw data
% twix_284=mapVBVD(284);
twix_287=mapVBVD(287);
% twix_290=mapVBVD(290);
% twix_293=mapVBVD(293);
% twix_296=mapVBVD(296);
twix_299=mapVBVD(299);
% %% get dimensions and signals
% raw_data_MID284=twix_284.image.unsorted(); % no slicing supported atm
raw_data_MID287=twix_287.image.unsorted(); % no slicing supported atm
% raw_data_MID290=twix_290.image.unsorted(); % no slicing supported atm
% raw_data_MID293=twix_293.image.unsorted(); % no slicing supported atm
% raw_data_MID296=twix_296.image.unsorted(); % no slicing supported atm
raw_data_MID299=twix_299.image.unsorted(); % no slicing supported atm

% %%
% save('raw_data_MID284_TE47us_TI360ms.mat', 'raw_data_MID284');
save('raw_data_MID287_TE800us_TI360ms.mat', 'raw_data_MID287');
% save('raw_data_MID290_TE1750us_TI360ms.mat', 'raw_data_MID290');
% save('raw_data_MID293_TE1750us_TI370ms.mat', 'raw_data_MID293');
% save('raw_data_MID296_TE1750us_TI380ms.mat', 'raw_data_MID296');
save('raw_data_MID299_TE1750us_TI350ms.mat', 'raw_data_MID299');

% %%
% % Define the raw data filenames and corresponding IDs
% twix_ids = [284, 287, 290, 293, 296, 299];
% save_filenames = { ...
%     'raw_data_MID284_TE47us_TI360ms.mat', ...
%     'raw_data_MID287_TE800us_TI360ms.mat', ...
%     'raw_data_MID290_TE1750us_TI360ms.mat', ...
%     'raw_data_MID293_TE1750us_TI370ms.mat', ...
%     'raw_data_MID296_TE1750us_TI380ms.mat', ...
%     'raw_data_MID299_TE1750us_TI350ms.mat' ...
% };

% % Loop through each TWIX ID and save data
% for i = 1:length(twix_ids)
%     % Load the raw data
%     twix_data = mapVBVD(twix_ids(i));
%     raw_data = twix_data.image.unsorted();  % no slicing supported atm
    
%     % Save the raw data with the corresponding filename
%     save(save_filenames{i}, 'raw_data');
    
%     % Clear the variable to free up memory
%     clear raw_data;
% end