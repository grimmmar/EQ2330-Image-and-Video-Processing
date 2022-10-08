% Comparison of DCT and FWT
clc;
clear;

im1 = double(imread('boats512x512.tif'));
im2 = double(imread('harbour512x512.tif'));
im3 = double(imread('peppers512x512.tif'));
M = 8;
load('coeffs.mat');
wname = 'db4';
steplen = 1:10;
bitrate_dct = zeros(1,10);
bitrate_fwt = zeros(1,10);
psnr_dct = zeros(1,10);
psnr_fwt = zeros(1,10);

for  i = steplen
    step = 2^(i-1);
    mse_dct(1) = mymse(im1,step,M);
    mse_dct(2) = mymse(im2,step,M);
    mse_dct(3) = mymse(im3,step,M);
    d = mean(mse_dct);
    psnr_dct(i) = 10*log10(255^2/d);
   
    [bitrates(1),entropy1] = mybitrate(im1,step,M);
    [bitrates(2),entropy2] = mybitrate(im2,step,M);
    [bitrates(3),entropy3] = mybitrate(im3,step,M);

    bitrate_dct(i) = mean(bitrates);
end

for  i = steplen
    step = 2^(i-1);
    [mse_fwt(1),~] = mymse2(im1,step,wname);
    [mse_fwt(2),~] = mymse2(im2,step,wname);
    [mse_fwt(3),~] = mymse2(im3,step,wname);
    d = mean(mse_fwt);
    psnr_fwt(i) = 10*log10(255^2/d);
    
    [bitrates(1),entropy1] = mybitrate2(im1,step,wname);
    [bitrates(2),entropy2] = mybitrate2(im2,step,wname);
    [bitrates(3),entropy3] = mybitrate2(im3,step,wname);
    bitrate_fwt(i) = mean(bitrates);
end

figure;
plot(bitrate_dct,psnr_dct,'b-o');
hold on;
plot(bitrate_fwt,psnr_fwt,'r-o');
xlabel('Rate [bits/pixel]');
ylabel('PSNR [dB]');
title('rate-PSNR curve');
legend('DCT','FWT');
grid on;