clear
clc
%%
long_data= load("Z:\home\mri_fyp\phantom\sequence\resultImage_l_te.mat");
short_data = load("Z:\home\mri_fyp\phantom\sequence\resultImage_s_te.mat");

long_img = long_data.resultImage_l;
short_img = short_data.resultImage_s;

fov =96;
l = 0.8e-3; 
s = 47e-6;

t2_star = zeros(fov,fov,fov);
for x = 1:fov
    for y = 1:fov
        for z = 1:fov
            ratio = short_img(x, y, z) / long_img(x, y, z);
            if ratio > 0  % Ensure log is valid
                t2_star(x, y, z) = (l - s) / log(ratio);
            else
                t2_star(x, y, z) = NaN;  % Assign NaN for invalid values
            end
        end
    end
end

%%
slice = t2_star(10:end-10,50:end-15,15:25);
volshow(slice)

%%
mean(slice,"all")
