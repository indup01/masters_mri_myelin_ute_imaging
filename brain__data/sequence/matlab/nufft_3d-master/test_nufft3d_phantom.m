% test nufft_3d.m (works much faster on GPU)
clear all
clc
% om = zeros(3,numel(traj),nRadialSpokes,'single');
%%
N = 96;
kint = p*(N/2);
nCones = 28952;
omx=[kint(1,:)];
omy=[kint(2,:)];
omz=([kint(3,:)]);
omx=reshape(omx,[],nCones);
omy=reshape(omy,[],nCones);
omz=reshape(omz,[],nCones);
om = cat(3,omx,omy,omz);
om=permute(om,[3 1 2]);
%om3=om3*(N/2);
save('om.mat', 'om')

%% create nufft object (gpu=0 CPU, gpu=1 gpuSparse, gpu=2 gpuArray)
N = 96;
obj = nufft_3d(om,N,'gpu',1);

%% generate data (forward transform)
data = flattened_data;
% randn('state',0);
% noise = 2e-2 * complex(randn(size(data)),randn(size(data)));
% data = data + noise;

%% reconstruction (inverse transform)

% %%
% maxit = 20; % use 1 for gridding, higher values for conjugate gradient
% weight = []; % data weighting (optional)
% damp = obj.discrep(data,std(noise)); % estimate damping term
%%
% regridding
im0 = obj.iNUFT(data,1);
%%
% % L2 penalty on ||x||
% im1 = obj.iNUFT(data,maxit,damp);
% 
% % L2 penalty on ||imag(x))||
% partial = 0.5; 
% im2 = obj.iNUFT(data,maxit,damp,weight,'phase-constraint',partial);
% 
% % L1 penalty on ||Q(x)|| (Q=wavelet transform)
% sparsity = 0.5; 
% im3 = obj.iNUFT(data,maxit,damp,weight,'compressed-sensing',sparsity);

%% display
mid = floor(size(im0,3)/2)+1;
mid = 12;
im_test1 = squeeze(abs(im0(mid,:,:)));
im_test2 = squeeze(abs(im0(:,mid,:)));
im_test3 = squeeze(abs(im0(:,:,mid)));
subplot(2,2,1); imagesc(im_test1);colormap gray; colorbar; title('regridding');
subplot(2,2,2); imagesc(im_test2);colormap gray; colorbar; title('regridding');
subplot(2,2,3); imagesc(im_test3);colormap gray; colorbar; title('regridding');
% saveas(gcf,'im_test.png')
%%
volshow(abs(im0))
%%
% subplot(2,2,2); imagesc(abs(im1(:,:,mid)),[0 0.5]); colorbar; title('least squares');
% subplot(2,2,3); imagesc(abs(im2(:,:,mid)),[0 0.5]); colorbar; title('phase constrained');
% subplot(2,2,4); imagesc(abs(im3(:,:,mid)),[0 0.5]); colorbar; title('compressed sensing');
