function [mse,mse_co] = mymse2(im,steplen,wname)
% output: mse: MSE between the original and the reconstructed images
%         mse_co: MSE between  the original and the quantized wavelet coefficients

[cA1,cH1,cV1,cD1] = dwt2_analysis(im,wname);
[cA2,cH2,cV2,cD2] = dwt2_analysis(cA1,wname);
[cA3,cH3,cV3,cD3] = dwt2_analysis(cA2,wname);
[cA4,cH4,cV4,cD4] = dwt2_analysis(cA3,wname);

%quantization for step size 1
cA4q = uniquant(cA4,steplen);
cA3q = uniquant(cA3,steplen);
cA2q = uniquant(cA2,steplen);
cA1q = uniquant(cA1,steplen);

cH4q = uniquant(cH4,steplen);
cH3q = uniquant(cH3,steplen);
cH2q = uniquant(cH2,steplen);
cH1q = uniquant(cH1,steplen);

cV4q = uniquant(cV4,steplen);
cV3q = uniquant(cV3,steplen);
cV2q = uniquant(cV2,steplen);
cV1q = uniquant(cV1,steplen);

cD4q = uniquant(cD4,steplen);
cD3q = uniquant(cD3,steplen);
cD2q = uniquant(cD2,steplen);
cD1q = uniquant(cD1,steplen);

% synthesis
recon3 = dwt2_synthesis(cA4q,cH4q,cV4q,cD4q,wname);
recon2 = dwt2_synthesis(recon3,cH3q,cV3q,cD3q,wname);
recon1 = dwt2_synthesis(recon2,cH2q,cV2q,cD2q,wname);
recon = dwt2_synthesis(recon1,cH1q,cV1q,cD1q,wname);

% mse between orignal image and reconstructed image
mse = mse_coeff(recon,im);

% mse between original coeff. and quantized coeff.
mse_co = zeros(4,4);
mse_co(1,1) = mse_coeff(cA1q,cA1);
mse_co(1,2) = mse_coeff(cA2q,cA2);
mse_co(1,3) = mse_coeff(cA3q,cA3);
mse_co(1,4) = mse_coeff(cA4q,cA4);
mse_co(2,1) = mse_coeff(cH1q,cH1);
mse_co(2,2) = mse_coeff(cH2q,cH2);
mse_co(2,3) = mse_coeff(cH3q,cH3);
mse_co(2,4) = mse_coeff(cH4q,cH4);
mse_co(3,1) = mse_coeff(cV1q,cV1);
mse_co(3,2) = mse_coeff(cV2q,cV2);
mse_co(3,3) = mse_coeff(cV3q,cV3);
mse_co(3,4) = mse_coeff(cV4q,cV4);
mse_co(4,1) = mse_coeff(cD1q,cD1);
mse_co(4,2) = mse_coeff(cD2q,cD2);
mse_co(4,3) = mse_coeff(cD3q,cD3);
mse_co(4,4) = mse_coeff(cD4q,cD4);

end

