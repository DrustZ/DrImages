%faster version of CPD2gray (lower quality)
function [gIm, origIm] = fCPD2gray(im)
	% input 'im' is a color image
	% output gIm is the resulting grayscale image
    [h,w,~] = size(im);
	% DO: Convert the input to LAB space

    lab = rgb2lab(im); ll = lab(:,:,1); aa = lab(:,:,2); bb = lab(:,:,3);
    %index 1-3 for r, g, b
    r = im(:,:,1); g = im(:,:,2); b = im(:,:,3);
    imgs = [r;g;b];
    imgy = [r,g,b];
    tic
    im_delta_x = cal_delta([1,-1],ll,aa,bb); im_delta_y = cal_delta([1;-1],ll,aa,bb);
    imgs_delta_x = imfilter(imgs, [1,-1], 'replicate'); imgs_delta_y = imfilter(imgy, [1;-1], 'replicate'); 
    dyr = imgs_delta_y(:,1:w); dyg = imgs_delta_y(:,w+1:2*w); dyb = imgs_delta_y(:,2*w+1:3*w);
    dxr = imgs_delta_x(1:h,:); dxg = imgs_delta_x(h+1:2*h,:); dxb = imgs_delta_x(2*h+1:end,:);
    maskx = find_strong_order(dxr,dxg,dxb);
    masky = find_strong_order(dyr,dyg,dyb);
    mwr = 0; mwg = 0; mwb = 0;
    mindis = -100;
    tic
    %calculate w
    count = 0;
    for wr = 0:0.1:1
        for wg = 0:0.1:1-wr
              wb = 1-wr-wg;
              tmp = cal_energy(wr,wg,wb,dxr,dxg,dxb,im_delta_x,maskx);
              tmp = tmp + cal_energy(wr,wg,wb,dyr,dyg,dyb,im_delta_y,masky);
              if tmp > mindis
                 mindis = tmp;
                 mwr = wr; mwg = wg; mwb = wb;
              end
              count = count+1;
        end
    end
    toc
    origIm = mwr * r + mwg * g + mwb * b;
    
	% Normalization and output gIm
	gIm = (origIm - min(origIm(:)))/ (max(origIm(:)) - min(origIm(:)));

end

function delta = cal_delta(filter, l, a, b)
    l = imfilter(l, filter, 'replicate'); 
    a = imfilter(a, filter, 'replicate');
    b = imfilter(b, filter, 'replicate');
    delta = sqrt(l.^2 + a.^2 + b.^2).*sign(l);
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

function energy = cal_energy(wr,wg,wb,r,g,b,im_delta,mask)
    amount_l = wr*r+ wg*g +wb*b;
    G1 = normpdf(amount_l, im_delta, 25); G2 = normpdf(amount_l, -im_delta,25);
    G = G1.*mask + G2.*(1-mask);
    energy = sum(sum(abs(log(G))));
end
