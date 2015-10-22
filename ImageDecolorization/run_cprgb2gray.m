
% input color image
Im = im2double(imread('./imgs/2.png'));

% Part 1: Basic Decolorization Algorithm
%[gIm, origIm] = cprgb2gray(Im);
[gIm, origIm] = CPD1(Im);
 %Part 2: Decolorization Evaluation: Color Contrast Preserving Ratio (CCPR)
       ccprRes = 0;
       for tau = 1:15
           ccpr = CCPR(origIm, Im, tau);
           ccprRes = ccprRes + ccpr;
           fprintf('CCPR is %f for %d\n', ccpr, tau);
       end
       
fprintf('CCPR is %f', ccprRes/24);
figure, imshow(Im), figure, imshow(gIm);