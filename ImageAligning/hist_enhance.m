function img = hist_enhance(ori)
    lab = rgb2gray(ori)
    [count, bin] = imhist(lab, 255);
    [h, w] = size(ori);
    startv = h*w*0.02;
    sum = 0;
    idx = 0;
    p5 = 0; p95 = 1;
    for i = 1:size(count)
       sum = sum + count(i)
       if sum >= startv
           idx = i;
           break
       end
    end
    p5 = bin(idx);
    
    sum = 0
    for i = size(count):-1:1
        sum = sum + count(i)
        if sum >= startv
            idx = i;
            break
        end
    end
    p95 = bin(idx);
    a = 1 / (p95 - p5);
    b = -a * p5;
    img = arrayfun( @(x) a*x+b, ori);
    img = imsharpen(img);
end