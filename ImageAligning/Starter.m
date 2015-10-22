% Input glass plate image
imgname = 'Result/00010v.jpg';
fullimg = imread(imgname);

% Convert to double matrix
fullimg = im2double(fullimg);

% Extract 3 channels from input image
% Calculate the height of each part (about 1/3 of total)
ImgH = floor(size(fullimg,1)/3);

% Separate B-G-R channels
B = fullimg(1:ImgH,:);
G = fullimg(ImgH+1:2*ImgH,:);
R = fullimg(2*ImgH+1:size(fullimg,1),:);

%% Align the images

tic;   % The Timer starts. To Evalute algorithms' efficiency.

%aB = alignSingle(B,G);
%aR = alignSingle(R,G);
[xoffb, yoffb, aB] = alignMulti(B,G);
[xoffr, yoffr, aR] = alignMulti(R,G);

toc;   % The Timer stops and displays time elapsed.

%% Output Results

%crop border step1
xoff = 1; yoff = 1;
xend = 0; yend = 0;
if xoffb > 0 xoff = xoffb; end
if yoffb > 0 yoff = yoffb; end
if xoffr > 0 & xoffr > xoffb xoff = xoffr; end
if yoffr > 0 & yoffr > yoffb yoff = yoffr; end
if xoffb < 0 xend = xoffb; end
if yoffb < 0 yend = yoffb; end
if xoffr < 0 & xoffr < xoffb xend = xoffr; end
if yoffr < 0 & yoffr < yoffb yend = yoffr; end
aR = aR(xoff:end+xend, yoff:end+yend);
aB = aB(xoff:end+xend, yoff:end+yend);
G  =  G(xoff:end+xend, yoff:end+yend);

colorImg = cat(3,aR,G,aB);

%Crop border step2
offset = cropborder(colorImg);
colorImg = colorImg(offset(1):offset(2), offset(3):offset(4), :);

%colorImg = hist_enhance(colorImg);

% Show the resulting image: "imshow" command
imshow(colorImg);

% Save result image to File
imwrite(colorImg,['result-' imgname '.jpg']);

