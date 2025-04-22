clear all
clc
addpath(genpath('./external'));
%% Load raw data
twix_344=mapVBVD(344);
twix_347=mapVBVD(347);
%% get dimensions and signals
raw_data_MID344=twix_344.image.unsorted(); % no slicing supported atm
raw_data_MID347=twix_347.image.unsorted(); % no slicing supported atm

