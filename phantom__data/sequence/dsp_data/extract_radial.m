close all; clearvars; clc
addpath('./dsv-reader/') % add reader function
addpath ('/') % dsv file dir
%% Load dsv files

protocol = 'DspData';

GRX_file = [protocol,'_GRX.dsv'];
GRY_file = [protocol,'_GRY.dsv'];
GRZ_file = [protocol,'_GRZ.dsv'];
ADC_file = [protocol,'_ADC.dsv'];
RFD_file = [protocol,'_RFD.dsv'];

disp('Reading GRX:');
GRX = dsvread(GRX_file);
disp('Reading GRY:');
GRY = dsvread(GRY_file);
disp('Reading GRZ:');
GRZ = dsvread(GRZ_file);
disp('Reading ADC:');
ADC = dsvread(ADC_file);
disp('Reading RFD:');
RFD = dsvread(RFD_file);

save('GRX.mat', 'GRX');
save('GRY.mat', 'GRY');
save('GRZ.mat', 'GRZ');
save('ADC.mat', 'ADC');
save('RFD.mat', 'RFD');

disp('MAT files saved successfully.');