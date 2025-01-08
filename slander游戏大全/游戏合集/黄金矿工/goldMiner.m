function goldMiner
% 创建figure窗口
% 去除工具栏、更改窗口名称、禁止更改窗口大小
Mainfig=figure('units','pixels','position',[50 100 750 500],...
                       'Numbertitle','off','menubar','none','resize','off',...
                       'name','goldMiner');

% 创建坐标区域
axes('parent',Mainfig,'position',[0 0 1 1],...
   'XLim', [0 750],...     % X轴范围
   'YLim', [0 500],...     % Y轴范围
   'NextPlot','add',...
   'layer','bottom',...    
   'Visible','on',...
   'YDir','reverse',...    % 因为图片显示和surf绘制曲面方向是相反的，因此调整Y轴方向反向
   'XTick',[], ...         % 隐藏X轴刻度
   'YTick',[]);            % 隐藏Y轴刻度


bkgPic=imread('.\pic\bkg.png');   % 读取背景图片
image([0,750],[0,500],bkgPic)     % 通过image函数显示背景图像

[manPic,~,manAlp]=imread('.\pic\man.png');   % 读取老人的图像及透明度分布
image([400-60,400+60],[49.5-45,49.5+45],manPic,'AlphaData',manAlp) % 显示老人

% 读取爪子
% 因为要不停旋转爪子
% image函数局限性较大而使用surf绘制贴图曲面
% surf函数我们可以让应该透明的位置数值设置为nan，令其透明
[clawPic,~,clawAlp]=imread('.\Pic\claw.png');
clawPic=double(clawPic)./255;
% 获取R，G，B三个通道的图片
clawPicR=clawPic(:,:,1);
clawPicG=clawPic(:,:,2);
clawPicB=clawPic(:,:,3);
% 将R，G，B三个通道的图片透明处分别设置为nan
clawPicR(clawAlp<1)=nan; 
clawPicG(clawAlp<1)=nan;
clawPicB(clawAlp<1)=nan;
% 再拼接回一张图片
clawPic(:,:,1)=clawPicR;
clawPic(:,:,2)=clawPicG;
clawPic(:,:,3)=clawPicB;

clawPos=[380,75];  % 爪子的位置
ropePos=[380,75];  % 绳子末端的位置

% 构造初始网格，原图像比较大，构造1/2大小的网格
[xgrid,ygrid]=meshgrid((1:size(clawAlp,2))./2,(1:size(clawAlp,1))./2);
xgrid=xgrid-size(clawAlp,2)/4;

% 将可旋转角度进行切分，让爪子只能在[-2*pi/5,2*pi/5]角度之间旋转
thetaList=linspace(-2*pi/5,2*pi/5,50);

% 取可旋转角度的第一个值
thetaIndex=1;
theta=thetaList(thetaIndex);
v=0;             % 当前速度为0
dir=1;           % 方向向下
grabbing=false;  % 是否在抓东西状态(后面holdOnType用来判断是否抓住东西，抓住的是啥)

% 计算cos(theta),sin(theta)
cost=cos(theta); 
sint=sin(theta);

% 依据cos(theta),sin(theta)旋转网格
rotateX=cost.*xgrid+sint.*ygrid;
rotateY=cost.*ygrid-sint.*xgrid;

% 构造爪子绘制实例对象(surf函数绘图)
drawClawHdl=surface(rotateX+clawPos(1),rotateY+clawPos(2),...
            zeros(size(clawAlp)),clawPic,...
            'EdgeColor','none');
% 构造绳子绘制实例对象(plot画一根线)
drawLineHdl=plot([clawPos(1),ropePos(1)],[clawPos(2),ropePos(2)],'k','LineWidth',2);
%stone part======================================================
% 石头名称集合
stoneName={'gold','gold','stone1','stone2','diamond','zd'};

% 从pic文件夹读取各个石头的图片及透明度
stonePic{length(stoneName)}=[];
stoneAlp{length(stoneName)}=[];
for i=1:length(stoneName)
    [C,~,Alp]=imread(['.\pic\',stoneName{i},'.png']);
    stonePic{i}=C;
    stoneAlp{i}=Alp;
end
% 各种类型石头的属性
stoneV=[-2,-3,-3,-3,-5];                 % 吊起不同石头后的拖拽速度
stonePrice=[800,500,200,100,1000];       % 各种石头的价格
stoneSize=[50,50;30,30;24,20;15,12;8,8]; % 各种石头的大小

% 要花在图上的7个石头绘制
stonePos=[200,300;400,350;500,200;50,240;50,300;
          700,420;170,180];  % 各种石头的位置
stoneType=[1,2,3,4,5,1,2];   % 各种石头的种类
stoneTag=1:length(stoneType);% 为各个石头打上1，2，3，...的标签用来区分不同石头

% 依据各个石头的大小和位置算出石头所占矩形的位置
stoneXrange=[stonePos(:,1)-stoneSize(stoneType',1),stonePos(:,1)+stoneSize(stoneType',1)];
stoneYrange=[stonePos(:,2)-stoneSize(stoneType',2),stonePos(:,2)+stoneSize(stoneType',2)];

% 循环调用drawStone函数绘制石头
for i=1:length(stoneTag)
    drawStone(stonePos(i,:),stoneType(i),stoneTag(i))   
end

    % 石头绘制函数
    % 使用image函数绘制石头
    % 并为其打上UserData标签(1，2，3，...的标签)
    function drawStone(pos,i,j)
        image([-stoneSize(i,1),stoneSize(i,1)]+pos(1),...
              [-stoneSize(i,2),stoneSize(i,2)]+pos(2),...
              stonePic{i},...
              'AlphaData',stoneAlp{i},...
              'UserData',j)  % 打上UserData标签
    end

holdOnType=0;  % 0即爪子空着，非0值时即表示石头的类型

% 绘制一个完全透明的图像
% 当抓住石头时候，删除原本石头对象
% 并将完全透明的图像换成抓住石头的样子
drawHoldOnHdl=image([0,1],[0,1],ones(1,1),'AlphaData',zeros(1,1));

% 绘制(Money:)文本
text(10,40,'Money:','FontSize',20,'Color',[1 1 1],'FontName','Cambria','FontWeight','bold')
money=0;  % 金钱数量
% 金币字符对象：更改其String属性可以显示不同的金币数
moneyStrHdl=text(110,40,'$0','FontSize',20,'Color',[0.5137 0.7882 0.2157],'FontName','Cambria','FontWeight','bold');

%==========================================================================  
% 当按键盘的时候调用key函数
set(gcf, 'KeyPressFcn', @key)

% 每隔1/20秒运行一遍minergame函数
fps=20;
game=timer('ExecutionMode', 'FixedRate', 'Period',1/fps, 'TimerFcn', @minergame);
start(game)

    % 黄金矿工主函数
    function minergame(~,~)

        % 如果不在抓东西状态，则更改theta角度
        if ~grabbing

            switch 1
                case thetaIndex==1,dir=1;  % 如果爪子偏到最左边，则爪子要往右转动(dir=1)
                case thetaIndex==50,dir=-1;% 如果爪子偏到最右边，则爪子要往右转动(dir=-1)
            end

            % 取可旋转角度的第thetaIndex个值
            thetaIndex=thetaIndex+dir;
            theta=thetaList(thetaIndex);
            % 计算cos(theta),sin(theta)
            cost=cos(theta);
            sint=sin(theta);
            % 依据cos(theta),sin(theta)旋转爪子网格
            rotateX=cost.*xgrid+sint.*ygrid;
            rotateY=cost.*ygrid-sint.*xgrid;
        else % 若是进入抓东西状态
    
            % 角度不变但是绳子伸长或变短
            cost=cos(theta);
            sint=sin(theta);
            % +[sint,cost].*v即爪子位置往theta方向伸长或变短
            clawPos=clawPos+[sint,cost].*v;
            
            % 判断抓取状态
            % n=-1即碰到了边缘,n=0没抓到东西，n=1,2,3,..抓到了stoneTag(n)标签的石头
            n=touchThing(clawPos+5.*[sint,cost]);

            if n==-1 % 如果碰到了边缘
                v=-abs(v); % 则方向反向，即收回爪子
            elseif n>0 % 如果n>0则 抓住了东西

                % 删掉被抓住石头的图像
                delete(findobj('UserData',stoneTag(n)));

                % 依据被抓住石头种类给爪子不同速度
                v=stoneV(stoneType(n));
                % 更新爪子抓住石头类型
                holdOnType=stoneType(n);
                
                % 将被抓住石头的各种数据都删掉
                stonePos(n,:)=[];
                stoneType(n)=[];
                stoneTag(n)=[];
                stoneXrange(n,:)=[];
                stoneYrange(n,:)=[];

                % 依据被抓住石头的类型，将透明图片更改为被抓住石头的样子
                set(drawHoldOnHdl,...
                    'XData',[-stoneSize(holdOnType,1),stoneSize(holdOnType,1)]+clawPos(1)+norm(stoneSize(holdOnType,:))*sint,...
                    'YData',[-stoneSize(holdOnType,2),stoneSize(holdOnType,2)]+clawPos(2)+norm(stoneSize(holdOnType,:))*cost,...
                    'CData',stonePic{holdOnType},'AlphaData',stoneAlp{holdOnType});
            end  
            
            % 如果爪子的y轴坐标大于等于绳子末端y轴坐标
            % 则说明爪子被收回
            if clawPos(2)<=ropePos(2)
                clawPos=ropePos;  % 不能让爪子飞起来，让爪子坐标和绳索末端坐标一致
                grabbing=false;   % 是否在抓取状态设置为否
                if holdOnType>0   % 如果收回的爪子抓住了东西，不是空的
                    money=money+stonePrice(holdOnType);           % 增加金钱
                    set(moneyStrHdl,'String',['$',num2str(money)])% 显示金钱
                end
                holdOnType=0; % 将爪子抓住的东西类型重设为0
                
                % 将爪子抓的图像重新变为透明
                set(drawHoldOnHdl,'XData',[0,1],...
                                  'YData',[0,1],...
                                  'CData',ones(1,1),...
                                  'AlphaData',zeros(1,1));                  
            end

            % 如果爪子还没被收回而且爪子上有东西
            % 那么需要不断更新爪子上东西的位置
            if holdOnType~=0 % 如果爪子上有东西
                % 重设抓住物品的横纵坐标，移动抓住的物体
                set(drawHoldOnHdl,...
                    'XData',[-stoneSize(holdOnType,1),stoneSize(holdOnType,1)]+clawPos(1)+norm(stoneSize(holdOnType,:))*sint,...
                    'YData',[-stoneSize(holdOnType,2),stoneSize(holdOnType,2)]+clawPos(2)+norm(stoneSize(holdOnType,:))*cost);
            end
        end
        
        % 设置爪子和绳子的位置
        set(drawClawHdl,'XData',rotateX+clawPos(1),'YData',rotateY+clawPos(2));           % 设置爪子的位置
        set(drawLineHdl,'XData',[clawPos(1),ropePos(1)],'YData',[clawPos(2),ropePos(2)]); % 重新绘制绳子
    end

    % 判断是否抓住东西，抓住了什么东西
    function n=touchThing(clawPos)
        n=0;
        % 若是爪子坐标超出屏幕范围，则返回数值-1
        if clawPos(1)<20||clawPos(1)>730||clawPos(2)>480
            n=-1;     
        end

        % 爪子中心位置的x坐标是否属于各个石头的x坐标范围内
        % 例如各个石头的x范围为[x11,x12;x21,x22;x31,x32.... ...]
        % 那么如果x11<x<x12，但是其他石头都不符合xi1<x<xi2这个条件
        % 那么flagX=[1;0;0;0;... ...];即只有第一个石头的x坐标符合条件
        flagX=clawPos(1)>=stoneXrange(:,1)&clawPos(1)<=stoneXrange(:,2);
        % y坐标同理
        flagY=clawPos(2)>=stoneYrange(:,1)&clawPos(2)<=stoneYrange(:,2);
        % 找出同时符合x坐标条件及y坐标条件的石头
        flagXY=flagX&flagY;

        
        if any(flagXY) % 如果找到一个符合条件的石头
            n=find(flagXY); % 返回石头在列表中的序号
        end
    end

    % 按键盘时候会被调用的函数
    function key(~,event)
        switch event.Key
            case 'downarrow' % 当点击下箭头时
                % 开始抓东西设置为：是，速度设为4
                grabbing=true;v=4;
        end
    end
end