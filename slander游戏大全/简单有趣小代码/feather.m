% author : slandarer
% remixed from Juan Villacrés / Flower R-D
figure('Color','k', 'Renderer','painters', 'InvertHardCopy', 'off')
hold on
t = linspace(-3, 3, 1000);
x = 7*sin(7.32*t)./(1 + cos(1.42*t).^2);
y = 7*cos(1.42*t).*sin(7.32*t).^4;
for i = 0:pi/3:2*pi
    m = [cos(i) -sin(i); sin(i) cos(i)]*([x; y]);
    patch([m(1,:), NaN], [m(2,:), NaN], - [sqrt(m(1,:).^2+m(2,:).^2), NaN],...
        'EdgeColor','interp', 'Marker','none', 'MarkerFaceColor','flat', 'LineWidth',1)
end
axis equal off
colormap(bone)