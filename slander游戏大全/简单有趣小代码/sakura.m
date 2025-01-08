% author : slandarer
hold on; axis([-1,5,0,5])
set(gca, 'XColor','none', 'YColor','none', 'Color',[.5,.5,.5])
T=[1.2; 0; pi/2]; a = pi/10;
for i = 1:16
    L = .6*.9^i;
    I = randi(25, [1,size(T,2)]) > 9;
    if i == 1,I = ~1; end
    L1 = T(:,I); t = L1(3,:);
    R1 = L1 + [cos(t - a)*L; sin(t - a)*L; t*0 - a];
    R2 = L1 + [cos(t + a)*L; sin(t + a)*L; t*0 + a];
    L2 = T(:,~I); t = L2(3,:);
    R3 = L2 + [cos(t)*L; sin(t)*L; t*0];
    T = [R1, R2, R3];
    X = [L1(1,:), L1(1,:), L2(1,:); R1(1,:), R2(1,:), R3(1,:)]; X(end+1,:) = nan;
    Y = [L1(2,:), L1(2,:), L2(2,:); R1(2,:), R2(2,:), R3(2,:)]; Y(end+1,:) = nan;
    plot(X(:), Y(:), 'Color',[0 0 0] + i*.3/16, 'LineWidth',5*0.8^i)
    if i > 14
        scatter(T(1,:),T(2,:), i*2-20, 'CData',[.86,.68,.68]/(1 - .13*(i - 15)));
    end
end