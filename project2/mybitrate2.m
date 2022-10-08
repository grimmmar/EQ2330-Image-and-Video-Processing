function [bitrate,entropy] = mybitrate2(im,steplen,wname)
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

cAq = [cA1q(:);cA2q(:);cA3q(:);cA4q(:)];
cHq = [cH1q(:);cH2q(:);cH3q(:);cH4q(:)];
cVq = [cV1q(:);cV2q(:);cV3q(:);cV4q(:)];
cDq = [cD1q(:);cD2q(:);cD3q(:);cD4q(:)];

entropy = zeros(1,4);
entropy(1) = myentropy(cAq,steplen);
entropy(2) = myentropy(cHq,steplen);
entropy(3) = myentropy(cVq,steplen);
entropy(4) = myentropy(cDq,steplen);

bitrate = mean(entropy);
end

