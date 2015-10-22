function [gIm, origIm] = CPD2gray(im)
	% input 'im' is a color image
	% output gIm is the resulting grayscale image
    [h, w, c] = size(im);
	% DO: Convert the input to LAB space
    lab = rgb2lab(im); l = lab(:,:,1); a = lab(:,:,2); b = lab(:,:,3);
    imgs = initparams(im);
    tic
    im_delta_x = cal_delta([1,-1],l,a,b); im_delta_y = cal_delta([1;-1],l,a,b);
    imgs_delta_x = cal_deltas([1,-1],imgs); imgs_delta_y = cal_deltas([1;-1],imgs);
    
    maskx = find_strong_order(imgs_delta_x{1}, imgs_delta_x{2}, imgs_delta_x{3});
    masky = find_strong_order(imgs_delta_y{1}, imgs_delta_y{2}, imgs_delta_y{3});
    w = [0; 0; 0; 0; 0; 0; 0; 0; 0];
    %calculate w
      
    for i = 1:15
        %calculate beta
        beta_x = cal_beta(w, im_delta_x, imgs_delta_x, maskx);
        beta_y = cal_beta(w, im_delta_y, imgs_delta_y, masky);
        
        %x-diff
        right = (2*beta_x-1) .* imgs_delta_x{1} .* im_delta_x;
        right = sum(sum(right));
        left = compose_left(imgs_delta_x, 1);
        
        for j = 2:9
            rightt = (2*beta_x-1) .* imgs_delta_x{j} .* im_delta_x;
            right = cat(1, right, sum(sum(rightt)));
            leftt =  compose_left(imgs_delta_x, j);           
            left = cat(1, left, leftt);
        end
        %y-diff
        for j = 1:9
          rightt = (2*beta_y-1) .* imgs_delta_y{j} .* im_delta_y;
          right(j) = right(j) + sum(sum(rightt));
          leftt =  compose_left(imgs_delta_y, j);           
          left(j,:) = left(j,:)+leftt;
        end
          
        w = left\right;
%         disp(w);
    end
    toc
    origIm = w(1) * imgs{1} ;
    for i = 2:9
       origIm = origIm + w(i) * imgs{i};
    end
    
	% Normalization and output gIm
	gIm = (origIm - min(origIm(:)))/ (max(origIm(:)) - min(origIm(:)));

end

function imgs = initparams(img)
%     [h w c] = size(img);
    imgs = cell(9,1);
    %index 1-9 for r, g, b, rr, gg, bb, rg, gb, rb
    r = img(:,:,1); g = img(:,:,2); b = img(:,:,3);
    imgs{1} = r;    imgs{2} = g;    imgs{3} = b;
    imgs{4} = r.^2; imgs{5} = g.^2; imgs{6} = b.^2;
    imgs{7} = r.*g; imgs{8} = g.*b; imgs{9} = r.*b;
end

function delta = cal_delta(filter, l, a, b)
    l = imfilter(l, filter, 'replicate'); 
    a = imfilter(a, filter, 'replicate');
    b = imfilter(b, filter, 'replicate');
    delta = sqrt(l.^2 + a.^2 + b.^2).*sign(l);
end

function deltas = cal_deltas(filter, imgs)
    [counts,~] = size(imgs);
    deltas = cell(counts,1);
    for i = 1:counts
       deltas{i} = imfilter(imgs{i}, filter, 'replicate');
    end
end

function mask = find_strong_order(deltar, deltag, deltab)
    mask = ones(size(deltar));
    maskr = deltar > 0; maskg = deltag > 0; maskb = deltab > 0;
    maskbig = maskr & maskg & maskb;
    maskr = deltar < 0; maskg = deltag < 0; maskb = deltab < 0;
    masksml = maskr & maskg & maskb;
    maskbs = maskbig | masksml;
    mask(~maskbs) = 0.5;
end

function beta = cal_beta(w, theta, l, mask)
    amount_l = w(1)*l{1} + w(2)*l{2} + w(3)*l{3};
    amount_l = amount_l + w(4)*l{4} + w(5)*l{5} + w(6)*l{6};
    amount_l = amount_l + w(7)*l{7} + w(8)*l{8} + w(9)*l{9};
    G1 = normpdf(amount_l, theta, 15); G2 = normpdf(amount_l, -theta,15);
    G = G1.*mask + G2.*(1-mask);
    beta = G1.*mask ./ max(G, eps);
    beta(mask>0.5) = 1;
end

function left = compose_left(imgs_delta, j)
    left1 = imgs_delta{1} .* imgs_delta{j}; left1 = left1(:);
    left2 = imgs_delta{2} .* imgs_delta{j}; left2 = left2(:);
    left3 = imgs_delta{3} .* imgs_delta{j}; left3 = left3(:);
    left4 = imgs_delta{4} .* imgs_delta{j}; left4 = left4(:);
    left5 = imgs_delta{5} .* imgs_delta{j}; left5 = left5(:);
    left6 = imgs_delta{6} .* imgs_delta{j}; left6 = left6(:);
    left7 = imgs_delta{7} .* imgs_delta{j}; left7 = left7(:);
    left8 = imgs_delta{8} .* imgs_delta{j}; left8 = left8(:);
    left9 = imgs_delta{9} .* imgs_delta{j}; left9 = left9(:);
    left = cat(2, sum(sum(left1)), sum(sum(left2)), sum(sum(left3)), ...
            sum(sum(left4)), sum(sum(left5)), sum(sum(left6)), sum(sum(left7)), sum(sum(left8)), sum(sum(left9)));
end