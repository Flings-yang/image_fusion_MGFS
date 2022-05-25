function [vi_sal_weight,ir_sal_weight] = sal_layer_fusion_weight_1(vi_sal,ir_sal,N,eps,S,sigma,M)
    [w,h] = size(vi_sal);
    alpha = 0.8;

    vi_bright_flag = mean(vi_sal(:));
    ir_bright_flag = mean(ir_sal(:));

    vi_sal_mean = boxfilter(vi_sal,sigma)./N;
    ir_sal_mean = boxfilter(ir_sal,sigma)./N;

    vi_sal_map = ones([w,h]);
    ir_sal_map = ones([w,h]);
    for i = 1:w
        for j = 1:h
            if ( vi_sal_mean(i,j) >=vi_bright_flag)
                vi_sal_map(i,j) = ir_sal(i,j);
                ir_sal_map(i,j) = vi_sal(i,j);
            elseif(ir_sal_mean(i,j)>= ir_bright_flag && (vi_sal_mean(i,j) >=vi_bright_flag))
                vi_sal_map(i,j) = ((ir_sal(i,j) + vi_sal(i,j))*(1-alpha));
                ir_sal_map(i,j) = ((ir_sal(i,j) + vi_sal(i,j))*alpha);
            else
                vi_sal_map(i,j) = vi_sal(i,j);
                ir_sal_map(i,j) = ir_sal(i,j);
            end
        end
    end

%     vi_sal_map = fastguidedfilter(ir_sal_map,vi_sal_map,M,eps,S);
%     ir_sal_map = fastguidedfilter(vi_sal_map,ir_sal_map,M,eps,S);
    vi_sal_map = boxfilter(vi_sal_map,9)./N;
    ir_sal_map = boxfilter(ir_sal_map,9)./N;
    vi_sal_weight = abs(vi_sal_map)./(abs(vi_sal_map) + abs(ir_sal_map));
    ir_sal_weight = abs(ir_sal_map)./(abs(vi_sal_map) + abs(ir_sal_map));

end