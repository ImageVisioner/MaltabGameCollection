% bird 1
K = 1:9830;
t = linspace(0,2*pi,200);

X = @(k) (sin(pi.*k./2e4)).^12.*(cos(31.*pi.*k./1e4).^16.*sin(6.*pi.*k./1e4)./2+sin(31.*pi.*k./1e4).^20./6)...
        +3.*k./2e4+cos(31.*pi.*k./1e4).^6.*sin(pi./2.*(k./1e4-1).^7-pi./5);
Y = @(k) -9./4.*cos(31.*pi.*k./1e4).^6.*cos(pi./2.*(k./1e4-1).^7-pi./5).*(2./3+(sin(pi.*k./2e4).*sin(3.*pi.*k./2e4)).^6)...
        +3./4.*cos(3.*pi.*(k-1e4)./1e5).^10.*cos(9.*pi.*(k-1e4)./1e5).^10.*cos(36.*pi.*(k-1e4)./1e5).^14+7./10.*((k-1e4)./1e4).^2;
R = @(k) sin(pi.*k./2e4).^10.*(1./4.*cos(31.*pi.*k./1e4+25.*pi./32).^20+1./20.*cos(31.*pi.*k./1e4).^2)+1./30.*(3./2-cos(62.*pi.*k./1e4).^2);

CX = [X(K') + cos(t).*R(K'), K'.*nan]';
CY = [Y(K') + sin(t).*R(K'), K'.*nan]';
plot(CX(:),CY(:), 'Color',[0,0,0,.2]);
set(gca, 'DataAspectRatio',[1,1,1], 'XColor','none', 'YColor','none');

