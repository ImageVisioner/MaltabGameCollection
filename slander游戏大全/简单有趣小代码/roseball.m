function roseball
% author : slandarer
s = @sin; c = @cos; f = @surf;
[x,t] = meshgrid((0:24)./24, (0:.5:575)./575.*20.*pi+4*pi);
p = (pi/2)*exp(-t./(8*pi));
u = 1 - (1 - mod(3.6*t, 2*pi)./pi).^4./2 + s(15*t)/150;
y = 2*(x.^2 - x).^2.*s(p);
r = u.*(x.*s(p) + y.*c(p));
h = u.*(x.*c(p) - y.*s(p)) + .35;
L = [.02 .04 .39; .02 .06 .69; .01 .26 .99; .17 .69 1];
p={'EdgeAlpha',0.05, 'EdgeColor','none', 'FaceColor','interp', 'CData',sH(h,L)};
hold on
x = r.*c(t); y = r.*s(t);
f(x,y,h, p{:})
f(x,y,- h, p{:})
rx = pi - acos(- 1/sqrt(5));
Rx = [1, 0, 0; 0, c(rx), -s(rx); 0, s(rx), c(rx)];
yz = 72*pi/180;
Rz = @(n) [c(yz/n), - s(yz/n), 0; s(yz/n), c(yz/n), 0; 0, 0, 1];
Rz1 = Rz(1); Rz2 = Rz(2);
[U,V,W] = rT(x, y, h, Rx);
for k = 1:5, [U,V,W] = rT(U, V, W, Rz1); f(U, V, W, p{:}), end
[U,V,W] = rT(U, V, W, Rz2);
for k = 1:5, [U,V,W] = rT(U, V, W, Rz1); f(U, V, - W, p{:}), end
axis equal off
view(11, -.07)
    function c = sH(H, cL)
        X = rescale(H, 0, 1);
        c = interp1(rescale(1:size(cL,1), 0, 1), cL, X);
    end
    function [U,V,W] = rT(X, Y, Z, R)
        U = X; V = Y; W = Z;
        for i = 1:numel(X)
            v = [X(i); Y(i); Z(i)];
            n = R*v; U(i) = n(1); V(i) = n(2); W(i) = n(3);
        end
    end
end