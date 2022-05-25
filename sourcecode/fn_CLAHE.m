function output=fn_CLAHE(img)
%% First pass: Count equal pixels
t=1;                                   % start index of the window (row)
limit=4;                               % window size of the contextual area
endt=limit;                            % end index of the window (row)
eqimg=zeros(size(img,1),size(img,2));
for x=1:size(img,1)
    q=1;                                % start index of the window (column)
    endq=limit;                         % end index of the window (column)
    %% TO move Window to right and bottom, after exceeding the limit 
    for y=1:size(img,2)
        eqimg(x,y)=0;
        if (x>t+limit-1)
            t=t+limit;
            endt=limit+t-1;
        end
        if (y>q+limit-1)
            q=q+limit;
            endq=limit+q-1;
        end
        if (endt>size(img,1))
            % t=t-64;
            endt=size(img,1);
        end
        if (endq>size(img,2))
            %  q=q-64;
            endq=size(img,2);
        end
    %% Counting the number of pixels in each contextual area    
        for i=t:endt
            for j=q:endq
                
                if img(x,y)==img(i,j)
                    eqimg(x,y)=eqimg(x,y)+1;
                end
                
            end
        end
        
        
    end
end

%% Second Pass: Calculate partial rank, redistributed area and output values.

output=zeros(size(img,1),size(img,2));
cliplimit=0.3;                                  % Cliplimit can vary between 0 to 1.
t=1;
endt=limit;
for x=1:size(img,1)
    q=1;
    endq=limit;
    %% TO move Window to right and bottom, after exceeding the limit
    for y=1:size(img,2)
        
        cliptotal=0;
        partialrank=0;
        if (x>t+limit-1)
            t=t+limit;
            endt=limit+t-1;
        end
        if (y>q+limit-1)
            q=q+limit;
            endq=limit+q-1;
        end
        if (endt>size(img,1))
            % t=t-64;
            endt=size(img,1);
        end
        if (endq>size(img,2))
            % q=q-64;
            endq=size(img,2);
        end
        
        %% For each pixel (x,y), compare with cliplimit and accordingly do the clipping. Calculate partialrank. 
        for i=t:endt
            for j=q:endq
                
                
                if eqimg(i,j)>cliplimit
                    
                    incr=cliplimit/eqimg(i,j);
                else
                    incr=1;
                    
                end
                cliptotal=cliptotal+(1-incr);
                
                if img(x,y)>img(i,j)
                    partialrank=partialrank+incr;
                    
                end
                
            end
            
        end
        %% New distributed pixel values can be found from redistr and will be incremented by partial rank.
        
        redistr=(cliptotal/(limit*limit)).*img(x,y);
        output(x,y)=partialrank+redistr;
        
    end
end
% figure('name','ASHWINI SINGH','NumberTitle','off')
% %da=adapthisteq(img);
% imshow([img uint8(output)]);          % Concatenate original and CLAHE image


end