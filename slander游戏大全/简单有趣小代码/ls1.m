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
    surf(repmat(X, 1, a), repmat(X', a, 1), ones([a,a]).*n, ones([a,a,3]), 'EdgeAlpha',0, 'FaceAlpha',max(.2, l(n)));
end
zlim([-a/2,a]);
shading flat;
colormap(flip([X, X, X]));
camva(5);
axis off