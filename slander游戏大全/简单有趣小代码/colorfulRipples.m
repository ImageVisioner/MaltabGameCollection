% author : slandarer
hold on; axis tight equal
XY = rand(200,2).*[2,1.2];
n = 100; s = 2^n;
r = randi(size(XY,1), n, 1);
for j = 1:n
    scatter(XY(r,1),XY(r,2), s/2^(j-1), jet(n), 'filled', 'MarkerFaceAlpha',.2);
end
camva(3)
