function ccrpRe = CCPR(imGray, imColor, THR)

	% ccrpRe evaluation code
    lab_color = rgb2lab(imColor);
    color_delta_x = cal_delta([1,-1],lab_color(:,:,1),lab_color(:,:,2),lab_color(:,:,3));
    color_delta_y = cal_delta([1;-1],lab_color(:,:,1),lab_color(:,:,2),lab_color(:,:,3));
    gray_delta_x = imfilter(imGray, [1,-1], 'replicate');
    gray_delta_y = imfilter(imGray, [1;-1], 'replicate');
    mask_x = abs(color_delta_x) > THR; mask_y = abs(color_delta_y) > THR;
    mask = (mask_x + mask_y) > 0;
    count = size(imGray(mask));
    mask_x = abs(gray_delta_x) > THR;  mask_y = abs(gray_delta_y) > THR;
    mask2 = (mask_x + mask_y) > 0;
    count2 = size(mask2(mask2(mask) > 0));
    ccrpRe =  count2 / count;
end

function delta = cal_delta(filter, l, a, b)
    l = imfilter(l, filter, 'replicate'); 
    a = imfilter(a, filter, 'replicate');
    b = imfilter(b, filter, 'replicate');
    delta = arrayfun(@(x,y,z) sign(x)*norm([x y z]), l, a, b);
end