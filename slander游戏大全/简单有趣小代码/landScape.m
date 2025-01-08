% @author:slandarer
% 计算基础数据
a = 800; b = 600;
d = (.5:a)'/a;
s = (-cos(d*2*pi) + 1).^.2;
f = d-.5; r = f'.^2 + f.^2;
% 坐标区域修饰
hold on
axis([0,a,0,b]);
set(gca, 'XTick',[], 'YTick',[], 'DataAspectRatio',[1,1,1], 'Color',[.67,.7,.9])
% 绘制渐变背景
[X,Y] = meshgrid(1:a, 301:b);
V = repmat(linspace(1, 0, 300)', [1,a]);
t = [0,1]; I = @interp1;
V = cat(3, I(t, [.25,.68], V), I(t, [1/3,.7], V),I(t, [.5,.9], V));
surf(X,Y,X.*0, 'CData',V, 'EdgeColor','none');
% 绘制云彩
P = abs(ifftn(exp(3i*rand(a))./r.^.8)).*(s*s');
C = zeros([a,a,3]);
C(:,:,1) = 1; C(:,:,2) = .75; C(:,:,3) = .88;
y = (1:a)./a.*.8 + .2;
image([0,a], [400,b], C, 'AlphaData',P.*(y'));
% 绘制8座山
c1 = [230,25,90]; c2 = [210,70,10];
for i = 1:8
    H = abs(ifftn(exp(5i*rand(a))./r.^1.05)).*(s*s').*10;
    nh = (8-i)*30 + H(400,:);
    hm = ceil(max(nh));
    C = zeros([hm,a,3]);
    tc = c1 + (c2 - c1)./8.*i;
    tc = hsv2rgb(tc./[360,100,100]);
    C(:,:,1) = tc(1); C(:,:,2) = tc(2); C(:,:,3) = tc(3);
    P = ones(hm,a);
    P((1:hm)' > nh) = nan;
    image([-50,850], [0,hm], C, 'AlphaData',P.*.98);
end