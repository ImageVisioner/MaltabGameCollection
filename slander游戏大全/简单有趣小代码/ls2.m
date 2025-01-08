% 原代码出自：Tim
% 注释改编自：slandarer
clc; clear; close all;
a = 200;
X = (.5:a)'./a;
CL = (- cos(X.*2.*pi) + 1).^.2;
r = repmat((X - .5)'.^2, a, 1) + repmat((X - .5).^2, 1, a);
Z = abs(ifftn(exp(7i.*rand([a,a]))./r.^.9)).*(CL*CL').*30;
% 画山
surf(repmat(X, 1, a), repmat(X', a, 1), Z);
m = 50;
l = (m:-1:1)./m;
% 绘制云彩
hold on
for n = 1:m
    surf(repmat(X, 1, a), repmat(X', a, 1), ones([a,a]).*n, ones([a,a,3]), 'EdgeAlpha',0, 'FaceAlpha',max(.2, l(n))./2);
end
zlim([-a/2,a]);
shading flat;
CList = [140,116,78; 171,135,87; 187,170,101; 162,181,117; 95,175,146; 
         79,183,160; 72,162,163; 44,132,152; 36,116,141; 65,64,123; 40,26,44]./255;
CList = interp1(1:size(CList, 1), CList, linspace(1, size(CList, 1), 100));
colormap(CList);
camva(5);
axis off