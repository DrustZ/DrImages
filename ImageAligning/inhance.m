function img = inhance(ori)
    lms = ori;
    [h, w, c] = size(lms);
    rgb_to_lms = [17.8824, 43.5161, 4.1193; 
                  3.4557 , 27.1554, 3.8671;
                  0.02996, 0.18431, 1.4700];
    lms_to_rgb = [0.0809 , -0.1305, 0.1167;
                  -0.0102, 0.0540 , -0.1136;
                  -0.0003, -0.0041, 0.6935];
    for i = 1:h
        for j = 1:w
            lms(i,j,:) = rgb_to_lms * squeeze(ori(i,j,:));
        end
    end
    max_l = max(max(lms(:,:,1)));
    max_m = max(max(lms(:,:,2)));
    max_s = max(max(lms(:,:,3)));
    enhance = eye(3,3);
    enhance(1,1) = 66 / max_l;
    enhance(2,2) = 35 / max_m;
    enhance(3,3) = 2 / max_s;
    disp(enhance);
    for i = 1:h
        for j = 1:w
            lms(i,j,:) = enhance * squeeze(lms(i,j,:));
        end
    end
    
    for i = 1:h
        for j = 1:w
            lms(i,j,:) = lms_to_rgb * squeeze(lms(i,j,:));
        end
    end
    img = lms;
end 