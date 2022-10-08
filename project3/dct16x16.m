function blkdct = dct16x16(blk)
blkdct = blkproc(blk,[8 8],@dct2);
end

