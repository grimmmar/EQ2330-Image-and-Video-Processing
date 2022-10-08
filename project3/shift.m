function bestvector = shift(preframe,curframe,shiftvector)
[height,width] = size(preframe);
blksize = 16;
rownum = height/blksize;
colnum = width/blksize;
MSE = zeros(rownum,colnum,length(shiftvector));
bestvector = zeros(1,rownum*colnum);

index = 1;
for i = 1:rownum
    for j = 1:colnum
        for d = 1:length(shiftvector)
            rows = 1+(i-1)*blksize:(i-1)*blksize + blksize;
            cols = 1+(j-1)*blksize:(j-1)*blksize + blksize;
            shiftrows = rows + shiftvector(1,d);
            shiftcols = cols + shiftvector(2,d);
            if(shiftrows(1)<1||shiftcols(1)<1||shiftrows(blksize)>height||shiftcols(blksize)>width)
                MSE(i,j,d) = 99999999999999;
                continue;
            end
            MSE(i,j,d) = mse(preframe(shiftrows,shiftcols),curframe(rows,cols));
        end
        vectors = find(MSE(i,j,:)==min(MSE(i,j,:)));
        if length(vectors)>1
            vectors = vectors(1,1);
        end
        bestvector(1,index) = vectors;
        index = index + 1;
    end
end
end

