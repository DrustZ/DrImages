function tmpoff = alignsingle1(img,B)
% This function is to align img to B using single-scale algorithms
% Output is the aligned version of img
	[h,w] = size(B);
    [h1,w1] = size(img);
	% Initialize variables
	minMetric = inf; % minimum metric value
	minVector = zeros(2,1); % best shift vector by far
	        
    if max(h,w) >= 1000
        offset = 1;
    else 
        offset = 5;
    end
     for r_s = -offset : offset
         for c_s = -offset : offset
             s_row1 = 1; e_row1 = h; s_col1 = 1; e_col1 = w;
             s_row2 = 1; e_row2 = h1; s_col2 = 1; e_col2 = w1;
             if (r_s < 0) 
                 s_row1 = 1 - r_s;
                 e_row2 = 1 + h - s_row1;
             else 
                 s_row2 = 1 + r_s;
                 e_row1 = 1 + h1 - s_row2;
             end 
             if (c_s < 0)
                 s_col1 = 1 - c_s;
                 e_col2 = 1 + w - s_col1;
             else 
                 s_col2 = 1 + c_s;
                 e_col1 = 1 + w1 - s_col2;
             end
             
             if (e_row1 > h)
                 e_row1 = h;
                 e_row2 = s_row2 + h - s_row1;
             end
             if (e_row2 > h1) 
                 e_row2 = h1;
                 e_row1 = s_row1 + h1 - s_row2;
             end
             if (e_col1 > w)
                 e_col1 = w;
                 e_col2 = s_col2 + w - s_col1;
             end
             if (e_col2 > w1)
                 e_col2 = w1;
                 e_col1 = s_col1 + w1 - s_col2;
             end
             i1 = B(s_row1:e_row1, s_col1:e_col1);
             i2 = img(s_row2:e_row2, s_col2:e_col2);
             ssd = sum(sum((i1 - i2).^2))/numel(i1);
             if (ssd < minMetric)
                minVector = [r_s, c_s];
                minMetric = ssd;
             end
         end
     end
    
	% Output aimg
    tmpoff = minVector;
end


