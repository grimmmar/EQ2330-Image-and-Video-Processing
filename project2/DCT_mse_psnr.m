% assignment 2.3.1
% The average distortion d will be the mean squared error between the original and the
% reconstructed images. Compare d with the mean squared error between the original and
% the quantized DCT coefficients.
clc;
clear;

im = double(imread('boats512x512.tif'));
M = 8;
steplen = 1;
size_im = size(im);
size_blk = size_im/M;
mse_oq = 0;
im_recon = zeros(size_im);

for i = 1:size_blk(1)
    for j = 1:size_blk(2)
        row_index = (i-1)*M+1:i*M;
        col_index = (j-1)*M+1:j*M;
        im_blk = im(row_index,col_index);
        % DCT
        [im_dct,A] = mydct2(im_blk,M);
        % quantizer
        im_quant = uniquant(im_dct,steplen);
        % inverse DCT
        im_idct = A'*im_quant*A;
        im_recon(row_index,col_index) = im_idct;
        % MSE between original and quantized DCT coefficient
        mse_oq = mse_oq + sum((im_dct(:)-im_quant(:)).^2)/length(im_dct(:));
    end
end
mse_oq = mse_oq/(size_blk(1)*size_blk(2));
% MSE bwtween original and reconstructed image
mse_or = sum((im(:)-im_recon(:)).^2)/length(im(:));

% PSNR
d = mse_or;
psnr = 10*log10(255^2/d);
