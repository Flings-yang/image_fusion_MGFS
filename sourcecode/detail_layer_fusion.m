function [fused_detail_layer] = detail_layer_fusion(vi, ir, R,N)
    
      vi_d_denoise = boxfilter(vi, 3)./N;
      ir_d_denoise = boxfilter(ir, 3)./N;
    
%       vi_d_denoise = vi;
%       ir_d_denoise = ir;

     vi_d_fuse_weight = abs(vi_d_denoise)./(abs(vi_d_denoise) + abs(ir_d_denoise));
     ir_d_fuse_weight = abs(ir_d_denoise)./(abs(vi_d_denoise) + abs(ir_d_denoise));

%       vi_d_fuse_weight = vi_map./(vi_map + ir_map);
%       ir_d_fuse_weight = ir_map./(vi_map + ir_map);
    
    
    fused_detail_layer = vi .* vi_d_fuse_weight + ir .* ir_d_fuse_weight;
end