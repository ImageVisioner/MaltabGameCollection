% bird 2
K = -2e4:2e4;
t = linspace(0,2*pi,200);

X = @(k) k./15e3+sin(17.*pi./20.*(k./2e4).^5).*cos(41.*pi.*k./2e4).^6+...
        (1./3.*cos(41.*pi.*k./2e4).^16+1./3.*cos(41.*pi.*k./2e4).^80).*cos(pi.*k./4e4).^12.*sin(6.*pi.*k./2e4);
Y = @(k) 1./2.*(k./2e4).^4-cos(17.*pi./20.*(k./2e4).^5).*(11./10+45./20.*cos(pi.*k./4e4).^8.*cos(3.*pi.*k./4e4).^6).*cos(41.*pi.*k./2e4).^6+...
        12./20.*cos(3.*pi.*k./2e5).^10.*cos(9.*pi.*k./2e5).^10.*cos(8.*pi.*k./2e5).^10;
R = @(k) 1./50+1./40.*sin(41.*pi.*k./2e4).^2.*sin(9.*pi.*k./2e5).^2+1./17.*cos(41.*pi.*k./2e4).^2.*cos(pi.*k./4e4).^10;

CX = [X(K') + cos(t).*R(K'), K'.*nan]';
CY = [Y(K') + sin(t).*R(K'), K'.*nan]';
plot(CX(:),CY(:), 'Color',[0,0,0,.2]);
set(gca, 'DataAspectRatio',[1,1,1], 'XColor','none', 'YColor','none');
