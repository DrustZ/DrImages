function test
     img1 = im2double(imread('Dora.jpg'));
     img2 = im2double(imread('dots.png'));
     h = 400; w = 400;
     n = 6;
     img1 = img1(1:h, 1:w, :);
     img2 = img2(1:h, 1:w, :);
     imgs1 = cell(n, 1);
     imgs2 = cell(n, 1);
     masks1 = cell(n, 1);
     masks2 = cell(n, 1);
     output = cell(n, 1);
     imgs1{1} = img1;
     imgs2{1} = img2;
     mask1 = zeros(h, w, 3);
     mask1(:, 1:w/2-11, :) = 1
     mask1 = bwdist(mask1);
     mask2 = zeros(h, w, 3);
     mask2(:, w/2+10:end, :) = 1
     mask2 = bwdist(mask2);
     masks1{1} = mask1
     masks2{1} = mask2
     
     for i = 2:n
        imgs1{i} = impyramid(imgs1{i-1}, 'reduce');
        imgs2{i} = impyramid(imgs2{i-1}, 'reduce');
        [h,w,t] = size(imgs1{i});
        mask1 = zeros(h, w, 3);
        mask1(:, 1:w/2-1, :) = 1;
        mask1 = bwdist(mask1);
        mask2 = zeros(h, w, 3);
        mask2(:, w/2+1:end, :) = 1;
        mask2 = bwdist(mask2);
        masks1{i} = mask1;
        masks2{i} = mask2;
     end
     for i = 1:n-1
        tmp = impyramid(imgs1{i+1}, 'expand');
        [h1,w1,t] = size(tmp);
        [h2,w2,t] = size(imgs1{i})
        h = min(h1, h2); w = min(w1, w2);
        imgs1{i} = imgs1{i}(1:h, 1:w, :) - tmp(1:h, 1:w, :);
        tmp = impyramid(imgs2{i+1}, 'expand');
        [h1,w1,t] = size(tmp);
        [h2,w2,t] = size(imgs2{i})
        h = min(h1, h2); w = min(w1, w2);
        masks2{i} = masks2{i}(1:h, 1:w, :);
        masks1{i} = masks1{i}(1:h, 1:w, :);
        imgs2{i} = imgs2{i}(1:h, 1:w, :) - tmp(1:h, 1:w, :);
        output{i} = imgs1{i}.* masks2{i} ./ (masks1{i} + masks2{i}) ...
                  + imgs2{i}.* masks1{i} ./ (masks1{i} + masks2{i})
     end
     output{n} = imgs1{n}.* masks2{n} ./ (masks1{n} + masks2{n}) ...
                  + imgs2{n}.* masks1{n} ./ (masks1{n} + masks2{n});
              
     for i = n-1:-1:1
        tmp = impyramid(output{i+1}, 'expand');
        [h1,w1,t] = size(tmp);
        [h2,w2,t] = size(output{i})
        h = min(h1, h2); w = min(w1, w2);
        output{i} = output{i}(1:h, 1:w, :) + tmp(1:h, 1:w, :);
     end
     imshow(output{1});
end
