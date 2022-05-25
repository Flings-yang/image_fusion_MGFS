
function img = run_MGFS(imgVI, imgIR, visualization)
     % IR image
     I1 = double(imread(imgIR.img));

     % VI image
     I2 = double(imread(imgVI.img));

     if visualization == 1
        figure, imshow((uint8(I1)));
        figure, imshow(uint8(I2));
     end
     
     tic;
     if size(I2, 3) == 1
         fuseimage = MGFS(I1, I2);
     elseif size(I1,3) == 1
         fuseimage = zeros(size(I2));
         for i=1:3
            fuseimage(:,:,i) = MGFS(I1,I2(:,:,i));    
         end       
     else
         fuseimage = zeros(size(I2));
         for i=1:3
            fuseimage(:,:,i) = MGFS(I1(:,:,i),I2(:,:,i));    
         end    
     end
     toc;   

     if visualization == 1
         figure, imshow((fuseimage), [])
     end

     img = uint8(fuseimage);
end

function enhance_fused_img = MGFS(IR_image,VIS_image)

% IR_image = double((imread("./dataset/11ir.bmp")));
% VIS_image = double((imread("./dataset/11vis.bmp")));
[w,h] = size(IR_image);
R = 9;
eps = 1000;
S = 1;
sigma = 7;
M = 7;

N = boxfilter(ones([w,h]), R);
%image decomposition
%source image decomposition
vi_b = fastguidedfilter(IR_image,VIS_image,R,eps,S);
vi_d = VIS_image - vi_b;
ir_b = fastguidedfilter(VIS_image,IR_image ,R ,eps ,S);
ir_d = IR_image - ir_b;
%base layer decomposition
[vi_sal,ir_sal] = sal_layer_decomposition(vi_b,ir_b,R,N);
vi_bg = vi_b - vi_sal;
ir_bg = ir_b - ir_sal;


%image fusion
%detail layer fusion
fused_detail_layer = detail_layer_fusion(vi_d,ir_d,R,N);

%saliency layer fusion
[vi_sal_weight,ir_sal_weight] = sal_layer_fusion_weight_1(vi_sal,ir_sal,N,eps,S,sigma,M);
fused_sal_layer = vi_sal .* vi_sal_weight + ir_sal .* ir_sal_weight;
%background layer fusion
fused_bg_layer = (1/2).*(vi_bg + ir_bg);

fused_img = fused_sal_layer  + fused_detail_layer + fused_bg_layer;

%image enhance
belta = 3;
fused_base_layer = fastguidedfilter(fused_img,fused_img,7,eps,S);
fused_detail_layer = fused_img - fused_base_layer;

enhance_fused_img = fused_detail_layer*belta + fused_base_layer;

end