function mse = mymse(im,steplen,M)
% output: mse: MSE between the original and the reconstructed images
size_im = size(im);
[m,n] = size(im);
size_blk = size_im/M;
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
    end
end
mse = sum((im(:)-im_recon(:)).^2)/(m*n);
end

