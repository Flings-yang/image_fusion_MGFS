function [vi_sal,ir_sal] = sal_layer_decomposition(vi_b,ir_b,R,N)
    
    [w,h] = size(vi_b);
    vi_b_mean = boxfilter(vi_b,R)./N;
    vi_var = ones(w,h);
    vi_b_mean_all = mean(vi_b(:));
    for i = 1:w
        for j = 1:h
            vi_var(i,j) = abs( vi_b_mean_all - vi_b_mean(i,j));
        end
    end

    ir_b_mean = boxfilter(ir_b,R)./N;
    ir_var = ones(w,h);
    ir_b_mean_all = mean(ir_b(:));
    for i = 1:w
        for j = 1:h
            ir_var(i,j) = abs( ir_b_mean_all - ir_b_mean(i,j));
        end
    end

    vi_var_norm = (vi_var - min(vi_var))./(max(vi_var) - min(vi_var));
    ir_var_norm = (ir_var - min(ir_var))./(max(ir_var) - min(ir_var));

    vi_sal = vi_b .* vi_var_norm;
    ir_sal = ir_b .* ir_var_norm;
    
end