function [bitrate,entropy] = mybitrate(im,steplen,M)
size_im = size(im);
size_blk = size_im/M;
im_quant = zeros(size_im);
for i = 1:size_blk(1)
    for j = 1:size_blk(2)
        row_index = (i-1)*M+1:i*M;
        col_index = (j-1)*M+1:j*M;
        im_blk = im(row_index,col_index);
        % DCT
        [im_dct,~] = mydct2(im_blk,M);
        % quantizer
        im_q = uniquant(im_dct,steplen);
        im_quant(row_index,col_index) = im_q;
    end
end

K = zeros(8,8,64*64); 
entropy = zeros(M);

for m = 1:M
    for n=1:M
        for index =1
            for p = 0:63
                for q = 0:63
                    K(m,n,index) = im_quant(m+8*p,n+8*q);
                    index = index+ 1;
                end
            end
        end
    end
end

for m=1:M
    for n=1:M
        value = K(m,n,:);
        bins= min(value):steplen:max(value);
        pr = hist(value(:),bins(:));
        prb = pr/sum(pr);
        etrpy = -sum(prb.*log2(prb+eps));
        entropy(m,n) = etrpy;
    end
end
bitrate = mean2(entropy);
end

