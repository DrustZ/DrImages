
% read source image
img_src = im2double(imread('./imgs/storm.jpg'));

% read target image
img_tar = im2double(imread('./imgs/ocean_day.jpg'));
tic
% convert source & target image from RGB to Lab
 img_lab_s = rgb2lab(img_src);
 img_lab_t = rgb2lab( img_tar );
toc

% do color transfer in Lab colorspace
 img_lab_res = color_transfer( img_lab_s, img_lab_t );

tic
% convert result back to RGB color space
  img_res = lab2rgb( img_lab_res );
toc

figure, imshow( img_res );