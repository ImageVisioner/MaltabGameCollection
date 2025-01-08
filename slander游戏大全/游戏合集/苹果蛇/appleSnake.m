function appleSnake

% 加载图像数据
MT=load('material.mat');
MT=MT.MT;
SIZE.BASE=size(MT.base.CData,1);
SIZE.EXIT=size(MT.exit.CData,1);
SIZE.STONE=size(MT.stone.CData,1);
SIZE.APPLE=size(MT.apple.CData,1);
SIZE.SNAKE=size(MT.snake1.CData,1);
SIZE.RESTART=size(MT.restart.CData,1);
% 初始化地图及关卡
[fig,ax]=init();
LEVEL=1;
MAP=getMap(LEVEL);
loadMap();
refreshSnake();
text(10,1000,'当前关卡：','FontSize',18,'FontWeight','bold')
LEVEL_HDL=text(270,1000,num2str(LEVEL),'FontSize',18,'FontWeight','bold');
% =========================================================================
set(fig,'KeyPressFcn',@key); 
    function key(~,event)
        dirvec=[0,0];
        switch event.Key
            case 'uparrow'
                dirvec=[-1,0];
                [~,colSet]=find(MAP<0);
                if all(colSet==colSet(1))
                    dirvec=[0,0];
                end
            case 'downarrow',dirvec=[1,0];
            case 'rightarrow',dirvec=[0,1];
            case 'leftarrow',dirvec=[0,-1];
        end
        if sum(dirvec)~=0
            [hi,hj]=find(MAP==-1);
            switch MAP(hi+dirvec(1),hj+dirvec(2))
                case 0
                    MAP(MAP<0)=MAP(MAP<0)-1;
                    MAP(MAP==min(MAP,[],[1,2]))=0;
                    MAP(hi+dirvec(1),hj+dirvec(2))=-1;
                case 1
                case 2
                    MAP(MAP<0)=MAP(MAP<0)-1;
                    MAP(MAP==min(MAP,[],[1,2]))=0;
                    MAP(hi+dirvec(1),hj+dirvec(2))=-1;
                    refreshSnake()
                    win();
                    return;
                case 3
                    MAP(MAP<0)=MAP(MAP<0)-1;
                    APPLE_HDL=findobj('Tag','APPLE','UserData',[hi+dirvec(1),hj+dirvec(2)]);
                    MAP(hi+dirvec(1),hj+dirvec(2))=-1;delete(APPLE_HDL);
                case 4
                    if MAP(hi+2*dirvec(1),hj+2*dirvec(2))==0
                        MAP(MAP<0)=MAP(MAP<0)-1;
                        MAP(MAP==min(MAP,[],[1,2]))=0;
                        MAP(hi+dirvec(1),hj+dirvec(2))=-1;
                        MAP(hi+2*dirvec(1),hj+2*dirvec(2))=4;
                        STONE_HDL=findobj('Tag','STONE','UserData',[hi+dirvec(1),hj+dirvec(2)]);
                        STONE_HDL.XData=STONE_HDL.XData+70*dirvec(2);
                        STONE_HDL.YData=STONE_HDL.YData-70*dirvec(1);
                        STONE_HDL.UserData=[hi+2*dirvec(1),hj+2*dirvec(2)];
                        tCol=MAP(:,hj+2*dirvec(2));tCol(60)=1;
                        nRow=find(tCol~=0&((1:60)'>hi+2*dirvec(1)),1,'first')-1;
                        STONE_HDL.YData=STONE_HDL.YData-70*(nRow-hi+dirvec(1));
                        STONE_HDL.UserData=[nRow,hj+2*dirvec(2)];
                        MAP(hi+2*dirvec(1),hj+2*dirvec(2))=0;
                        MAP(nRow,hj+2*dirvec(2))=4;
                    end
            end
            refreshSnake();pause(.15)
            freeFall();
            refreshSnake()
        end
    end
    function freeFall()
        [rowSet,colSet]=find(MAP<0);
        diffmin=inf;
        for t=1:length(rowSet)
            tCol=MAP(:,colSet(t));
            tCol(60)=1;
            tRow=find(tCol>0&((1:60)'>rowSet(t)),1,'first');
            diffmin=min(diffmin,tRow-rowSet(t));
        end
        diffmin=diffmin-1;
        if diffmin>15
            loss(diffmin)
        elseif diffmin>0
            tMAP=MAP;
            for t=1:length(rowSet)
                tMAP(rowSet(t),colSet(t))=0;
            end
            for t=1:length(rowSet)
                tMAP(rowSet(t)+diffmin,colSet(t))=MAP(rowSet(t),colSet(t));
            end
            MAP=tMAP;
        end
        
    end
    function restart(~,~)
        MAP=getMap(LEVEL);
        if ~isempty(MAP)
            loadMap();
            refreshSnake();
            LEVEL_HDL.String=num2str(LEVEL);
        end
    end
    function win(~,~)
        LEVEL=LEVEL+1;
        MAP=getMap(LEVEL);
        if ~isempty(MAP)
            loadMap();
            refreshSnake();
            LEVEL_HDL.String=num2str(LEVEL);
        else
            msgbox('暂无更多关卡')
        end
    end
    function loss(D)
        if D>15
            for d=1:20
                [rowSet,colSet]=find(MAP<0);
                tMAP=MAP;
                for t=1:length(rowSet)
                    tMAP(rowSet(t),colSet(t))=0;
                end
                for t=1:length(rowSet)
                    tMAP(rowSet(t)+1,colSet(t))=MAP(rowSet(t),colSet(t));
                end
                MAP=tMAP;
                refreshSnake();
                pause(.1);
            end
        end
    end
% =========================================================================
    function [fig,ax]=init(~,~)
        % figure窗口创建及属性设置
        fig=figure();
        fig.NumberTitle='off';
        fig.Position=[250,120,500,500];
        fig.MenuBar='none';
        fig.Name='apple snake by slandarer';
        % axes坐标区域创建及属性设置
        ax=gca;hold on
        ax.Position=[0 0 1 1];
        ax.XTick=[];
        ax.YTick=[];
        ax.XColor='none';
        ax.YColor='none';
        ax.XLim=[0,1050];
        ax.YLim=[0,1050];
        % 绘制背景
        image(ax,ax.XLim,ax.YLim,flipud(MT.background))
        image(ax,[-SIZE.RESTART/2,SIZE.RESTART/2]+60,...
                [-SIZE.RESTART/2,SIZE.RESTART/2]+900,...
                flipud(MT.restart.CData),...
                'AlphaData',flipud(MT.restart.AlpData),...
                'ButtonDownFcn',@restart)
    end

    function map=getMap(level)
        % 地图大小15x15
        % 空气 :  0
        % 土块 :  1
        % 蛇头 : -1,蛇身数值依次递减
        % 终点 :  2
        % 苹果 :  3
        % 石块 :  4
        Map{1}=[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  3  0  0  0  0  0  0  0
                 0  0 -2 -1  0  0  0  0  0  0  0  2  0  0  0
                 0  0 -3  1  1  1  0  0  0  1  1  1  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
        Map{2}=[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  2  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0 -3 -2 -1  0  0  0  0  0  0  0  0  0  0
                 0  0  1  1  1  0  1  1  1  0  1  0  0  0  0
                 0  0  0  0  1  0  0  3  0  0  1  0  0  0  0
                 0  0  0  0  1  0  1  1  1  0  1  0  0  0  0
                 0  0  0  0  1  1  1  0  1  0  1  0  0  0  0
                 0  0  0  0  0  0  0  0  1  1  1  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
        Map{3}=[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0 -3 -2 -1  0  0  0  0  0  0  2  0  0  0
                 0  0  1  1  1  1  0  0  0  0  0  1  0  0  0
                 0  0  1  0  0  1  0  0  0  0  0  1  0  0  0
                 0  0  1  0  0  0  0  3  0  0  0  1  0  0  0
                 0  0  1  1  1  1  0  0  0  1  1  1  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
        Map{4}=[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  1  0  0  1  1  0  0  0  0  0
                 0  0  0  0  0  1  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  1  0  3  0  1  0  0  0  0  0
                 0  0 -3 -2 -1  0  0  0  0  0  0  0  0  0  0
                 0  0  1  1  1  1  1  0  0  0  1  1  1  1  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  2  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
        Map{5}=[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  2  0  0  0
                 0  0  0  0  0  0  0  1  1  1  1  1  0  0  0
                 0  0  0  0  0  0  0  1  3  0  1  0  0  0  0
                 0  0  0 -2 -1  0  0  0  0  0  1  0  0  0  0
                 0  0  0 -3  1  1  1  1  0  0  1  0  0  0  0
                 0  0  0  0  0  0  0  1  1  1  1  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
        Map{6}=[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  2  0  0
                 0  0  0  0  0  0  0  0  1  0  0  0  0  0  0
                 0  0  0  0  0  0  1  3  1  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0 -3 -2 -1  0  0  0  4  0  0  0  0
                 0  0  0  0  1  1  1  0  1  1  1  0  0  0  0
                 0  0  0  0  0  0  1  1  1  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
        Map{7}=[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  4  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  1  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  1  0  0  0  0  0  2  0  0
                 0  0  0  0  0  0  1  3  0  0  0  0  0  0  0
                 0  0  0  0 -3 -2 -1  0  0  0  0  0  0  0  0
                 0  0  0  0  1  1  1  1  1  1  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
        Map{8}=[ 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  1  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  4  0  0  0  0  0  0  0  0
                 0  0  0  0  0  1  3  1  0  0  0  0  0  0  0
                 0  0  0  0 -2 -1  0  0  0  0  0  0  0  0  0
                 0  0  0  0 -3  1  1  1  1  1  0  0  0  0  0
                 0  0  0  0  0  0  2  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  1  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
                 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
        Map{9}=[];
        map=Map{level};
    end
    function loadMap(~,~)
        delete(findobj('Tag','BASE'))
        delete(findobj('Tag','EXIT'))
        delete(findobj('Tag','APPLE'))
        delete(findobj('Tag','STONE'))
        % 绘制土块
        for i=15:-1:1
            for j=15:-1:1
                if MAP(i,j)==1
                    image(ax,70*(j-1)+35+[-SIZE.BASE/2,SIZE.BASE/2],...
                        70*(16-i)+35+[-SIZE.BASE/2,SIZE.BASE/2],...
                        flipud(MT.base.CData),...
                        'alphaData',flipud(MT.base.AlpData),...
                        'tag','BASE');
                end
            end
        end
        % 绘制出口
        [ti,tj]=find(MAP==2);
        image(ax,70*(tj-1)+35+[-SIZE.EXIT/2,SIZE.EXIT/2],...
            70*(16-ti)+35+[-SIZE.EXIT/2,SIZE.EXIT/2],...
            flipud(MT.exit.CData),...
            'alphaData',flipud(MT.exit.AlpData),...
            'tag','EXIT');
        % 绘制苹果
        [ti,tj]=find(MAP==3);
        if ~isempty(ti)
        image(ax,70*(tj-1)+35+[-SIZE.APPLE/2,SIZE.APPLE/2],...
            70*(16-ti)+35+[-SIZE.APPLE/2,SIZE.APPLE/2],...
            flipud(MT.apple.CData),...
            'alphaData',flipud(MT.apple.AlpData),...
            'tag','APPLE','UserData',[ti,tj]);
        end
        % 绘制石块
        [ti,tj]=find(MAP==4);
        if ~isempty(ti)
        image(ax,70*(tj-1)+35+[-SIZE.STONE/2,SIZE.STONE/2],...
            70*(16-ti)+35+[-SIZE.STONE/2,SIZE.STONE/2],...
            flipud(MT.stone.CData),...
            'alphaData',flipud(MT.stone.AlpData),...
            'tag','STONE','UserData',[ti,tj]);
        end
    end
    function refreshSnake(~,~)
        delete(findobj('Tag','SNAKE'))
        % 画蛇头
        [ti,tj]=find(MAP==-1);
        [ti_n,tj_n]=find(MAP==-2);
        tSnakeC=MT.snake1.CData;
        tSnakeAlp=MT.snake1.AlpData;
        if tj_n>tj
            tSnakeC=fliplr(tSnakeC);
            tSnakeAlp=fliplr(tSnakeAlp);
        end
        if ti_n>ti
            if MAP(ti,tj-1)==1
                tSnakeC(:,:,1)=flipud(tSnakeC(end:-1:1,:,1)');
                tSnakeC(:,:,2)=flipud(tSnakeC(end:-1:1,:,2)');
                tSnakeC(:,:,3)=flipud(tSnakeC(end:-1:1,:,3)');
                tSnakeAlp=flipud(tSnakeAlp'); 
            else
                tSnakeC(:,:,1)=flipud(tSnakeC(:,:,1)');
                tSnakeC(:,:,2)=flipud(tSnakeC(:,:,2)');
                tSnakeC(:,:,3)=flipud(tSnakeC(:,:,3)');
                tSnakeAlp=flipud(tSnakeAlp');
            end
        end
        if ti_n<ti
            if MAP(ti,tj-1)==1
                tSnakeC(:,:,1)=tSnakeC(end:-1:1,:,1)';
                tSnakeC(:,:,2)=tSnakeC(end:-1:1,:,2)';
                tSnakeC(:,:,3)=tSnakeC(end:-1:1,:,3)';
                tSnakeAlp=tSnakeAlp'; 
            else
                tSnakeC(:,:,1)=tSnakeC(:,:,1)';
                tSnakeC(:,:,2)=tSnakeC(:,:,2)';
                tSnakeC(:,:,3)=tSnakeC(:,:,3)';
                tSnakeAlp=tSnakeAlp';
            end
        end
        image(ax,70*(tj-1)+35+[-SIZE.SNAKE/2,SIZE.SNAKE/2],...
            70*(16-ti)+35+[-SIZE.SNAKE/2,SIZE.SNAKE/2],...
            flipud(tSnakeC),...
            'alphaData',flipud(tSnakeAlp),...
            'tag','SNAKE');
        [ti,tj]=find(MAP==min(MAP,[],[1,2]));
        [ti_l,tj_l]=find(MAP==min(MAP,[],[1,2])+1);
        tSnakeC=MT.snake4.CData;
        tSnakeAlp=MT.snake4.AlpData;
        switch true
            case tj_l>tj
            case tj_l<tj
                tSnakeC=fliplr(tSnakeC);
                tSnakeAlp=fliplr(tSnakeAlp);
            case ti_l<ti
                tSnakeC(:,:,1)=flipud(tSnakeC(:,:,1)');
                tSnakeC(:,:,2)=flipud(tSnakeC(:,:,2)');
                tSnakeC(:,:,3)=flipud(tSnakeC(:,:,3)');
                tSnakeAlp=flipud(tSnakeAlp');
            case ti_l>ti
                tSnakeC(:,:,1)=tSnakeC(:,:,1)';
                tSnakeC(:,:,2)=tSnakeC(:,:,2)';
                tSnakeC(:,:,3)=tSnakeC(:,:,3)';
                tSnakeAlp=tSnakeAlp';
        end
        % 画蛇尾
        image(ax,70*(tj-1)+35+[-SIZE.SNAKE/2,SIZE.SNAKE/2],...
            70*(16-ti)+35+[-SIZE.SNAKE/2,SIZE.SNAKE/2],...
            flipud(tSnakeC),...
            'alphaData',flipud(tSnakeAlp),...
            'tag','SNAKE');
        % 画蛇身体
        for i=-2:-1:(min(MAP,[],[1,2])+1)
            [ti,tj]=find(MAP==i);
            [ti_l,tj_l]=find(MAP==i+1);
            [ti_n,tj_n]=find(MAP==i-1);
            switch true
                case ti_l==ti_n
                    tSnakeC=MT.snake2.CData;
                    tSnakeAlp=MT.snake2.AlpData;
                case tj_l==tj_n
                    tSnakeC=MT.snake2.CData;
                    tSnakeAlp=MT.snake2.AlpData;
                    tSnakeC(:,:,1)=tSnakeC(:,:,1)';
                    tSnakeC(:,:,2)=tSnakeC(:,:,2)';
                    tSnakeC(:,:,3)=tSnakeC(:,:,3)';
                    tSnakeAlp=tSnakeAlp';
                case ti_l<ti_n&&tj_l>tj_n&&ti>ti_l
                    tSnakeC=MT.snake3.CData;
                    tSnakeAlp=MT.snake3.AlpData;
                    tSnakeC=rot90(tSnakeC,2);
                    tSnakeAlp=rot90(tSnakeAlp,2);
                case ti_l<ti_n&&tj_l>tj_n&&tj<tj_l
                    tSnakeC=MT.snake3.CData;
                    tSnakeAlp=MT.snake3.AlpData;
                case ti_l<ti_n&&tj_l<tj_n&&ti>ti_l
                    tSnakeC=MT.snake3.CData;
                    tSnakeAlp=MT.snake3.AlpData;
                    tSnakeC=flipud(tSnakeC);
                    tSnakeAlp=flipud(tSnakeAlp);
                case ti_l<ti_n&&tj_l<tj_n&&tj>tj_l
                    tSnakeC=MT.snake3.CData;
                    tSnakeAlp=MT.snake3.AlpData;
                    tSnakeC=fliplr(tSnakeC);
                    tSnakeAlp=fliplr(tSnakeAlp);
                case ti_l>ti_n&&tj_l>tj_n&&ti<ti_l
                    tSnakeC=MT.snake3.CData;
                    tSnakeAlp=MT.snake3.AlpData;
                    tSnakeC=fliplr(tSnakeC);
                    tSnakeAlp=fliplr(tSnakeAlp);
                case ti_l>ti_n&&tj_l>tj_n&&tj<tj_l
                    tSnakeC=MT.snake3.CData;
                    tSnakeAlp=MT.snake3.AlpData;
                    tSnakeC=flipud(tSnakeC);
                    tSnakeAlp=flipud(tSnakeAlp);
                case ti_l>ti_n&&tj_l<tj_n&&ti<ti_l
                    tSnakeC=MT.snake3.CData;
                    tSnakeAlp=MT.snake3.AlpData;
                case ti_l>ti_n&&tj_l<tj_n&&tj>tj_l
                    tSnakeC=MT.snake3.CData;
                    tSnakeAlp=MT.snake3.AlpData;
                    tSnakeC=rot90(tSnakeC,2);
                    tSnakeAlp=rot90(tSnakeAlp,2);
            end
            image(ax,70*(tj-1)+35+[-SIZE.SNAKE/2,SIZE.SNAKE/2],...
            70*(16-ti)+35+[-SIZE.SNAKE/2,SIZE.SNAKE/2],...
            flipud(tSnakeC),...
            'alphaData',flipud(tSnakeAlp),...
            'tag','SNAKE');
        end
    end
end