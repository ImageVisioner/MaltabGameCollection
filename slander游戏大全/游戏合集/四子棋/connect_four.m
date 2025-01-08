function connect_four 
%图形界面初始化：
    h=figure('NumberTitle','off','Name','四子棋','menubar','none');
    uh1=uimenu('label','帮助');
    uimenu(uh1,'label','游戏规则','callback',@msg)
    uimenu(uh1,'label','按键设置','callback',@msg)   
    axis equal,axis([-4,4,-4,4])
    set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
    set(gca,'color',[0.9,0.8,0.5])
    hold on
%按钮设置：
    uicontrol('parent',h,...
    'style','pushbutton',...
    'string','重新开始',...
    'position',[30 360 80 30],...
    'backgroundcolor',[0.85 0.89 0.85],...
    'foregroundcolor','k',...
    'fontsize',12,...
    'callback',@init);
    uicontrol('parent',h,...
    'style','pushbutton',...
    'string','悔棋',...
    'position',[30 320 80 30],...
    'backgroundcolor',[0.85 0.89 0.85],...
    'foregroundcolor','k',...
    'fontsize',12,...
    'callback',@undo);
    uicontrol('parent',h,...
    'tag','turn',...
    'style','text',...
    'HorizontalAlignment','left',...
    'string',{'　提示：';'';'　黑棋落子'},...
    'position',[30 210 80 100],...
    'backgroundcolor',[0.96 0.96 0.96],...
    'foregroundcolor','k',...
    'fontsize',11);
%按键函数初始化设置：
    set(gcf,'KeyPressFcn',@key,'tag','keyset')
%全局变量：
global black;             %黑子在棋盘中位置
global white;             %白子在棋盘中位置
global postion;           %红叉在棋盘中位置
global forbid_pos;        %禁手位置
global avilable_pos;      %可下位置
global turn;              %下棋方，值为1时黑方下，值为0时白方下
global winner;            %胜方，值为1时黑棋胜，值为-1时白棋胜
global checherboard;      %7x7棋盘矩阵，值可能为0,1,-1
global plotblack;         %绘制黑子的函数
global plotwhite;         %绘制白子的函数
%global plotpostion;      %绘制红叉的函数
init()

    function init(~,~)
        %初始化函数
        %每次初始化前删除之前图像：
        delete(findobj('type','line'));
        delete(findobj('type','patch'));
        delete(findobj('tag','piece'));
        delete(findobj('tag','redcross'));
        
        %棋子棋盘数值初始化：
        black=[20,20];white=[20,20];postion=[0 0];
        winner=0;checherboard=zeros(7,7);turn=1;
        forbid_pos=[1 0;-1 0;0 1;0 -1;1 1;1 -1;-1 1;-1 -1;2 0;0 2;0 -2;-2 0];
        avilable_pos=[[(-2:1:2)',2*ones(5,1)];...
                      [(-2:1:2)',1*ones(5,1)];...
                      [(-2:1:2)',0*ones(5,1)];...
                      [(-2:1:2)',-1*ones(5,1)];...
                      [(-2:1:2)',-2*ones(5,1)];...
                      [1,3;3,1;3,-1;1,-3;-1,3;-3,1;-1,-3;-3,-1]];
        [~,d,~]=intersect(avilable_pos,forbid_pos,'rows');
        avilable_pos(d,:)=[];
        
        %用来绘制棋子红叉的函数初始化：
        plotblack=scatter(gca,black(:,1),black(:,2),420,'k','filled','tag','piece');
        plotwhite=scatter(gca,white(:,1),white(:,2),420,'w','filled','tag','piece');%plotpostion=scatter(gca,postion(1,1),postion(1,2),220,'rx');
        text(postion(1,1),postion(1,2),'x','color',[0.8 0 0],'fontsize',20,'HorizontalAlignment', 'center','tag','redcross');
        
        %绘制棋盘：
        x1=[-3.5,3.5,3.5,-3.5,-3.5];y1=[0.5,0.5,1.5,1.5,0.5];
        x2=[-2.5,2.5,2.5,-2.5,-2.5];y2=[1.5,1.5,2.5,2.5,1.5];
        y11=[-0.5,-0.5,-1.5,-1.5,-0.5];y22=[-1.5,-1.5,-2.5,-2.5,-1.5];
        plot(x1,y1,'k',x1,y11,'k',y1,x1,'k',y11,x1,'k')
        plot(x2,y2,'k',x2,y22,'k',y2,x2,'k',y22,x2,'k')
        edge=[1.5,3.5;3.5,1.5;3.5,-1.5;1.5,-3.5;-1.5,-3.5;-3.5,-1.5;-3.5,1.5;-1.5,3.5;1.5,3.5];
        plot(edge(:,1),edge(:,2),'color','k','linewidth',1)
        plot(edge(:,1).*1.05,edge(:,2).*1.05,'color','k','linewidth',1.2)
        
        %绘制禁手位置：
        shadow1=[0.5,0.5;1.5,0.5;1.5,-0.5;0.5,-0.5;0.5,0.5];
        fill(shadow1(:,1),shadow1(:,2),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow1(:,1).*(-1),shadow1(:,2),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow1(:,2),shadow1(:,1),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow1(:,2),shadow1(:,1).*(-1),[0.9,0.8,0.5]*0.8,'tag','forbid')
        shadow4=[0.5,0.5;0.5,1.5;1.5,1.5;1.5,0.5;0.5,0.5];
        fill(shadow4(:,1),shadow4(:,2),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow4(:,1).*(-1),shadow4(:,2),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow4(:,2),shadow4(:,1).*(-1),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow4(:,2).*(-1),shadow4(:,1).*(-1),[0.9,0.8,0.5]*0.8,'tag','forbid')
        shadow5=[1.5,-0.5;2.5,-0.5;2.5,0.5;1.5,0.5;1.5,-0.5];
        fill(shadow5(:,1),shadow5(:,2),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow5(:,1).*(-1),shadow5(:,2),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow5(:,2),shadow5(:,1),[0.9,0.8,0.5]*0.8,'tag','forbid')
        fill(shadow5(:,2).*(-1),shadow5(:,1).*(-1),[0.9,0.8,0.5]*0.8,'tag','forbid')
        
        shadow2=[2.5,1.5;3.5,1.5;2.5,2.5;2.5,1.5];
        fill(shadow2(:,1),shadow2(:,2),[0.9,0.8,0.5]*0.8)
        fill(shadow2(:,1).*(-1),shadow2(:,2),[0.9,0.8,0.5]*0.8)
        fill(shadow2(:,1),shadow2(:,2).*(-1),[0.9,0.8,0.5]*0.8)
        fill(shadow2(:,1).*(-1),shadow2(:,2).*(-1),[0.9,0.8,0.5]*0.8)
        fill(shadow2(:,2),shadow2(:,1),[0.9,0.8,0.5]*0.8)
        fill(shadow2(:,2).*(-1),shadow2(:,1),[0.9,0.8,0.5]*0.8)
        fill(shadow2(:,2),shadow2(:,1).*(-1),[0.9,0.8,0.5]*0.8)
        fill(shadow2(:,2).*(-1),shadow2(:,1).*(-1),[0.9,0.8,0.5]*0.8)
        shadow3=[2.5,-0.5;3.5,-0.5;3.5,0.5;2.5,0.5;2.5,-0.5];
        fill(shadow3(:,1),shadow3(:,2),[0.9,0.8,0.5]*0.8)
        fill(shadow3(:,1).*(-1),shadow3(:,2),[0.9,0.8,0.5]*0.8)
        fill(shadow3(:,2),shadow3(:,1),[0.9,0.8,0.5]*0.8)
        fill(shadow3(:,2),shadow3(:,1).*(-1),[0.9,0.8,0.5]*0.8)    
    end

    function msg(menuData,~)
        %提示文本弹出函数
            switch menuData.Text
                case '游戏规则',msgbox({'游戏规则:';'　　在棋盘内落子，当横竖或斜着连成四子即为胜利 ';...
                                     '';'禁手规则:';'　　第一步棋不能下在棋盘颜色较暗的格子内'});
                case '按键设置',msgbox({'按键设置:';'　　1.↑↓←→改变落子位置';...
                                                    '　　2.空格键落子'});
            end
        end

    function key(~,event)
        %按键函数
        switch event.Key
            case 'uparrow',postion=postion+[0,1];      
            case 'downarrow',postion=postion+[0,-1];
            case 'leftarrow',postion=postion+[-1,0];
            case 'rightarrow',postion=postion+[1,0];
            case 'space'
                if checherboard(postion(1)+4,postion(2)+4)==0&&~isempty(intersect(postion,avilable_pos,'rows'))&&winner==0
                        switch turn
                            case 1,black=[black;postion];checherboard(postion(1)+4,postion(2)+4)=1;
                            case 0,white=[white;postion];checherboard(postion(1)+4,postion(2)+4)=-1;   
                        end
                        avilable_pos=[avilable_pos;forbid_pos];
                        avilable_pos=unique(avilable_pos,'rows');
                        turn=mod(turn+1,2);%值为1时下黑子，值为0时下白子
                end
        end
        %使红叉不超出棋盘范围：
        postion(postion>3)=-3;
        postion(postion<-3)=3;
        redraw()
    end

    function redraw(~,~)
        %图像更新函数
        %删除第一步的禁手限制：
        if any(any(checherboard~=0))
            delete(findobj('tag','forbid'));
        end
        %重新绘制图像： 
        delete(findobj('tag','redcross'));
        set(plotblack,'XData',black(:,1),'YData',black(:,2))
        set(plotwhite,'XData',white(:,1),'YData',white(:,2))%set(plotpostion,'XData',postion(1,1),'YData',postion(1,2))
        text(postion(1,1),postion(1,2),'x','color',[0.8 0 0],'fontsize',20,'HorizontalAlignment', 'center','tag','redcross');
        if winner==0
            switch turn
                case 1,set(findobj('tag','turn'),'string',{'　提示：';'';'　黑棋落子'});
                case 0,set(findobj('tag','turn'),'string',{'　提示：';'';'　白棋落子'});
            end
        else
            switch winner
                case 1,set(findobj('tag','turn'),'string',{'　提示：';'';'　黑棋获胜'});
                case -1,set(findobj('tag','turn'),'string',{'　提示：';'';'　白棋获胜'});
            end
        end
        judge()
    end

    function judge(~,~)
        temp_mat_1=checherboard+[checherboard(:,2:end),zeros(7,1)]+[checherboard(:,3:end),zeros(7,2)]+[checherboard(:,4:end),zeros(7,3)];%向上
        temp_mat_2=checherboard+[checherboard(2:end,:);zeros(1,7)]+[checherboard(3:end,:);zeros(2,7)]+[checherboard(4:end,:);zeros(3,7)];%向右
        temp_mat_3=checherboard+[zeros(1,7);[checherboard(1:6,2:end),zeros(6,1)]]+...
                                [zeros(2,7);[checherboard(1:5,3:end),zeros(5,2)]]+...
                                [zeros(3,7);[checherboard(1:4,4:end),zeros(4,3)]];%左上
        temp_mat_4=checherboard+[[checherboard(2:end,2:end),zeros(6,1)];zeros(1,7)]+...
                                [[checherboard(3:end,3:end),zeros(5,2)];zeros(2,7)]+...
                                [[checherboard(4:end,4:end),zeros(4,3)];zeros(3,7)];%右上
        switch 1
            case any(any(temp_mat_1==4))||any(any(temp_mat_1==-4)),winner=any(any(temp_mat_1==4))-any(any(temp_mat_1==-4));[pos_x,pos_y]=find(temp_mat_1(:,:)==winner*4);dir=1;
            case any(any(temp_mat_2==4))||any(any(temp_mat_2==-4)),winner=any(any(temp_mat_2==4))-any(any(temp_mat_2==-4));[pos_x,pos_y]=find(temp_mat_2(:,:)==winner*4);dir=2;
            case any(any(temp_mat_3==4))||any(any(temp_mat_3==-4)),winner=any(any(temp_mat_3==4))-any(any(temp_mat_3==-4));[pos_x,pos_y]=find(temp_mat_3(:,:)==winner*4);dir=3;
            case any(any(temp_mat_4==4))||any(any(temp_mat_4==-4)),winner=any(any(temp_mat_4==4))-any(any(temp_mat_4==-4));[pos_x,pos_y]=find(temp_mat_4(:,:)==winner*4);dir=4;
        end
        vector=[0 3;3 0;-3 3;3 3];
        if winner~=0
            plot([pos_x-4;pos_x-4+vector(dir,1)],[pos_y-4;pos_y-4+vector(dir,2)],'color',[0.8 0 0],'linewidth',2,'tag','clues')
            delete(findobj('tag','redcross'))
            switch winner
                case 1,set(findobj('tag','turn'),'string',{'　提示：';'';'　黑棋获胜'});
                case -1,set(findobj('tag','turn'),'string',{'　提示：';'';'　白棋获胜'});
            end
        end
        %输赢判定函数
    end

    function undo(~,~)
        if winner~=0
            delete(findobj('tag','clues'));      
        end
        if any(any(checherboard~=0))
            switch turn
                case 1,if ~isempty(white),checherboard(white(end,1)+4,white(end,2)+4)=0;white(end,:)=[];turn=0;end
                case 0,if ~isempty(black),checherboard(black(end,1)+4,black(end,2)+4)=0;black(end,:)=[];turn=1;end
            end
        end
        if ~any(any(checherboard~=0))
            init()
        end
        redraw()
    end

end
