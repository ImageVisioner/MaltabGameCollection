function Iris
% 灵感来自 Oliver Brotherhood 的 Processing 作品 Iris
% 由 slandarer 使用 MATLAB 进行复刻
% 生成连续随机角度
randList  = (rand(30,3) - .5).*2.*3.15;
thetaList = interp1(linspace(1, 3000, 30), randList, 1:3000, 'makima').';
% 渐变颜色
% #046380, #16193B, #35478C, #4E7AC7, #7FB2F0, #ADD5F7
CList = [4 99 128; 22 25 59; 53 71 140; 78 122 199; 127 178 240; 173 213 247]./255;
CList = interp1(linspace(1, 3000, size(CList, 1)), CList, 1:3000, 'linear');
% 坐标区域修饰
hold on; axis tight equal off
% 随机椭圆半径
A = rand(2,1); B = rand(2,1);
for i = 1:3000
    X = [0; A.*cos(thetaList([1,2],i)); cos(thetaList(3,i))];
    Y = [0; B.*sin(thetaList([1,2],i)); sin(thetaList(3,i))];
    coe2 = ((linspace(0, 1, 100)).^((0:3)')).*((1 - linspace(0, 1, 100)).^((3:-1:0)'));
    bezierPnts = ([1,3,3,1].*coe2.') * [X,Y];
    plot(bezierPnts(:,1),bezierPnts(:,2), 'Color',[CList(i,:), .2], 'LineWidth',.5)
    % pause(.01)
end
end