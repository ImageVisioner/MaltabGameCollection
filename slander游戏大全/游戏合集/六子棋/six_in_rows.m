function six_in_rows
%图形界面初始化： 
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
global alternate;
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
        winner=0;postion=[0 0];turn=2;
        black=[20,20];white=[-20,-20];
        black(1,:)=[];white(1,:)=[];
        checher_board=zeros(19,19);
        alternate=[1 1 0 0];
        
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
        if checher_board(postion(1)+10,postion(2)+10)==0&&winner==0
            switch alternate(turn)
                case 1
                    checher_board(postion(1)+10,postion(2)+10)=1;
                    black=[black;postion];                        
                case 0
                    checher_board(postion(1)+10,postion(2)+10)=-1;
                    white=[white;postion];        
            end
            turn=mod(turn,4)+1;
        end     
    end

    function redraw(~,~)
        if winner==0
            set(plotblack,'XData',black(:,1),'YData',black(:,2))
            set(plotwhite,'XData',white(:,1),'YData',white(:,2))
            set(plotpostion,'XData',postion(:,1),'YData',postion(:,2))
        end
        judge()
    end

    function judge(~,~)
        temp_mat_1=checher_board+[zeros(19,1),checher_board(:,1:18)]...
                                +[zeros(19,2),checher_board(:,1:17)]...
                                +[zeros(19,3),checher_board(:,1:16)]...
                                +[zeros(19,4),checher_board(:,1:15)]...
                                +[zeros(19,5),checher_board(:,1:14)];
        temp_mat_2=checher_board+[zeros(1,19);checher_board(1:18,:)]...
                                +[zeros(2,19);checher_board(1:17,:)]...
                                +[zeros(3,19);checher_board(1:16,:)]...
                                +[zeros(4,19);checher_board(1:15,:)]...
                                +[zeros(5,19);checher_board(1:14,:)];
        temp_mat_3=checher_board+[zeros(1,19);[zeros(18,1),checher_board(1:18,1:18)]]...
                                +[zeros(2,19);[zeros(17,2),checher_board(1:17,1:17)]]...
                                +[zeros(3,19);[zeros(16,3),checher_board(1:16,1:16)]]...
                                +[zeros(4,19);[zeros(15,4),checher_board(1:15,1:15)]]...
                                +[zeros(5,19);[zeros(14,5),checher_board(1:14,1:14)]];
        temp_mat_4=checher_board+[[zeros(18,1),checher_board(2:end,1:18)];zeros(1,19)]...
                                +[[zeros(17,2),checher_board(3:end,1:17)];zeros(2,19)]...
                                +[[zeros(16,3),checher_board(4:end,1:16)];zeros(3,19)]...
                                +[[zeros(15,4),checher_board(5:end,1:15)];zeros(4,19)]...
                                +[[zeros(14,5),checher_board(6:end,1:14)];zeros(5,19)];
        switch 1
            case any(any(temp_mat_1==6))||any(any(temp_mat_1==-6)),winner=any(any(temp_mat_1==6))-any(any(temp_mat_1==-6));
                [pos_x,pos_y]=find(temp_mat_1(:,:)==winner*6);endpoint=[pos_x(1),pos_y(1);pos_x(1),pos_y(1)]+[0 0;0 -5];
            case any(any(temp_mat_2==6))||any(any(temp_mat_2==-6)),winner=any(any(temp_mat_2==6))-any(any(temp_mat_2==-6));
                [pos_x,pos_y]=find(temp_mat_2(:,:)==winner*6);endpoint=[pos_x(1),pos_y(1);pos_x(1),pos_y(1)]+[0 0;-5 0];
            case any(any(temp_mat_3==6))||any(any(temp_mat_3==-6)),winner=any(any(temp_mat_3==6))-any(any(temp_mat_3==-6));
                [pos_x,pos_y]=find(temp_mat_3(:,:)==winner*6);endpoint=[pos_x(1),pos_y(1);pos_x(1),pos_y(1)]+[0 0;-5 -5];
            case any(any(temp_mat_4==6))||any(any(temp_mat_4==-6)),winner=any(any(temp_mat_4==6))-any(any(temp_mat_4==-6));
                [pos_x,pos_y]=find(temp_mat_4(:,:)==winner*6);endpoint=[pos_x(1),pos_y(1);pos_x(1),pos_y(1)]+[0 0;5 -5];
        end
        if winner~=0
            plot(endpoint(:,1)-10,endpoint(:,2)-10,'color',[0.8 0 0],'linewidth',2,'tag','clues')
            delete(findobj('tag','redcross'))
        end
    end

    function undo(~,~)
        if winner~=0
            winner=0;
            delete(findobj('tag','clues'));
            plotpostion=scatter(gca,postion(1,1),postion(1,2),150,'rx','tag','redcross');
        end
        if any(any(checher_board~=0))
            turn=mod(turn+2,4)+1;
            switch 1
                case turn==1||turn==2,checher_board(black(end,1)+10,black(end,2)+10)=0;black(end,:)=[];
                case turn==3||turn==4,checher_board(white(end,1)+10,white(end,2)+10)=0;white(end,:)=[];
            end
        end
    end
        


end
