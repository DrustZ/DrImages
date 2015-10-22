function img_res = color_transfer( img_src, img_tar )
    % img_src - input source image in Lab colorspace
    % img_tar - input target image in Lab colorspace
    % img_res - color transfered image from img_src to img_tar
    [hs,ws,cs] = size( img_src );
    [ht,wt,ct] = size( img_tar );
    
    ls = img_src(:,:,1); as = img_src(:,:,2); bs = img_src(:,:,3);
    lt = img_tar(:,:,1); at = img_tar(:,:,2); bt = img_tar(:,:,3);
    % TODO: calculate mean value for each channel of img_src & img_tar
    m_ls = mean(ls(:)); m_as = mean(as(:)); m_bs = mean(bs(:)); 
    m_lt = mean(lt(:)); m_at = mean(at(:)); m_bt = mean(bt(:));
    
    % TODO: calculate std value for each channel of img_src & img_tar
    s_ls = std(ls(:)); s_as = std(as(:)); s_bs = std(bs(:)); 
    s_lt = std(lt(:)); s_at = std(at(:)); s_bt = std(bt(:)); 
    
    % TODO: do color transfer
    img_res = zeros(hs, ws, cs);
    img_res(:,:,1) = (ls - m_ls)*s_lt/s_ls + m_lt;
    img_res(:,:,2) = (as - m_as)*s_at/s_as + m_at;
    img_res(:,:,3) = (bs - m_bs)*s_bt/s_bs + m_bt;
    
    % output img_res
end