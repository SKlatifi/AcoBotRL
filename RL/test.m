
close all;
clear all;
clc

ref = zeros(256);
ref(100:140,100:150) = 1;
A = zeros(256);
A(170:220,170:200) = 1;
figure
subplot(1,2,1)
imshow(ref);
subplot(1,2,2)
imshow(A)
sim_ssim = ssim(A,ref);
sim_cross = normxcorr2(ref,A);
figure, surf(sim_cross), shading flat
sim_psnr = psnr(A,ref);
sim_immse = immse(A, ref);