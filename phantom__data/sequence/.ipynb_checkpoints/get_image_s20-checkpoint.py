#!/usr/bin/env python
# coding: utf-8

# In[1]:


import matplotlib.pyplot as plt
import numpy as np
from warnings import filterwarnings
import torch
import torchkbnufft as tkbn
import scipy.io
import os


# In[37]:

fov = 96
im_size = (fov,fov,fov)
grid_size = (tuple(int(dim * 2) for dim in im_size))
print(im_size,grid_size)


# In[38]:

for x in range (20,29):
    
    # Load the .mat file
    coil_data = scipy.io.loadmat(f's_te/s_te_coil_{x}.mat')
    traj_data = scipy.io.loadmat('radial_3d_correct_pi.mat')
    
    # Check keys in the file to find the variable name
    print(coil_data.keys())  
    print(traj_data.keys())  
    
    
    # In[39]:
    
    
    # Extract the matrix (replace 'output_matrix' with the actual key from .mat file)
    coil_1_matrix = coil_data['flattened_data']  # Shape: (224, 28952, 3)
    
    # Convert to NumPy array
    kdata = np.array(coil_1_matrix)
    
    # Print shape to verify
    print("Loaded shape:", kdata.shape)
    
    # Extract the matrix (replace 'output_matrix' with the actual key from .mat file)
    traj_matrix = traj_data['p_pi']  # Shape: (224, 28952, 3)
    
    # Convert to NumPy array
    ktraj = np.array(traj_matrix)
    
    # Print shape to verify
    print("Loaded shape:", ktraj.shape)
    
    
    # In[44]:
    
    
    # Set the device to GPU if available, otherwise use CPU
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    
    # Move the ktraj and kdata tensors to the selected device
    ktraj = torch.tensor(ktraj, dtype=torch.float32).to(device)  # Shape: (num_samples, 3)
    kdata = torch.tensor(kdata, dtype=torch.complex64).to(device) 
    
    # Reshape kdata into [1, 1, num_samples]
    kdata = kdata.view(1, 1, -1)  # Adds batch size and coil dimensions
    
    # Move it to the correct device (e.g., CUDA or CPU)
    kdata = kdata.to(device)
    
    # Print the shapes and device of the tensors
    print('ktraj shape: {}'.format(ktraj.shape))
    print('kdata shape: {}'.format(kdata.shape))
    
    # Check the device of both tensors
    print("ktraj device:", ktraj.device)
    print("kdata device:", kdata.device)
    
    
    # In[45]:
    
    
    # Initialize the adjoint NUFFT operator
    adjnufft_ob = tkbn.KbNufftAdjoint(
        im_size=im_size,
        grid_size=grid_size,
    ).to(kdata.device)  # Move to the same device as kdata_torch (CPU or GPU)
    
    print(adjnufft_ob)
    
    
    # In[46]:
    
    
    # adjnufft back
    # method 1: no density compensation (blurry image)
    image_blurry = adjnufft_ob(kdata, ktraj)
    
    
    # In[57]:
    
    
    # method 2: use density compensation
    dcomp = tkbn.calc_density_compensation_function(ktraj=ktraj, im_size=im_size)
    image_sharp = adjnufft_ob(kdata * dcomp, ktraj)
    
    
    # In[ ]:
    
    
    image_blurry_numpy = np.squeeze(image_blurry.cpu().numpy())
    image_sharp_numpy = np.squeeze(image_sharp.cpu().numpy())
    
    print(image_blurry_numpy.shape)
    
    # Get the middle slice along the first axis (e.g., if shape is [1, 1, num_samples, height, width])
    slice_idx = image_blurry_numpy.shape[0] // 2
    print(slice_idx)
    
    # Extract the middle slice (assuming it's the 4th dimension in [batch, coil, num_samples, height, width])
    middle_blurry_slice = np.abs(image_blurry_numpy[slice_idx, :,:])
    middle_sharp_slice = np.abs(image_sharp_numpy[slice_idx, :, :])
    
    # # Plot the middle slices
    # fig, axes = plt.subplots(1, 2, figsize=(12, 6))
    
    # axes[0].imshow(middle_blurry_slice, cmap='gray')
    # axes[0].set_title("Middle Slice - Blurry Image")
    
    # axes[1].imshow(middle_sharp_slice, cmap='gray')
    # axes[1].set_title("Middle Slice - Sharp Image")
    
    # # Save both figures
    # fig.savefig("middle_slice_comparison.png", bbox_inches='tight')
    
    # Optionally, save each plot individually (for each slice)
    fig_blurry, ax_blurry = plt.subplots(figsize=(6, 6))
    ax_blurry.imshow(middle_blurry_slice, cmap='gray')
    ax_blurry.set_title("Middle Slice - Blurry Image")
    
    folder_name = "saved_images_s_te"
    
    # Create the folder if it doesn't exist
    os.makedirs(folder_name, exist_ok=True)
    
    # Save the figure inside the folder
    fig_blurry.savefig(os.path.join(folder_name, f"middle_blurry_slice_{x}.png"), bbox_inches='tight')
    plt.close(fig_blurry) 
    
    fig_sharp, ax_sharp = plt.subplots(figsize=(6, 6))
    ax_sharp.imshow(middle_sharp_slice, cmap='gray')
    ax_sharp.set_title("Middle Slice - Sharp Image")
    
    fig_sharp.savefig(os.path.join(folder_name, f"middle_sharp_slice_{x}.png"), bbox_inches='tight')
    plt.close(fig_sharp)
    
    #plt.show()

    data_f = "images_s_te"

    # Create the folder if it doesn't exist
    os.makedirs(data_f, exist_ok=True)
    reshaped = np.reshape(image_sharp_numpy, (-1, fov))
    #reshaped = image_sharp_numpy.reshape(-1, 3)
    file_path = os.path.join(data_f, f'imagesharp{x}.txt')
    np.savetxt(file_path, reshaped, fmt='%.6f')

#loaded_data = loaded_data.reshape(224, 28952, 3)
# In[ ]:




