% author : slandarer
% remixed from Daniel Pereira / Ghost Pentagon Flower
T = linspace(0, 360, 6).';
I = 20:-1:1;
fill(I.*sind(T + 18.*I), I.*cosd(T + 18.*I), I, 'edgecolor','none')
colormap(bone); axis equal off; set(gcf, 'color','w');