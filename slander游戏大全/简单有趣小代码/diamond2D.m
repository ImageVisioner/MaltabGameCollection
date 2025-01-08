% author : slandarer
figure('render','painters')
hold on; axis equal; axis([-30,30,-30,30])
CList = [21,97,169; 68,107,178; 169,217,246; 76,177,227; 92,134,195; 55,124,199]./255;
set(gca, 'XColor','none', 'YColor','none', 'Color',[0,64,115]./510)
t = 0:20:360-1;
T = [cosd(t).*7; sind(t).*7; t];
plot([1; 0]*T(1,:), [1; 0]*T(2,:), 'LineWidth',2)
for i = 1:5
    t = T(3,:);
    L = T + [cosd(t - 20)*(7 - i); sind(t - 20)*(7 - i); t*0 - 20];
    R = T + [cosd(t + 20)*(7 - i); sind(t + 20)*(7 - i); t*0 + 20];
    plot([T(1,:); L(1,:)], [T(2,:); L(2,:)], 'LineWidth',2)
    plot([T(1,:); R(1,:)], [T(2,:); R(2,:)], 'LineWidth',2)
    T = [L, R];
end
LHdl = findobj(gca, 'Type','line');
for i = 1:length(LHdl)
    LHdl(i).Color = CList(randi([1,6],[1,1]),:);
end
P = T(1:2,:).';
[k,~] = convhull(P);
plot(P(k,1), P(k,2), 'LineWidth',2, 'Color',CList(1,:))