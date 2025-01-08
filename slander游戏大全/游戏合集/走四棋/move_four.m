function move_four
    axis equal
    axis([0.5,4.5,0.5,4.5])
    set(gca,'xtick',[],'ytick',[],'xcolor',[0.95 0.95 0.95],'ycolor',[0.95 0.95 0.95])
    set(gca,'color',[0.95 0.95 0.95])
    hold on
    %按键函数初始化设置：
    set(gcf,'WindowButtonDownFcn',@buttondown)
global red;
global blue;
global winner;
global turn;
global pos_arrivable;
global checher_board;
global postion;
global all_piece;
global plotred;
global plotblue;
global plotallpiece1;
global plotallpiece2;
global plotarrivable;
global plotpostion1;
global plotpostion2;
global nowaplace;
init()
    function init(~,~)
        delete(findobj('tag','piece'));
        delete(findobj('tag','select'));
        delete(findobj('type','line'));
        delete(findobj('type','patch'));
        
        l1=[1 1;1 4;4 4;4 1;1 1];
        l2=[1 2;4 2];
        plot(l1(:,1),l1(:,2),'color',[0 0 0],'linewidth',4);
        plot(l2(:,1),l2(:,2),'color',[0 0 0],'linewidth',4);
        plot(l2(:,2),l2(:,1),'color',[0 0 0],'linewidth',4);
        plot(l2(:,1),l2(:,2)+1,'color',[0 0 0],'linewidth',4);
        plot(l2(:,2)+1,l2(:,1),'color',[0 0 0],'linewidth',4);
        
        red=[1 1;1 2;1 3;1 4];
        blue=[4 1;4 2;4 3;4 4];
        all_piece=[red;blue];
        winner=0;turn=1;
        checher_board=zeros(4,4);
        checher_board(red(:,1)+(red(:,2)-1)*4)=1;
        checher_board(blue(:,1)+(blue(:,2)-1)*4)=-1;
        postion=[1 1];
        postion(1,:)=[];
        pos_arrivable=[1 1];
        pos_arrivable(1,:)=[];
        
        plotred=scatter(gca,red(:,1),red(:,2),1800,'k','filled','CData',[0.8157 0.4275 0.0588],'tag','piece');
        plotblue=scatter(gca,blue(:,1),blue(:,2),1800,'w','filled','CData',[0 0.5255 0.9255],'tag','piece');
        plotallpiece1=scatter(gca,all_piece(:,1),all_piece(:,2),1000,'CData',[0.75 0.75 0.75],'linewidth',1,'tag','piece');
        plotallpiece2=scatter(gca,all_piece(:,1),all_piece(:,2),1850,'CData',[0 0 0],'linewidth',1,'tag','piece');
        plotpostion1=scatter(gca,postion(:,1),postion(:,2),60,'s','filled','CData',[1.0000 1.0000 0.9843],'tag','select');
        plotpostion2=scatter(gca,postion(:,1),postion(:,2),60,'s','CData',[0.6627 0.8706 1.0000],'linewidth',2,'tag','select');
        plotarrivable=scatter(gca,pos_arrivable(:,1),pos_arrivable(:,2),100,'c','CData',[0.5373 0.9059 0.3255],'linewidth',4,'tag','gc');
    end

    function buttondown(~,~)
        xy=get(gca,'CurrentPoint');
        xp=xy(1,2);yp=xy(1,1);
        pos=[yp,xp];
        pos=round(pos);
        if all(1<=pos)&&all(pos<=4)&&winner==0
            postion=pos;
            switch 1
                case checher_board(postion(1),postion(2))==0&&isempty(intersect(postion,pos_arrivable,'rows'))
                    pos_arrivable(:,:)=[];
                case ~isempty(intersect(postion,red,'rows'))
                    switch turn
                        case 1,pos_arrivable=get_arrivable(postion);nowaplace=postion;
                        case 0,pos_arrivable(:,:)=[];
                    end
                case ~isempty(intersect(postion,blue,'rows'))
                    switch turn
                        case 1,pos_arrivable(:,:)=[];
                        case 0,pos_arrivable=get_arrivable(postion);nowaplace=postion;
                    end
                case ~isempty(intersect(postion,pos_arrivable,'rows'))
                    switch turn 
                        case 1
                            red(sum(abs(red-nowaplace),2)==0,:)=postion;
                            checher_board(nowaplace(1),nowaplace(2))=0;
                            checher_board(postion(1),postion(2))=1;   
                            delete_pos=eat(postion,turn);
                            if ~isempty(delete_pos)
                                [~,b,~]=intersect(blue,delete_pos,'rows');
                                blue(b,:)=[];
                                checher_board(delete_pos(1)+(delete_pos(2)-1).*4)=0;
                            end
                            all_piece=[red;blue];
                            turn=mod(turn+1,2);
                            pos_arrivable(:,:)=[];                      
                        case 0
                            blue(sum(abs(blue-nowaplace),2)==0,:)=postion;
                            checher_board(nowaplace(1),nowaplace(2))=0;
                            checher_board(postion(1),postion(2))=-1;
                            delete_pos=eat(postion,turn);
                            if ~isempty(delete_pos)
                                [~,b,~]=intersect(red,delete_pos,'rows');
                                red(b,:)=[];
                                checher_board(delete_pos(1)+(delete_pos(2)-1).*4)=0;
                            end
                            all_piece=[red;blue];
                            turn=mod(turn+1,2);
                            pos_arrivable(:,:)=[];
                    end
            end
        end
        redraw()
    end

    function arrivable_list=get_arrivable(pos)
        pos_around=[pos;pos+[1 0];pos+[0 1];pos+[-1 0];pos+[0 -1]];
        pos_around(pos_around(:,1)>4|pos_around(:,1)<1,:)=[];
        pos_around(pos_around(:,2)>4|pos_around(:,2)<1,:)=[];
        arrivable_list=pos_around(checher_board(pos_around(:,1)+(pos_around(:,2)-1).*4)==0,:);
    end

    function delete_pos=eat(pos,turn)
        switch turn
            case 0,turn=-1;
        end
        delete_pos1=[0 0];delete_pos1(1,:)=[];
        delete_pos2=[0 0];delete_pos2(1,:)=[];
        delete_pos3=[0 0];delete_pos3(1,:)=[];
        delete_pos4=[0 0];delete_pos4(1,:)=[];
        delete_pos5=[0 0];delete_pos5(1,:)=[];
        delete_pos6=[0 0];delete_pos6(1,:)=[];
        sums_this_row=sum(checher_board(pos(1),:)==-turn);
        sums_this_col=sum(checher_board(:,pos(2))==-turn);
        if pos(1)+2<=4
            if checher_board(pos(1)+1,pos(2))==turn&&...
               checher_board(pos(1)+2,pos(2))==-turn&&...
               sums_this_col==1
                delete_pos1=[pos(1)+2,pos(2)];
            end
        end
        if pos(1)-2>=1
            if checher_board(pos(1)-1,pos(2))==turn&&...
               checher_board(pos(1)-2,pos(2))==-turn&&...
               sums_this_col==1
                delete_pos2=[pos(1)-2,pos(2)];
            end
        end
        if pos(2)+2<=4
            if checher_board(pos(1),pos(2)+1)==turn&&...
               checher_board(pos(1),pos(2)+2)==-turn&&...
               sums_this_row==1
                delete_pos3=[pos(1),pos(2)+2];
            end
        end
        if pos(2)-2>=1
            if checher_board(pos(1),pos(2)-1)==turn&&...
               checher_board(pos(1),pos(2)-2)==-turn&&...
               sums_this_row==1
                delete_pos4=[pos(1),pos(2)-2];
            end
        end
        if pos(1)+1<=4&&pos(1)-1>=1
            if checher_board(pos(1)+1,pos(2))==turn&&...
               checher_board(pos(1)-1,pos(2))==-turn&&...
               sums_this_col==1
                delete_pos5=[pos(1)-1,pos(2)];
            end
            if checher_board(pos(1)+1,pos(2))==-turn&&...
               checher_board(pos(1)-1,pos(2))==turn&&...
               sums_this_col==1
                delete_pos5=[pos(1)+1,pos(2)];
            end  
        end
        if pos(2)+1<=4&&pos(2)-1>=1
            if checher_board(pos(1),pos(2)+1)==turn&&...
               checher_board(pos(1),pos(2)-1)==-turn&&...
               sums_this_row==1
                delete_pos6=[pos(1),pos(2)-1];
            end
            if checher_board(pos(1),pos(2)+1)==-turn&&...
               checher_board(pos(1),pos(2)-1)==turn&&...
               sums_this_row==1
                delete_pos6=[pos(1),pos(2)+1];
            end  
        end
        delete_pos=[delete_pos1;delete_pos2;delete_pos3;delete_pos4;delete_pos5;delete_pos6];
    end

    function redraw(~,~)
        set(plotred,'XData',red(:,1),'YData',red(:,2));
        set(plotblue,'XData',blue(:,1),'YData',blue(:,2));
        set(plotallpiece1,'XData',all_piece(:,1),'YData',all_piece(:,2));
        set(plotallpiece2,'XData',all_piece(:,1),'YData',all_piece(:,2));
        set(plotpostion1,'XData',postion(:,1),'YData',postion(1,2));
        set(plotpostion2,'XData',postion(:,1),'YData',postion(1,2));
        set(plotarrivable,'XData',pos_arrivable(:,1),'YData',pos_arrivable(:,2));
        judge()
    end

    function judge(~,~)
        switch 1
            case size(red,1)<=2,winner=-1;
            case size(blue,1)<=2,winner=1;
        end
        switch winner
            case 1
                buttonName1=questdlg('红方胜利','red win','关闭','重新开始','关闭');
                if isempty(buttonName1),buttonName1='end';end
                if strcmp(buttonName1,'重新开始'),init();
                elseif strcmp(buttonName1,'关闭'),close;
                end
            case -1
                buttonName1=questdlg('蓝方胜利','blue win','关闭','重新开始','关闭');
                if isempty(buttonName1),buttonName1='end';end
                if strcmp(buttonName1,'重新开始'),init();
                elseif strcmp(buttonName1,'关闭'),close;
                end
        end
    end


end
 