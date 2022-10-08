% assignment 3.4.2
% plot rate-PSNR curve
clc;
clear;

im1 = double(imread('boats512x512.tif'));
im2 = double(imread('harbour512x512.tif'));
im3 = double(imread('peppers512x512.tif'));
load('coeffs.mat');
wname = 'db4';
% initialize
steplen = 1:10;
bitrate = zeros(1,10);
psnr = zeros(1,10);
entropy = zeros(1,4,10);

for  i = steplen
    step = 2^(i-1);
    [mse(1),~] = mymse2(im1,step,wname);
    [mse(2),~] = mymse2(im2,step,wname);
    [mse(3),~] = mymse2(im3,step,wname);
    d = mean(mse);
    psnr(i) = 10*log10(255^2/d);
    
    [bitrates(1),entropy1] = mybitrate2(im1,step,wname);
    [bitrates(2),entropy2] = mybitrate2(im2,step,wname);
    [bitrates(3),entropy3] = mybitrate2(im3,step,wname);
    entropy(:,:,i) = (entropy1+entropy2+entropy3)/3;
    bitrate(i) = mean(bitrates);
end
