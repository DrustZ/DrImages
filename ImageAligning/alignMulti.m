function [xoff, yoff, aimg] = alignMulti(img,B)
% This function is to align img to B using multi-scale algorithms
% Output is the aligned version of img
    
	[h,w] = size(B);
	% Build Image Pyramid for img & B
	pyramid_scale = 2;
	pyramid_levels = floor(log2(min(h,w)) - log2(16)) + 1; % choose your value
	gaussianf = fspecial('gaussian', [5,5], 1.5); % change if you need
	
	imgs = cell(pyramid_levels,1);
	imgs{1} = img;
	Bs = cell(pyramid_levels,1);
	Bs{1} = B;
    
	for ilevel = 2:1:pyramid_levels
		tmpB = imfilter(Bs{ilevel-1},gaussianf);
        tmpimg = imfilter(imgs{ilevel-1},gaussianf);
        %unsharp mask
        tmpB = imsharpen(tmpB, 'Radius', 2);
        tmpimg = imsharpen(tmpimg);
        
        Bs{ilevel} = tmpB(2:2:end, 2:2:end);
        imgs{ilevel} = tmpimg(2:2:end, 2:2:end);
        
    end
    
    xoff = 0;
    yoff = 0;
	%Match using Image Pyramids
	for ilevel = pyramid_levels:-1:1
        [h0, w0] = size(Bs{ilevel});
        xoff = xoff * 2; yoff = yoff * 2;
        startx0 = 1; endx0 = h0; starty0 = 1; endy0 = w0;
        startx1 = 1; endx1 = h0; starty1 = 1; endy1 = w0;
        if (xoff < 0) startx1 = 1-xoff; endx0 = h0 + xoff; end;
        if (yoff < 0) starty1 = 1-yoff; endy0 = w0 + yoff; end; 
        if (xoff > 0) startx0 = xoff+1; endx1 = h0 - xoff; end;
        if (yoff > 0) starty0 = yoff+1; endy1 = w0 - yoff; end;
        tmp1 = Bs{ilevel}(startx0:endx0, starty0:endy0);
        tmp2 = imgs{ilevel}(startx1:endx1, starty1:endy1);
        tmpoff = alignsingle1(tmp1,tmp2);
        xoff = xoff + tmpoff(1);
        yoff = yoff + tmpoff(2);
    end
	
	% Output aimg
	aimg = zeros(h,w);
    startx = 1; starty = 1; endx = h; endy = w; 
    tmpxstart = 1; tmpystart = 1;
    if (xoff > 0) endx = h - xoff; tmpxstart = 1 + xoff; end 
    if (yoff > 0) endy = w - yoff; tmpystart = 1 + yoff; end
    if (xoff < 0) startx = 1 - xoff; end
    if (yoff < 0) starty = 1 - yoff; end
	aimg(tmpxstart:tmpxstart+endx-startx, tmpystart:tmpystart+endy-starty) = img(startx:endx, starty:endy);
   
end
