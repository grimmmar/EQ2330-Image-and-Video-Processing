function mse = mse_coeff(oc,qc)
% input: oc: original coefficients
%        qc: quantized coefficients
[m,n] = size(oc);
mse = sum((oc-qc).^2,'all')/(m*n);
end

