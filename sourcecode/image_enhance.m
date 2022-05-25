function enhance_img = image_enhance(src_img,enhance_map)
    R = 10;
    W = 20;
    [w,h] = size(src_img);
    enhance_temp = src_img(1:floor(w/R)*R,1:floor(h/R)*R);
    for i = 1:floor(w/R)
        for j = 1:floor(h/R)
            if((i-1)*R+W>w || (j-1)*R+W>h)
                continue;
            else
                local_map = enhance_map((i-1)*R+1:(i-1)*R+W,(j-1)*R+1:(j-1)*R+W);
                local_mean = mean(local_map(:));
                if(local_mean<=0.5)
                    enhance_temp((i-1)*R+1:(i-1)*R+W,(j-1)*R+1:(j-1)*R+W) =(uint8(enhance_temp((i-1)*R+1:(i-1)*R+W,(j-1)*R+1:(j-1)*R+W))+ histeq(uint8(src_img((i-1)*R+1:(i-1)*R+W,(j-1)*R+1:(j-1)*R+W))))/2;
                else
                    enhance_temp((i-1)*R+1:(i-1)*R+W,(j-1)*R+1:(j-1)*R+W) = src_img((i-1)*R+1:(i-1)*R+W,(j-1)*R+1:(j-1)*R+W);
                end
            end
        end
    end
    
   src_img(1:floor(w/R)*R,1:floor(h/R)*R) = enhance_temp;
   enhance_img = uint8(src_img);
    

end