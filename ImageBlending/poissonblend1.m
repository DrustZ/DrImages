function poissonblend
    img1 = im2double(imread('bi2.jpg'));
    img2 = im2double(imread('mo.jpeg'));
    [BW, xi, yi] = roipoly(img1);  
    points = size(xi);
    ords = zeros(points(1)-1,2);
    ords(:,1) = xi(1:end-1);
    ords(:,2) = yi(1:end-1);
    
    figure, imshow(img2);
    h = impoly(gca, ords);
    position = wait(h);
    BW2 = createMask(h);
    close all
    
    disp(3);
    mx = int16(min(xi)); my = int16(min(yi)); Mx = int16(max(xi)); My = int16(max(yi));
    mask = BW(my-1:My+1, mx-1:Mx+1);
    source = img1(my-1:My+1, mx-1:Mx+1, :);
    mx = min(position(:,1)); my = min(position(:,2)); Mx = max(position(:,1)); My = max(position(:,2));
    dest = img2(my-1:My+1, mx-1:Mx+1, :);
    
% %blend
    dest(:,:,1) = CG(source(:,:,1), dest(:,:,1), mask);
    dest(:,:,2) = CG(source(:,:,2), dest(:,:,2), mask);
    dest(:,:,3) = CG(source(:,:,3), dest(:,:,3), mask);
    img2(my-1:My+1, mx-1:Mx+1, :) = dest;
    imshow(img2);
    imwrite(uint8(img2),'blend.png');
end

function imgback = Jacobi(source, dest, mask)
%get B and calculate Ax = b using Jacobi
     df0 = 1E32;
     dest(mask) =0;
     dest0 = dest;
     K = [0,-1,0; -1,4,-1; 0,-1,0];
     B = imfilter(source, K, 'replicate');
     K=[0,1,0;1,0,1;0,1,0];
     for i = 1:10000
        lpf = imfilter(dest, K, 'replicate');
        dest(mask) = (B(mask)+lpf(mask))/4;
        dif = abs(dest-dest0);
        df = max(dif(:));
%         fprintf('%d %g %g\n',i, df, (df0 - df)/df0);
         dest0 = dest;
         df0 = df;
     end
     imgback = dest;
end

function imgback = CG(source, dest, mask)
%get B and calculate Ax = b using CG
%the mixing one
%     [hg1, vg1] = imgrad(source);
%     [hg2, vg2] = imgrad(dest);
%     hg1 = findmax(hg1, hg2);
%     vg1 = findmax(vg1, vg2);
%     B = grad2lap(hg1, vg1);
%     
     K = [0,-1,0; -1,4,-1; 0,-1,0];
     B = imfilter(source, K, 'replicate');
     temp = imfilter(dest, K,'replicate');%I = Ax
     
     x = dest(mask);
     I = temp(mask);
     b = B(mask);
     
     r = b - I;
     p = r;
     theta = r.'*r;
     theta0 = theta;
     i = 0;
     while i < 10000
         %q = Ar
         temp(mask) = p;
         q = imfilter(temp, K, 'replicate');
         q = q(mask);
         %a = theta/(rTq)
         a = theta0 / (p.'*q);
         %x = x + ar
         x = x + p*a;
         r = r - q*a;
         
         %theta = rTr
         theta = r.'*r;
         if sqrt(theta) < 1e-3
             break;
         end
         
         p = r+(theta/theta0)*p;
         theta0 = theta;
         i = i + 1;
         dest(mask) = x;
         temp = imfilter(dest, K,'replicate');%I = Ax
     end
     imgback = dest;
     imgback(mask) = x;
end

function mt = findmax(mat1, mat2)
    ab1 = abs(mat1);
    ab2 = abs(mat2);
    gre1 = bsxfun(@gt, ab1, ab2);
    mt = mat1;
    mt(gre1) = mat1(gre1);
    mt(logical(1-gre1)) = mat2(logical(1-gre1));
end

function [Fh Fv Bh Bv] = imgrad(X)
    Kh = [ 0,-1, 1 ];
    Kv = [ 0;-1; 1 ];

    Fh = imfilter(X,Kh,'replicate');
    Fv = imfilter(X,Kv,'replicate');

    if( nargout >= 3 )
     Bh = circshift(Fh,[0,1]);
     Bv = circshift(Fv,[1,0]);
    end
end

function lap = grad2lap(Fh, Fv)
    lap = circshift(Fh,[0,1]) + circshift(Fv,[1,0]) - Fh - Fv;
end