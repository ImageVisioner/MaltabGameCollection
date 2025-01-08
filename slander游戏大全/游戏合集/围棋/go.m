function go 
    axis equal
    axis([-10,10,-10,10])
    set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
    set(gca,'color',[0.8392,0.7216,0.3804])
    hold on
%按键函数初始化设置：
    set(gcf,'KeyPressFcn',@key,'tag','keyset')
    set(gcf,'WindowButtonDownFcn',@buttondown)
%全局变量：
global winner;
global turn;
global checher_board
global black;
global white;
global postion;
global plotblack;
global plotwhite;
global plotpostion;
global bout;
global warehouse;
init()
    function init(~,~)
        %初始化前清除原有图像：
        delete(findobj('tag','piece'));
        delete(findobj('tag','redcross'));
        delete(findobj('type','line'));
        delete(findobj('type','patch'));
        
        %棋盘绘制：
        x1=[-9,-9,-8,-8,-7,-7,-6,-6,-5,-5,-4,-4,-3,-3,-2,-2,-1,-1,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9];
        y1=[-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9,9,-9,-9,9];
        x2=[-9,9,9,-9,-9];y2=[9,9,-9,-9,9];x3=[-9.2,9.2,9.2,-9.2,-9.2];y3=[9.2,9.2,-9.2,-9.2,9.2];
        x4=[-6,-6,-6,0,0,0,6,6,6];y4=[6,0,-6,6,0,-6,6,0,-6];
        plot(x1,y1,'k'),plot(y1,x1,'k')
        plot(x2,y2,'k','LineWidth',2)
        plot(x3,y3,'k'),scatter(gca,x4,y4,30,'k','filled')
        
        %棋子棋盘数值初始化：
        winner=0;postion=[0 0];turn=1;
        black=[20,20 0];white=[-20,-20 0];
        black(1,:)=[];white(1,:)=[];
        checher_board=zeros(19,19);
        
        bout=1;
        warehouse{bout,1}=checher_board;
        warehouse{bout,2}=turn;
        warehouse{bout,3}=black;
        warehouse{bout,4}=white;
        
        %绘制函数初始化：
        plotblack=scatter(gca,black(:,1),black(:,2),150,'k','filled','tag','piece');
        plotwhite=scatter(gca,white(:,1),white(:,2),150,'w','filled','tag','piece');
        plotpostion=scatter(gca,postion(1,1),postion(1,2),150,'rx','tag','redcross');
    end

    function key(~,event)
        %按键函数
        switch event.Key
            case 'uparrow',postion=postion+[0,1];      
            case 'downarrow',postion=postion+[0,-1];
            case 'leftarrow',postion=postion+[-1,0];
            case 'rightarrow',postion=postion+[1,0];
            case 'space',set_piece();
            case 'backspace',undo();
            case 'r',init();
        end
        postion(postion>9)=-9;
        postion(postion<-9)=9;
        redraw()
    end

    function buttondown(~,~)
        xy=get(gca,'CurrentPoint');
        xp=xy(1,2);yp=xy(1,1);
        pos=[yp,xp];
        pos=round(pos);
        if all(abs(pos)<=9)
            postion=round(pos);
            if strcmp(get(gcf,'SelectionType'),'alt'),undo();end
            if strcmp(get(gcf,'SelectionType'),'open'),undo();end
            if strcmp(get(gcf,'SelectionType'),'normal'),set_piece();end
            if strcmp(get(gcf,'SelectionType'),'extend'),init();end
            redraw()
        end
    end

    function set_piece(~,~)
        if checher_board(postion(1)+10,postion(2)+10)==0
            switch turn
                case 1
                    checher_board(postion(1)+10,postion(2)+10)=1;
                    surrounded=weather_surrounded(checher_board,postion+[10 10]);
                    black=[black;[postion,surrounded]];                        
                case 0
                    checher_board(postion(1)+10,postion(2)+10)=-1;
                    surrounded=weather_surrounded(checher_board,postion+[10 10]);
                    white=[white;[postion,surrounded]];        
            end
            black=[black(:,1:2),weather_surrounded(checher_board,black(:,1:2)+[10 10])];
            white=[white(:,1:2),weather_surrounded(checher_board,white(:,1:2)+[10 10])];
            if ~isempty(intersect(postion+[0 1],[black(:,1:2);white(:,1:2)],'rows')),eat(postion+[0 1]);end
            if ~isempty(intersect(postion+[0 -1],[black(:,1:2);white(:,1:2)],'rows')),eat(postion+[0 -1]);end
            if ~isempty(intersect(postion+[1 0],[black(:,1:2);white(:,1:2)],'rows')),eat(postion+[1 0]);end
            if ~isempty(intersect(postion+[-1 0],[black(:,1:2);white(:,1:2)],'rows')),eat(postion+[-1 0]);end
            black=[black(:,1:2),weather_surrounded(checher_board,black(:,1:2)+[10 10])];
            white=[white(:,1:2),weather_surrounded(checher_board,white(:,1:2)+[10 10])];
            turn=mod(turn+1,2);
            bout=bout+1;
            warehouse{bout,1}=checher_board;
            warehouse{bout,2}=turn;
            warehouse{bout,3}=black;
            warehouse{bout,4}=white;
        end     
    end

    function eat(pos)
        switch 1
            case ~isempty(intersect(pos,black(:,1:2),'rows'))
                connection_area=get_connection_area(black(:,1:2),pos);
                [~,b,~]=intersect(black(:,1:2),connection_area,'rows');
                if all(black(b,3))
                    checher_board((black(b,1)+10)+((black(b,2)+10)-1).*19)=0;
                    black(b,:)=[];              
                end
            case ~isempty(intersect(pos,white(:,1:2),'rows'))
                connection_area=get_connection_area(white(:,1:2),pos);
                [~,w,~]=intersect(white(:,1:2),connection_area,'rows');
                if all(white(w,3))
                    checher_board((white(w,1)+10)+((white(w,2)+10)-1).*19)=0;
                    white(w,:)=[];              
                end
        end
    end

    function undo(~,~)
        if winner~=0
            winner=0;
            delete(findobj('tag','clues'));
            plotpostion=scatter(gca,postion(1,1),postion(1,2),150,'rx','tag','redcross');
            bout=bout-1;
            warehouse(end,:)=[];
            checher_board=warehouse{bout,1};
            turn=warehouse{bout,2};
            black=warehouse{bout,3};
            white=warehouse{bout,4};
        else
            if bout~=1
            bout=bout-1;
            warehouse(end,:)=[];
            checher_board=warehouse{bout,1};
            turn=warehouse{bout,2};
            black=warehouse{bout,3};
            white=warehouse{bout,4};
            end
        end
    end

    function redraw(~,~)
        set(plotblack,'XData',black(:,1),'YData',black(:,2))
        set(plotwhite,'XData',white(:,1),'YData',white(:,2))
        set(plotpostion,'XData',postion(:,1),'YData',postion(:,2))
    end

end
