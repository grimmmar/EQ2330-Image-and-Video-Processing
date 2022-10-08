% assignment 2.3.2
% plot rate-PSNR curve
clc;
clear;

im1 = double(imread('boats512x512.tif'));
im2 = double(imread('harbour512x512.tif'));
im3 = double(imread('peppers512x512.tif'));
M = 8;
steplen = 1:10;
bitrate = zeros(1,10);
psnr = zeros(1,10);

for  i = steplen
    step = 2^(i-1);
    mse(1) = mymse(im1,step,M);
    mse(2) = mymse(im2,step,M);
    mse(3) = mymse(im3,step,M);
    d = mean(mse);
    psnr(i) = 10*log10(255^2/d);
   
    [bitrates(1),entropy1] = mybitrate(im1,step,M);
    [bitrates(2),entropy2] = mybitrate(im2,step,M);
    [bitrates(3),entropy3] = mybitrate(im3,step,M);
    
    if(i == 7)
        entropy = (entropy1+entropy2+entropy3)/3;
        figure;
        surf(entropy);
        title('Average entropy of DCT coefficients');
    end
    
    bitrate(i) = mean(bitrates);
end
