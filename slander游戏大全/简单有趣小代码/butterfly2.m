% butterfly 2
K = 1:4e4;
t = linspace(0, 2*pi, 200);

X = @(k) 6./5.*cos(141.*pi.*k./4e4).^9.*(1-1./2.*sin(pi.*k./4e4).^3).*(1-1./4.*cos(2.*pi.*k./4e4).^30.*(1+2./3.*cos(30.*pi.*k./4e4).^20)-...
        sin(2.*pi.*k./4e4).^10.*sin(6.*pi.*k./4e4).^10.*(1./5+4./5.*cos(24.*pi.*k./4e4).^20));
Y = @(k) cos(2.*pi.*k./4e4).*cos(141.*pi.*k./4e4).^2.*(1+1./4.*cos(pi.*k./4e4).^24.*cos(3.*pi.*k./4e4).^24.*cos(19.*pi.*k./4e4).^24);
R = @(k) 1./100+1./40.*(cos(2820.*pi.*k./4e4).^6+sin(141.*pi.*k./4e4).^2).*(1-cos(pi.*k./4e4).^16.*cos(3.*pi.*k./4e4).^16.*cos(12.*pi.*k./4e4).^16);

CX = [X(K') + cos(t).*R(K'), K'.*nan]';
CY = [Y(K') + sin(t).*R(K'), K'.*nan]';
plot(CX(:),CY(:), 'Color',[0,0,0,.2]);
set(gca, 'DataAspectRatio',[1,1,1], 'XColor','none', 'YColor','none');