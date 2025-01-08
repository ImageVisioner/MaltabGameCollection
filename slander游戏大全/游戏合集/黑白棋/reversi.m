function reversi 
%图形界面初始化：
    axis equal
    axis([-0.2 9.2,-0.2 9.2])
    set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
    set(gca,'color',[0.6353 0.5451 0.3333])
    hold on
    
    % 下面这个矩阵用来放配色的，并没啥实际用途
    %    [0.2235    0.4902    0.2667
    %     0.3843    0.1569    0.0078
    %     0.7882    0.7647    0.4196
    %     0.6353    0.5451    0.3333
    %     0.1373    0.2902    0.1686];

%按键函数初始化设置：
    set(gcf,'KeyPressFcn',@key,'tag','keyset')
    set(gcf,'WindowButtonDownFcn',@buttondown)
    
%全局变量：
global winner;       %胜者
global turn;         %该哪方下棋
global checher_board %棋盘
global black;        %黑子位置集合
global white;        %白子位置集合

global plotblack;    %用于绘制黑子的函数（图像句柄）
global plotwhite;    %用于绘制白子的函数（图像句柄）

global postion;      %选择的位置（选择位置为可达位置才能落子）
global arrivable;    %可达位置
global plotpostion;  %绘制选择位置的函数（图像句柄）
global plotarrivable;%绘制可达位置的函数（图像句柄）
init()
    function init()
        %初始化前清除原有图像：
        delete(findobj('tag','piece'));
        delete(findobj('tag','gc'));
        delete(findobj('tag','rx'));
        delete(findobj('type','line'));
        delete(findobj('type','patch'));
        
        %棋盘绘制：
        fill([-0.1;9.1;9.1;-0.1;-0.1],[-0.1;-0.1;9.1;9.1;-0.1],[0.3843 0.1569 0.0078])
        fill([0.5;8.5;8.5;0.5;0.5],[0.5;0.5;8.5;8.5;0.5],[0.2235 0.4902 0.2667])
        plot([1.5:1:7.5;1.5:1:7.5],[ones(1,7).*0.5;ones(1,7).*8.5],'color',[0.1373 0.2902 0.1686],'linewidth',0.75)
        plot([ones(1,7).*0.5;ones(1,7).*8.5],[1.5:1:7.5;1.5:1:7.5],'color',[0.1373 0.2902 0.1686],'linewidth',0.75)
        scatter([2.5,6.5,2.5,6.5],[2.5,2.5,6.5,6.5],30,'filled','CData',[0.1373 0.2902 0.1686]);
        numberset={'A','B','C','D','E','F','G','H'};
        for i=1:8
            text(0.2,9-i,num2str(i),...
                'HorizontalAlignment','center',...
                'color',[0.6353 0.5451 0.3333],...
                'FontWeight','bold',...
                'FontSize',12)
            text(i,8.83,numberset{i},...
                'HorizontalAlignment','center',...
                'color',[0.6353 0.5451 0.3333],...
                'FontWeight','bold',...
                'FontSize',12)
        end
        
        %棋子棋盘数值初始化：
        winner=0;turn=1; %无人获胜，黑子先下
        black=[4 4;5 5];white=[4 5;5 4];%初始黑白子位置
        %初始化棋盘
        checher_board=zeros(8,8);
        checher_board(black(:,1)+(black(:,2)-1).*8)=1;
        checher_board(white(:,1)+(white(:,2)-1).*8)=-1;
        postion=[0 0];
        postion(1,:)=[];
        %初始化可达点列表
        arrivable=[5 3;6 4;3 5;4 6];
        
        %绘制函数初始化：
        plotblack=scatter(gca,black(:,1),black(:,2),450,'o','filled','CData',[0.1 0.1 0.1],'tag','piece');
        plotwhite=scatter(gca,white(:,1),white(:,2),450,'o','filled','CData',[0.9 0.9 0.9],'tag','piece');
        plotpostion=scatter(gca,postion(:,1),postion(:,2),50,'o','CData',[0.5059 0.6078 0.3529],'LineWidth',1.5,'tag','gc'); 
        plotarrivable=scatter(gca,arrivable(:,1),arrivable(:,2),150,'x',...
            'CData',[0.7843 0.3412 0.3098].*0.9,'LineWidth',1.5,'tag','rx'); 
        
    end

    %鼠标点击函数
    function buttondown(~,~)
        xy=get(gca,'CurrentPoint');%获取鼠标点击位置
        xp=xy(1,2);yp=xy(1,1);
        pos=[yp,xp];
        pos=round(pos);%取整点，确定点击位置应在棋盘第几行第几列
        if all(abs(pos)<=9)
            postion=pos;
            if strcmp(get(gcf,'SelectionType'),'normal'),set_piece();end%鼠标左键落子
            if strcmp(get(gcf,'SelectionType'),'extend'),init();end%shift+左键重新开始，不太好用建议不用
            redraw()%落完子(为各个数组添加或改变元素后)重新绘制期盼
        end
    end

    % 落子函数
    function set_piece(~,~)
        if ~isempty(intersect(postion,arrivable,'rows'))% 如果选择位置是可达位置
            
            %为黑子或白子集合添加元素
            switch turn
                case 1,black=[black;postion];checher_board(postion(1),postion(2))=1;
                case 0,white=[white;postion];checher_board(postion(1),postion(2))=-1;
            end
            
            %检测被“同化”的棋子并转变颜色
            change_color()
            
            %轮到另一种颜色落子
            turn=mod(turn+1,2); 
            
            %刷新可达集合
            refresh_arrivable()
        end
    end

    function change_color(~,~)
        %从下子位置检测八个方向，更换所有该更换颜色的棋子
        switch turn
            case 1,t=1;
            case 0,t=-1;
        end
        dir=[1 0;-1 0;0 1;0 -1;1 1;-1 -1;1 -1;-1 1];
        
        %集合初始化
        exchange_set=[0 0];
        exchange_set(1,:)=[];
        
        for j=1:8%检测八个方向
            %与检测可达集合类似操作：
            temp_set=postion+((1:7)')*dir(j,:);
            temp_set(temp_set(:,1)>8|temp_set(:,1)<1,:)=[];
            temp_set(temp_set(:,2)>8|temp_set(:,2)<1,:)=[];
            if ~isempty(temp_set)
                
                temp_value=checher_board(temp_set(:,1)+(temp_set(:,2)-1).*8);
                
                %如果离位置最近为反色棋子，找到该集合第一个不是反色棋子的位置
                %如果该位置为同色，便将两同色棋子之间的反色棋子全部替换
                if temp_value(1)==-t
                    cumpoint=find(temp_value~=-t,1);%找到第一个不是反色棋子的位置
                    if ~isempty(cumpoint)
                        if temp_value(cumpoint)==t%如果是同色 
                            exchange_set=[exchange_set;temp_set(1:cumpoint-1,:)];%加入同化集合
                        end
                    end
                end  
            end
        end
        exchange_set=unique(exchange_set,'rows');%删除重复项
        
        %改变棋子集合
        switch turn
            case 1
                black=[black;exchange_set];
                checher_board(exchange_set(:,1)+(exchange_set(:,2)-1).*8)=1;
                [~,w,~]=intersect(white,exchange_set,'rows');
                white(w,:)=[];
            case 0
                white=[white;exchange_set];
                checher_board(exchange_set(:,1)+(exchange_set(:,2)-1).*8)=-1;
                [~,b,~]=intersect(black,exchange_set,'rows');
                black(b,:)=[]; 
        end
    end

    % 刷新可达点集合(调用get_arrivable函数)
    function refresh_arrivable(~,~)
        arrivable=get_arrivable(checher_board,turn);
        % 如果无可落子点，直接转到对手回合并重新检测可达点
        if isempty(arrivable)
            judge()%检测是否有获胜方
            turn=mod(turn+1,2);
            arrivable=get_arrivable(checher_board,turn);
        end
    end

    % 重新绘制和黑子，白子，可达点，当前选择位置
    function redraw(~,~)
        set(plotblack,'XData',black(:,1),'YData',black(:,2))
        set(plotwhite,'XData',white(:,1),'YData',white(:,2))
        set(plotpostion,'XData',postion(:,1),'YData',postion(:,2))
        set(plotarrivable,'XData',arrivable(:,1),'YData',arrivable(:,2))
        if all(all(abs(checher_board)))&&winner==0
            judge()%检测是否有获胜方
        end
    end

    % 判断输赢函数
    function judge()
        % 如果棋盘下满，结束游戏，棋子数量较多的为胜者
        switch 1
            case (all(all(abs(checher_board)))&&size(black,1)>size(white,2))||isempty(white)
                winner=1;
            case (all(all(abs(checher_board)))&&size(white,1)>size(black,2))||isempty(black)
                winner=-1;
            case (all(all(abs(checher_board)))&&size(white,1)==size(black,2))
                winner=3;
        end
        
        %弹出窗口
        if winner~=0
            redraw()
            switch winner
            case 1
                buttonName1=questdlg('黑棋胜利','black win','关闭','重新开始','关闭');
                if isempty(buttonName1),buttonName1='end';end
                if strcmp(buttonName1,'重新开始'),init();
                elseif strcmp(buttonName1,'关闭'),close;
                end
            case -1
                buttonName1=questdlg('白棋胜利','white win','关闭','重新开始','关闭');
                if isempty(buttonName1),buttonName1='end';end
                if strcmp(buttonName1,'重新开始'),init();
                elseif strcmp(buttonName1,'关闭'),close;
                end
            case 3
                buttonName1=questdlg('平局','tie','关闭','重新开始','关闭');
                if isempty(buttonName1),buttonName1='end';end
                if strcmp(buttonName1,'重新开始'),init();
                elseif strcmp(buttonName1,'关闭'),close;
                end
            end
        end
    end

end
