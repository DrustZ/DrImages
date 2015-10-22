function  img_rgb = color_lab2rgb( img_lab )
%use method on http://www.easyrgb.com/index.php?X=MATH&H=08#text8
    [h,w,c] = size( img_lab );
    l = reshape(img_lab(:,:,1),1,h*w); a = reshape(img_lab(:,:,2),1,h*w); b = reshape(img_lab(:,:,3),1,h*w);
    %Lab to XYZ
    Y = (l+16)/116;
    X = a/500 + Y;
    Z = Y - b/200;
    
    T = 0.008856;
    m1 = (X.^3)<T; X = m1.*(X-16/116)/7.787+(~m1).*(X.^3); 
    m2 = (Y.^3)<T; Y = m2.*(Y-16/116)/7.787+(~m2).*(Y.^3); 
    m3 = (Z.^3)<T; Z = m3.*(Z-16/116)/7.787+(~m3).*(Z.^3); 

    X = X * 95.047;
    Y = Y * 100;
    Z = Z * 108.883;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %XYZ to RGB
    X = reshape(X/100,1,h*w); Y = reshape(Y/100,1,h*w); Z = reshape(Z/100,1,h*w); 
    % MAT = [3.2406  -1.5372 -0.4986;
    %       -0.9689   1.8758  0.0415;
    %        0.0557  -0.2040  1.057];
    % img_rgb = MAT*[X;Y;Z];
    % R = img_rgb(1,:); G = img_rgb(2,:); B = img_rgb(3,:);
    R = X *  3.2404542 + Y * -1.5371385 + Z * -0.4985314;
    G = X * -0.9692660 + Y *  1.8760108 + Z *  0.0415560;
    B = X *  0.0556434 + Y * -0.2040259 + Z *  1.0572252;
    T = 0.003130805;

    m1 = R>T; R = m1.*(1.055*R.^(1/2.4)-0.055)+(~m1).*(R*12.92); 
    m2 = G>T; G = m2.*(1.055*G.^(1/2.4)-0.055)+(~m2).*(G*12.92);
    m3 = B>T; B = m3.*(1.055*B.^(1/2.4)-0.055)+(~m3).*(B*12.92);
    img_rgb = cat(3, reshape(R,[h,w]), reshape(G,[h,w]), reshape(B,[h,w]));
%     disp(img_rgb);
    %DO: lab to log(LMS)
%     converter1 = [1/sqrt(3), 1/sqrt(6), 1/sqrt(2); ...
%                   1/sqrt(3), 1/sqrt(6),-1/sqrt(2); ...
%                   1/sqrt(3),-2/sqrt(6),        0];
%     img_lab = [l;a;b];
%     logLMS = converter1 * img_lab; 
% %      logLMS(:,:,1) = arrayfun(@(l,m,s) converter1(1,:)*[l;m;s], img_lab(:,:,1), img_lab(:,:,2), img_lab(:,:,3)); 
% %      logLMS(:,:,2) = arrayfun(@(l,m,s) converter1(2,:)*[l;m;s], img_lab(:,:,1), img_lab(:,:,2), img_lab(:,:,3)); 
% %      logLMS(:,:,3) = arrayfun(@(l,m,s) converter1(3,:)*[l;m;s], img_lab(:,:,1), img_lab(:,:,2), img_lab(:,:,3)); 
% %     parfor i = 1:h
% %         for j = 1:w
% %         logLMS(i,j,:) = converter1*squeeze(img_lab(i,j,:));
% %         end
% %     end
%         
%     % DO: log(LMS) to LMS
%     LMS = exp(logLMS);
%         
%     % DO: LMS to RGB
%     converter2 = [0.3811, 0.5783, 0.0402; ...
%                0.1967, 0.7244, 0.0782; ...
%                0.0241, 0.1288, 0.8444];
%     img_rgb = converter2\LMS;
%     r = reshape(img_rgb(1,:),h,w); g = reshape(img_rgb(2,:),h,w); b = reshape(img_rgb(3,:),h,w);
%     img_rgb = cat(3,r,g,b);
%     converter2 = [4.4687   -3.5887    0.1196; ...
%                  -1.2197    2.3831   -0.1626; ...
%                   0.0585   -0.2611    1.2057];
%     img_rgb = zeros(h, w, c);
%     img_rgb(:,:,1) = arrayfun(@(l,m,s) converter2(1,:)*[l;m;s], LMS(:,:,1), LMS(:,:,2), LMS(:,:,3));
%     img_rgb(:,:,2) = arrayfun(@(l,m,s) converter2(2,:)*[l;m;s], LMS(:,:,1), LMS(:,:,2), LMS(:,:,3));
%     img_rgb(:,:,3) = arrayfun(@(l,m,s) converter2(3,:)*[l;m;s], LMS(:,:,1), LMS(:,:,2), LMS(:,:,3));
%      parfor i = 1:h
%          for j = 1:w
%          img_rgb(i,j,:) = converter2\squeeze(LMS(i,j,:));
%          end
%      end
    % Output: img_rgb
end