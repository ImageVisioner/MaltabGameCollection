% 原代码出自：Sebastian Kraemer
% 注释改编自：slandarer
hold on;
% 绘制背景
C = [123,159,190;228,214,200]./255;
CN = size(C,1);
CM = linspace(1,0,100).'*ones(1,100);
M(:,:,1) = interp1(linspace(0,1,CN),C(:,1),CM);
M(:,:,2) = interp1(linspace(0,1,CN),C(:,2),CM);
M(:,:,3) = interp1(linspace(0,1,CN),C(:,3),CM);
image([.5,14],[3.2,13],M)

E = F([0,1]);
% 绘制山
fill([-6,7,10,12,15,28],[.2,5.5,7.8,7.8,5.5,.2],[.2,5.5,7.8,7.8,5.5,.2], 'EdgeColor','none');
% 绘制树
fill(real(E),imag(E),2, 'EdgeColor','none');
scatter(real(E),imag(E),30,'CData',[1,.7,.7],'Marker','h','MarkerEdgeAlpha',.05);

colormap bone;
axis off;
axis([.5,14,0,13])

function V = F(p)
V = [];
if abs(diff(p)) > 8e-3
    % ^  C____D
    % | /\   /
    % |/  \ /
    % A----B
    % |    |
    % |    |
    % 0----1
    % 假设0，1节点为原节点，则乘虚数i是为了得到与01向量方向垂直的向量
    % 原始节点再加上该向量便得到A,B节点，
    % 后面的1i^cos(...)^.5是为了得到C,D节点
    % cos(...)的范围为[-1, 1], ^cos(...)是为了将1i旋转至[-pi, pi]范围，
    % 再^.5将其旋转范围调整至[-pi/2, pi/2]范围，-1i再在前面乘i*diff(p)
    % 就能接下来生成C,D，并且在向量的右半边方向
    % 这样就能看似随机，实则依靠norm(p)对左右两个树枝的宽度和角度进行调整  
    Z = p + .5i*diff(p)*[4; 4 - 1i + 1i^cos(283*norm(p))^.5];
    % 使用平行四边形的AC边和CB边作为原节点再进行递归，使树进行分叉
    V = [p(1); F(Z(1:2)); F(Z(2:3)); p(2)];     
end
end
