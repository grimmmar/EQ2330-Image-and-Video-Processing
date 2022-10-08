function quant = uniquant(x,steplen)
% uniform mid-tread quantizer function
quant = round(x/steplen)*steplen;
end

