% test nufft_3d.m (works much faster on GPU)
clc
clear all
addpath('C:/Users/Indum/Documents/Year4/mri_fyp/simulation/brain_myelin/matlab/nufft_3d-master/');
addpath('C:/Program Files/MATLAB/R2025a/toolbox/parallel')
addpath('C:/Users/Indum/Documents/Year4/mri_fyp/simulation/brain_myelin/matlab/parallel-master/');
%addpath('C:/Users/Indum/Documents/Year4/mri_fyp/simulation/brain_myelin/matlab/nufft_3d-master/gpuSparse-master')

%% object - 3d shepp logan phantom
N = 50;  % Define size
im = phantom3d(N);
im(im==1) = i; % add phase
%%
echo_time = 5e-5;
% FOV in cm
fov_x = 5;
fov_y = fov_x;
fov_z = fov_x;

t1_myelin = 4.0e-1;
t1_wm = 8.5e-1;
t2_myelin = 5.0e-2;
t2_wm = 5.0e-2;
t2_star_myelin = 3.0e-2;
t2_star_wm = 7.0e-2;

inv_time = log(2) * t1_wm;
res = 0.1; % Resolution in cm

pixels_x = floor(fov_x / res);
pixels_y = floor(fov_y / res);
pixels_z = floor(fov_z / res);
N = pixels_x;

mxy_myelin = (1 - 2 * exp(-inv_time / t1_myelin)) * exp(-echo_time / t2_star_myelin);
mxy_wm = (1 - 2 * exp(-inv_time / t1_wm)) * exp(-echo_time / t2_star_wm);
mxy_mixed = 0.5 * ((1 - 2 * exp(-inv_time / t1_wm)) * exp(-echo_time / t2_star_wm)) + ...
             0.5 * ((1 - 2 * exp(-inv_time / t1_myelin)) * exp(-echo_time / t2_star_myelin));

% Initialize 3D image
image_3d = ones(pixels_x, pixels_y, pixels_z);

% Define cube sizes
outer_cube_size = floor(1.0 * pixels_x);
middle_cube_size = floor(0.6 * pixels_x);
inner_cube_size = floor(0.25 * pixels_x);

% Function to get cube bounds
get_cube_bounds = @(size, pixels) deal(floor((pixels - size) / 2) + 1, floor((pixels - size) / 2) + size);

[outer_start, outer_end] = get_cube_bounds(outer_cube_size, pixels_x);
[middle_start, middle_end] = get_cube_bounds(middle_cube_size, pixels_x);
[inner_start, inner_end] = get_cube_bounds(inner_cube_size, pixels_x);

% Assign intensity values
image_3d(outer_start:outer_end, outer_start:outer_end, outer_start:outer_end) = mxy_wm;
image_3d(middle_start:middle_end, middle_start:middle_end, middle_start:middle_end) = mxy_mixed;
image_3d(inner_start:inner_end, inner_start:inner_end, inner_start:inner_end) = mxy_myelin;

% Compute the 3D FFT
fft_3d = fftn(image_3d);
fft_3d_shifted = fftshift(fft_3d);
magnitude = abs(fft_3d_shifted);

% Visualizing the middle slice of the original 3D image
slice_index_z = floor(pixels_z / 2);
image_slice = image_3d(:, :, slice_index_z);

% Display the middle slice
figure;
imagesc(image_slice);
colormap(parula); % Change to 'jet' or 'gray' if preferred
colorbar;
axis equal;
title('Middle Slice of the 3D Image');
xlabel('X');
ylabel('Y');

% Visualization of the 3D FFT magnitude using a 2D slice view
slice_index_z = floor(pixels_z / 2);
fft_slice = magnitude(:, :, slice_index_z);

% Create a meshgrid for plotting
[X, Y] = meshgrid(1:pixels_x, 1:pixels_y);
Z = fft_slice; % Magnitude at the selected slice

% Plot the 3D surface of the FFT magnitude
figure;
surf(X, Y, Z, 'EdgeColor', 'none');
colorbar;
title('3D FFT Magnitude Surface Plot (XY-plane slice)');
xlabel('X');
ylabel('Y');
zlabel('Magnitude');
view(3);
im = image_3d;
%% generate koosh ball data
if 1

    % radial density adapted readout
    nRadialSpokes = 5555;
    
    grad = [linspace(0,1,10) ones(1,10) linspace(1,0,N).^1.25];
    traj = cumsum(grad); traj = traj * (N/2-1) / max(traj);

    z = traj;
    y = zeros(size(z));
    x = zeros(size(z));

    om = zeros(3,numel(traj),nRadialSpokes,'single');

    for k = 1:nRadialSpokes

        % golden angle (http://blog.wolfram.com/2011/07/28/how-i-made-wine-glasses-from-sunflowers)
        dH = 1 - 2 * (k-1) / (nRadialSpokes-1);
        PolarAngle(k) = acos(dH);
        AzimuthalAngle(k) = (k-1) * pi * (3 - sqrt(5));

        % rotation matrix
        RotationMatrix(1,1) = cos(AzimuthalAngle(k))*cos(PolarAngle(k));
        RotationMatrix(1,2) =-sin(AzimuthalAngle(k));
        RotationMatrix(1,3) = cos(AzimuthalAngle(k))*sin(PolarAngle(k));
        RotationMatrix(2,1) = sin(AzimuthalAngle(k))*cos(PolarAngle(k));
        RotationMatrix(2,2) = cos(AzimuthalAngle(k));
        RotationMatrix(2,3) = sin(AzimuthalAngle(k))*sin(PolarAngle(k));
        RotationMatrix(3,1) =-sin(PolarAngle(k));
        RotationMatrix(3,2) = 0.0;
        RotationMatrix(3,3) = cos(PolarAngle(k));

        % rotate the readout
        om(:,:,k) = RotationMatrix * [x; y; z];

    end
else

    % Cartesian
    [kx ky kz] = ndgrid(-80:79);
    om = [kx(:) ky(:) kz(:)]';

end

%% create nufft object (gpu=0 CPU, gpu=1 gpuSparse, gpu=2 gpuArray)
obj = nufft_3d(om,N,'gpu',0);

%% generate data (forward transform)
data = obj.fNUFT(im);
randn('state',0);
noise = 2e-2 * complex(randn(size(data)),randn(size(data)));
data = data + noise;

%% reconstruction (inverse transform)
maxit = 20; % use 1 for gridding, higher values for conjugate gradient
weight = []; % data weighting (optional)
damp = obj.discrep(data,std(noise)); % estimate damping term

% regridding
im0 = obj.iNUFT(data,1);

% L2 penalty on ||x||
im1 = obj.iNUFT(data,maxit,damp);

% L2 penalty on ||imag(x))||
partial = 0.5; 
im2 = obj.iNUFT(data,maxit,damp,weight,'phase-constraint',partial);

% L1 penalty on ||Q(x)|| (Q=wavelet transform)
sparsity = 0.5; 
im3 = obj.iNUFT(data,maxit,damp,weight,'compressed-sensing',sparsity);

%% display
mid = floor(size(im,3)/2)+1;
subplot(2,2,1); imagesc(abs(im0(:,:,mid)),[0 0.5]); colorbar; title('regridding');
subplot(2,2,2); imagesc(abs(im1(:,:,mid)),[0 0.5]); colorbar; title('least squares');
subplot(2,2,3); imagesc(abs(im2(:,:,mid)),[0 0.5]); colorbar; title('phase constrained');
subplot(2,2,4); imagesc(abs(im3(:,:,mid)),[0 0.5]); colorbar; title('compressed sensing');