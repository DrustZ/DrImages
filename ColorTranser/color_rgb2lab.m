function img_lab = color_rgb2lab( img_rgb )
    [h,w,c] = size( img_rgb );
    R = reshape(img_rgb(:,:,1),1,h*w); G = reshape(img_rgb(:,:,2),1,h*w); B = reshape(img_rgb(:,:,3),1,h*w);
    rm = R>0.04045;
    gm = G>0.04045;
    bm = B>0.04045;
    nR = rm.*((R+0.055)/1.055).^2.4 + (~rm).*(R/12.91999);
    nG = gm.*((G+0.055)/1.055).^2.4 + (~rm).*(G/12.91999);
    nB = bm.*((B+0.055)/1.055).^2.4 + (~rm).*(B/12.91999);

    X = nR * 0.4124 + nG * 0.3576 + nB * 0.1805;
    Y = nR * 0.2126 + nG * 0.7152 + nB * 0.0722;
    Z = nR * 0.0193 + nG * 0.1192 + nB * 0.9505;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %XYZ to Lab
    X = X / 0.95047;
    Y = Y ;
    Z = Z / 1.08883;
%     img_lab = xyz2lab(cat(3, reshape(X,h,w),reshape(Y,h,w), reshape(Z,h,w)));
    Xm = X>0.008856;
    Ym = Y>0.008856;
    Zm = Z>0.008856;

    nX = Xm.*(X.^(1/3)) + (~Xm).*(7.787*X+16/116);
    nY = Ym.*(Y.^(1/3)) + (~Ym).*(7.787*Y+16/116);
    nZ = Zm.*(Z.^(1/3)) + (~Zm).*(7.787*Z+16/116);

    L = (116*nY) - 16; a = 500*(nX-nY); b = 200*(nY-nZ);
    L = reshape(L,h,w); a = reshape(a,h,w); b = reshape(b,h,w);
    img_lab = cat(3,L,a,b);
    
     % TODO: RGB to LMS
     % converter1 = [0.3811, 0.5783, 0.0402; 
     %               0.1967, 0.7244, 0.0782; 
     %               0.0241, 0.1288, 0.8444];
     % img_rgb = [R;G;B];
     % LMS = converter1 * img_rgb;
 
     % % DO: LMS to log(LMS)
     % mask = LMS < eps;
     % LMS(mask) = eps;
     % logLMS = log(LMS);
     % % DO: log(LMS) to lab
     % converter2 = [1/sqrt(3), 1/sqrt(3), 1/sqrt(3); ...
     %               1/sqrt(6), 1/sqrt(6),-2/sqrt(6); ...
     %               1/sqrt(2),-1/sqrt(2),        0];
     % img_lab = converter2 * logLMS;
     % l = reshape(img_lab(1,:),h,w); a = reshape(img_lab(2,:),h,w); b = reshape(img_lab(3,:),h,w);
     % img_lab = cat(3,l,a,b);

    % Output: img_lab   
end