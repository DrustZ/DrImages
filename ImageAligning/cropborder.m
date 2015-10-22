function offset = cropborder(img) 
    gray = img;
    gray = rgb2gray(gray);
    
    fl = fspecial('gaussian', [3,3], 1.5); % change if you need
    scaleimg = imfilter(gray,fl);
    scaleimg = scaleimg(2:2:end, 2:2:end);
    [hh, ww] = size(scaleimg);
    times = 1;
    while(max(hh, ww) > 1000) 
%        scaleimg = imfilter(scaleimg,fl);
       scaleimg = scaleimg(2:2:end, 2:2:end);
       [hh, ww] = size(scaleimg);
       times = times + 1;
   end
   count = 1;
   xstart = 1; ystart = 1; xend = hh; yend = ww;
     for row = 1:hh/10
        av = std(scaleimg(row,:)); 
        if (av < 0.15) 
            xstart = row; 
            count = 0;
        elseif count > 2
            break; 
        else count = count + 1;
        end
     end
     count = 1;
%      disp('ha');
     for row = hh:-1:hh*0.9
        av = std(scaleimg(row,:));
%         disp(av);
        if (av < 0.15) 
            xend = row;
            count = 0;
        elseif count > 2
            break; 
        else count = count + 1;
        end
     end
     count = 1;
%      disp('ha');
     for col = 1:ww/10
        av = std(scaleimg(:,col));
%         disp(av);
        if (av < 0.15) 
            ystart = col; 
            count = 0;
        elseif count > 2
            break;
        else count = count + 1;
        end
     end
%      disp('ha');
     count = 1;
     for col = ww:-1:ww*0.9
        av = std(scaleimg(:,col));
%         disp(av);
        if (av < 0.15)
            yend = col; 
            count = 0;
        elseif count > 2
            break; 
        else count = count + 1;
        end
     end
 
%          count = 0;
%      for row = 1:hh/15
%          av = mean(scaleimg(row,:));
%          for col = 1:ww
%              if abs(scaleimg(row,col) - av) >= av*0.3
%                  count = count + 1;
%              end
%          end
%          if count > 0.2*hh
%              break
%          else 
%              xstart = row;
%          end
%      end
%      count = 0;
%      for row = hh:-1:hh/15*14
%          av = mean(scaleimg(row,:));
%          for col = 1:ww
%              if abs(scaleimg(row,col) - av) >= av*0.3 
%                  count = count + 1;
%              end
%          end
%          if count > 0.3*ww 
%              break
%          else 
%              xend = row;
%          end
%      end
%      count = 0;
%      for col = 1:ww/15
%          av = mean(scaleimg(:,col));
%          
%          for row = 1:hh
%              if abs(scaleimg(row,col) - av) >= av*0.3 
%                  count = count + 1;
%              end
%          end
%          if count > 0.3*hh 
%              break;
%          else 
%              ystart = col;
%          end
%      end
%      count = 0;
%      for col = ww:-1:ww/15*14
%          av = mean(scaleimg(:,col));
%          for row = 1:hh
%              if abs(scaleimg(row,col) - av) >= av*0.3 
%                  count = count + 1;
%              end
%          end
%          if count > 0.3*hh 
%              break
%          else 
%              yend = col;
%          end
%      end
    xend = xend*2.^times;
    xstart = xstart*2.^times;
    yend = yend*2.^times;
    ystart = ystart*2.^times;
    offset = [xstart, xend, ystart, yend];
%     disp(offset);
end