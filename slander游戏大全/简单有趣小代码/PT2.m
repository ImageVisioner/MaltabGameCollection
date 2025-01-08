E = F([0,1], 13);
fill(real(E),imag(E),imag(E), 'EdgeColor','none');
hold on; axis equal off
colormap(cool)
function V = F(p, n)
T = 36;
V = [];
if n > 0
    Z = p + 1i*diff(p)*[1; 1 + cosd(T)*cosd(T-90) + cosd(T)*sind(T-90)*1i];
    V = [p(1); F(Z(1:2), n - 1); F(Z(2:3), n - 1); p(2)];
end
end