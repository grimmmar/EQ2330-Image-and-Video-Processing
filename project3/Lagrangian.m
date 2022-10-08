function J = Lagrangian(D,Q,R)
% INPUT: D: mean square error distortion
%        Q: the squared quantizer step-size
%        R: the rate in bits
lamda = 0.002*Q^2;
J = D + lamda*R;
end

