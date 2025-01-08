% author : slandarer
clc; clear
X = [0, 1, 1, 0];
Y = [0, 0, 1, 1];
MF = @(T) [cos(T), sin(T); -sin(T), cos(T)];
M1 = MF(pi/2); M2 = MF(-pi/2); M3 = MF(pi/2.5);
N = 10; CL = turbo(N);

ax = gca; 
ax.DataAspectRatio = [1,1,1];
ax.NextPlot = 'add';
ax.XColor = 'none';
ax.YColor = 'none';
fill(X,Y, CL(1,:))

for i = 2:N
    XM = X(:,3)./2 + X(:,4)./2; XV = X(:,3)./2 - X(:,4)./2;
    YM = Y(:,3)./2 + Y(:,4)./2; YV = Y(:,3)./2 - Y(:,4)./2;
    XYM = [XV, YV]*M3 + [XM, YM]; 
    XR = [XYM(:,1), X(:,3)]; XL = [X(:,4), XYM(:,1)];
    YR = [XYM(:,2), Y(:,3)]; YL = [Y(:,4), XYM(:,2)];
    XYR3 = [XR(:,1) - XR(:,2), YR(:,1) - YR(:,2)]*M2 + [XR(:,2), YR(:,2)];
    XYR4 = [XR(:,2) - XR(:,1), YR(:,2) - YR(:,1)]*M1 + [XR(:,1), YR(:,1)];
    XYL3 = [XL(:,1) - XL(:,2), YL(:,1) - YL(:,2)]*M2 + [XL(:,2), YL(:,2)];
    XYL4 = [XL(:,2) - XL(:,1), YL(:,2) - YL(:,1)]*M1 + [XL(:,1), YL(:,1)];
    X = [XR, XYR3(:,1), XYR4(:,1); XL, XYL3(:,1), XYL4(:,1)];
    Y = [YR, XYR3(:,2), XYR4(:,2); YL, XYL3(:,2), XYL4(:,2)];
    fill(X.',Y.', CL(i,:))
end