% author : slandarer
hold on; grid on
axis([-22,22, -20,20, -10,10])
axis off
s = pi/8; t = [0:.2:s, s:.02:pi-s, pi-s:.2:pi+s, pi+s:.02:2*pi-s, 2*pi-s:.2:2*pi];
x = 16*sin(t).^3;
y = 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t);
lW = 'LineWidth';
plot3(x,y,x.*0, 'Color',[186,110,64]./255, lW,1)
set(gca, 'DataAspectRatio',[1,1,1])
for i = 1:length(t)
    for j = 1:6
        L = rand(1)*2.5 + 1.5;
        A = rand(1,3) - .5;
        A = A./norm(A);
        B = [x(i), y(i), 0];
        C = [A(3), A(3), -A(1)-A(2)];
        P0 = [.8.*A.*L + B + C./norm(C).*.14.*L, 1]';
        a = B(1); b = B(2); c = 0; u = A(1); v = A(2); w = A(3);
        for k = 1:4
            o = k*pi/2; co = cos(o); so = sin(o); cn = 1 - co;
            RM = [u^2 + (v^2 + w^2)*co, u*v*cn - w*so, u*w*cn + v*so, (a*(v^2 + w^2) - u*(b*v + c*w))*cn + (b*w - c*v)*so;
                  u*v*cn + w*so, v^2 + (u^2 + w^2)*co, v*w*cn - u*so, (b*(u^2 + w^2) - v*(a*u + c*w))*cn + (c*u - a*w)*so;
                  u*w*cn - v*so, v*w*cn + u*so, w^2 + (u^2 + v^2)*co, (c*(u^2 + v^2) - w*(a*u + b*v))*cn + (a*v - b*u)*so];
            P(:,k) = RM*P0;
        end
        F = [1,3,4; 1,4,5; 1,5,6; 1,6,3; 2,3,4; 2,4,5; 2,5,6; 2,6,3];
        patch('Faces',F, 'Vertices',[B;B + A.*L; P'], 'FaceColor',[0,71,177]./255,...
            'FaceAlpha',.2, 'EdgeColor',[0,63,159]./255,...
            'EdgeAlpha',.25, lW,.01)
    end
end