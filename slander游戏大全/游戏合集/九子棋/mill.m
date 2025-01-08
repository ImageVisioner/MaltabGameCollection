function mill
%图形界面初始化：
    axis equal
    axis([-3.5,3.5,-3.5,3.5])
    set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
    set(gca,'color',[0.9333 0.8275 0.6118])
    hold on
%按键函数初始化设置：
    set(gcf,'WindowButtonDownFcn',@buttondown)
global winner;
global turn;
global red;
global blue;
global red_store;
global blue_store;
global all_piece;
global checher_board
global postion;
global plotred;
global plotblue;
global plotallpiece1;
global plotallpiece2;
global plotpostion1;
global plotpostion2;
global pos_avilable;
global pos_arrivable;
global plotarrivable;
global pos_selected;
global pos_appropriated;
global nowaplace;

init()
    function init(~,~)
        %初始化前清除原有图像：
        delete(findobj('tag','piece'));
        delete(findobj('tag','select'));
        delete(findobj('type','line'));
        delete(findobj('type','patch'));
        
        l1=[1 1;1 -1;-1 -1;-1 1;1 1];
        plot(l1(:,1).*1.02,l1(:,2).*1.02,'color',[0 0 0],'linewidth',4);
        plot(l1(:,1).*2.02,l1(:,2).*2.02,'color',[0 0 0],'linewidth',4);
        plot(l1(:,1).*3.02,l1(:,2).*3.02,'color',[0 0 0],'linewidth',4);
        
        plot(l1(:,1).*1.07,l1(:,2).*1.07,'color',[0.5255 0.2745 0.2353],'linewidth',4);
        plot(l1(:,1).*2.07,l1(:,2).*2.07,'color',[0.5255 0.2745 0.2353],'linewidth',4);
        plot(l1(:,1).*3.07,l1(:,2).*3.07,'color',[0.5255 0.2745 0.2353],'linewidth',4);
        
        plot([0 0],[1 3],'color',[0.5255 0.2745 0.2353],'linewidth',4);
        plot([0 0],[-1 -3],'color',[0.5255 0.2745 0.2353],'linewidth',4);
        plot([1 3],[0 0],'color',[0.5255 0.2745 0.2353],'linewidth',4);
        plot([-1 -3],[0 0],'color',[0.5255 0.2745 0.2353],'linewidth',4);
        
        red=[0 0];red(1,:)=[];
        blue=[0 0];blue(1,:)=[];
        turn=[1 0];
        
        winner=0;
        
        postion=[0 0];
        red_store=9;
        blue_store=9;
        all_piece=[red;blue];
        checher_board=zeros(7,7);
        
        pos_avilable=[1 0;2 0;3 0;-1 0;-2 0;-3 0;...
                      0 1;0 2;0 3;0 -1;0 -2;0 -3;...
                      1 1;2 2;3 3;-1 -1;-2 -2;-3 -3;...
                      1 -1;2 -2;3 -3;-1 1;-2 2;-3 3];
        pos_appropriated=pos_avilable;
        pos_arrivable=[1 1];
        pos_arrivable(1,:)=[];
        pos_selected=[];
        nowaplace=[];

        %绘制函数初始化：
        plotred=scatter(gca,red(:,1),red(:,2),800,'k','filled','CData',[0.8157 0.4275 0.0588],'tag','piece');
        plotblue=scatter(gca,blue(:,1),blue(:,2),800,'w','filled','CData',[0 0.5255 0.9255],'tag','piece');
        plotallpiece1=scatter(gca,all_piece(:,1),all_piece(:,2),450,'CData',[0.75 0.75 0.75],'linewidth',1,'tag','piece');
        plotallpiece2=scatter(gca,all_piece(:,1),all_piece(:,2),810,'CData',[0 0 0],'linewidth',1,'tag','piece');
        plotpostion1=scatter(gca,postion(1,1),postion(1,2),60,'s','filled','CData',[1.0000 1.0000 0.9843],'tag','select');
        plotpostion2=scatter(gca,postion(1,1),postion(1,2),60,'s','CData',[0.6627 0.8706 1.0000],'linewidth',2,'tag','select');
        plotarrivable=scatter(gca,pos_arrivable(:,1),pos_arrivable(:,2),100,'c','CData',[0.5373 0.9059 0.3255],'linewidth',4,'tag','gc');
    end

    function buttondown(~,~)
        xy=get(gca,'CurrentPoint');
        xp=xy(1,2);yp=xy(1,1);
        pos=[yp,xp];
        pos=round(pos);
        if all(abs(pos)<=3)&&~isempty(intersect(pos,pos_avilable,'rows'))
            postion=pos;
            switch 1
                case turn(1)==1&&turn(2)==0
                    if red_store>0&&checher_board(postion(1)+4,postion(2)+4)==0
                        red_store=red_store-1;
                        [~,r,~]=intersect(pos_appropriated,postion,'rows');
                        pos_appropriated(r,:)=[];
                        red=[red;postion];
                        checher_board(postion(1)+4,postion(2)+4)=1;
                        all_piece=[red;blue];
                        if  (sum(checher_board(postion(1)+4,:))*(postion(1)~=0)...
                                +sum(checher_board(postion(1)+4,(postion(1)~=0)*[1 1 1]+(postion(1)==0)*((postion(2)>0)*(5:7)+(postion(2)<0)*(1:3))))*(postion(1)==0))==3||...
                            (sum(checher_board(:,postion(2)+4))*(postion(2)~=0)...
                                +sum(checher_board((postion(2)~=0)*[1 1 1]+(postion(2)==0)*((postion(1)>0)*(5:7)+(postion(1)<0)*(1:3)),postion(2)+4))*(postion(2)==0))==3
                            turn=[0 -1];
                            for i=1:size(blue,1)
                                if (sum(checher_board(blue(i,1)+4,:))*(blue(i,1)~=0)...
                                        +sum(checher_board(blue(i,1)+4,(blue(i,1)~=0)*[1 1 1]+(blue(i,1)==0)*((blue(i,2)>0)*(5:7)+(blue(i,2)<0)*(1:3))))*(blue(i,1)==0))==-3||...
                                    (sum(checher_board(:,blue(i,2)+4))*(blue(i,2)~=0)...
                                        +sum(checher_board((blue(i,2)~=0)*[1 1 1]+(blue(i,2)==0)*((blue(i,1)>0)*(5:7)+(blue(i,1)<0)*(1:3)),blue(i,2)+4))*(blue(i,2)==0))==-3
                                else
                                    pos_arrivable=[pos_arrivable;blue(i,:)];
                                end 
                            end
                            if isempty(pos_arrivable)
                                turn=[0 0];
                            end
                        else
                            turn=[mod(turn(1)+1,2),0];
                        end
                    else
                        if red_store==0
                            switch 1
                                case checher_board(postion(1)+4,postion(2)+4)==1
                                    if size(red,1)>3
                                        rows_search1=pos_appropriated(pos_appropriated(:,2)==postion(2),1);
                                        rows_search1=rows_search1(abs(rows_search1-postion(1))==min(abs(rows_search1-postion(1))));
                                        cols_search1=pos_appropriated(pos_appropriated(:,1)==postion(1),2);
                                        cols_search1=cols_search1(abs(cols_search1-postion(2))==min(abs(cols_search1-postion(2))));                               
                                        rows_search2=pos_avilable(pos_avilable(:,2)==postion(2),1);
                                        rows_search2(rows_search2==postion(1))=[];
                                        rows_search2=rows_search2(abs(rows_search2-postion(1))==min(abs(rows_search2-postion(1))));
                                        cols_search2=pos_avilable(pos_avilable(:,1)==postion(1),2);
                                        cols_search2(cols_search2==postion(2))=[];
                                        cols_search2=cols_search2(abs(cols_search2-postion(2))==min(abs(cols_search2-postion(2))));
                                        pos_arrivable1=[[rows_search1,postion(2).*ones(length(rows_search1),1)];...
                                            [postion(1).*ones(length(cols_search1),1),cols_search1]];
                                        pos_arrivable2=[[rows_search2,postion(2).*ones(length(rows_search2),1)];...
                                            [postion(1).*ones(length(cols_search2),1),cols_search2]];
                                        pos_arrivable=intersect(pos_arrivable1,pos_arrivable2,'rows');
                                    elseif size(red,1)==3
                                        pos_arrivable=pos_appropriated;                                        
                                    end
                                    nowaplace=postion;
                                case checher_board(postion(1)+4,postion(2)+4)==-1
                                    pos_arrivable(:,:)=[];
                                    nowaplace(:,:)=[];
                                case ~isempty(intersect(postion,pos_arrivable,'rows'))
                                    checher_board(nowaplace(1)+4,nowaplace(2)+4)=0;
                                    red(sum(abs(red-nowaplace),2)==0,:)=[];
                                    red=[red;postion];
                                    checher_board(postion(1)+4,postion(2)+4)=1;
                                    all_piece=[red;blue];    
                                    pos_appropriated(sum(abs(pos_appropriated-postion),2)==0,:)=[];
                                    pos_appropriated=[pos_appropriated;nowaplace];
                                    pos_arrivable(:,:)=[];                            
                                    if (sum(checher_board(postion(1)+4,:))*(postion(1)~=0)...
                                            +sum(checher_board(postion(1)+4,(postion(1)~=0)*[1 1 1]+(postion(1)==0)*((postion(2)>0)*(5:7)+(postion(2)<0)*(1:3))))*(postion(1)==0))==3||...
                                        (sum(checher_board(:,postion(2)+4))*(postion(2)~=0)...
                                            +sum(checher_board((postion(2)~=0)*[1 1 1]+(postion(2)==0)*((postion(1)>0)*(5:7)+(postion(1)<0)*(1:3)),postion(2)+4))*(postion(2)==0))==3
                                        turn=[0 -1];
                                        for i=1:size(blue,1)
                                            if (sum(checher_board(blue(i,1)+4,:))*(blue(i,1)~=0)...
                                                    +sum(checher_board(blue(i,1)+4,(blue(i,1)~=0)*[1 1 1]+(blue(i,1)==0)*((blue(i,2)>0)*(5:7)+(blue(i,2)<0)*(1:3))))*(blue(i,1)==0))==-3||...
                                                (sum(checher_board(:,blue(i,2)+4))*(blue(i,2)~=0)...
                                                    +sum(checher_board((blue(i,2)~=0)*[1 1 1]+(blue(i,2)==0)*((blue(i,1)>0)*(5:7)+(blue(i,1)<0)*(1:3)),blue(i,2)+4))*(blue(i,2)==0))==-3
                                            else
                                                pos_arrivable=[pos_arrivable;blue(i,:)];
                                            end
                                        end
                                        if isempty(pos_arrivable)
                                            turn=[0 0];
                                        end
                                    
                                    else
                                        turn=[mod(turn(1)+1,2),0];
                                    end
                            end
                        end
                    end
                                     
                case turn(1)==0&&turn(2)==0
                    if blue_store>0&&checher_board(postion(1)+4,postion(2)+4)==0
                        blue_store=blue_store-1;
                        [~,b,~]=intersect(pos_appropriated,postion,'rows');
                        pos_appropriated(b,:)=[];
                        blue=[blue;postion];
                        checher_board(postion(1)+4,postion(2)+4)=-1;
                        all_piece=[red;blue];
                        if (sum(checher_board(postion(1)+4,:))*(postion(1)~=0)...
                                +sum(checher_board(postion(1)+4,(postion(1)~=0)*[1 1 1]+(postion(1)==0)*((postion(2)>0)*(5:7)+(postion(2)<0)*(1:3))))*(postion(1)==0))==-3||...
                            (sum(checher_board(:,postion(2)+4))*(postion(2)~=0)...
                                +sum(checher_board((postion(2)~=0)*[1 1 1]+(postion(2)==0)*((postion(1)>0)*(5:7)+(postion(1)<0)*(1:3)),postion(2)+4))*(postion(2)==0))==-3
                            turn=[1 1];
                            for i=1:size(red,1)
                                if (sum(checher_board(red(i,1)+4,:))*(red(i,1)~=0)...
                                        +sum(checher_board(red(i,1)+4,(red(i,1)~=0)*[1 1 1]+(red(i,1)==0)*((red(i,2)>0)*(5:7)+(red(i,2)<0)*(1:3))))*(red(i,1)==0))==3||...
                                    (sum(checher_board(:,red(i,2)+4))*(red(i,2)~=0)...
                                        +sum(checher_board((red(i,2)~=0)*[1 1 1]+(red(i,2)==0)*((red(i,1)>0)*(5:7)+(red(i,1)<0)*(1:3)),red(i,2)+4))*(red(i,2)==0))==3
                                else
                                    pos_arrivable=[pos_arrivable;red(i,:)];
                                end
                            end
                            if isempty(pos_arrivable)
                                turn=[1 0];
                            end
                        else
                            turn=[mod(turn(1)+1,2),0];
                        end
                    else
                        if blue_store==0
                            switch 1
                                case checher_board(postion(1)+4,postion(2)+4)==-1
                                    if size(blue,1)>3
                                        rows_search1=pos_appropriated(pos_appropriated(:,2)==postion(2),1);
                                        rows_search1=rows_search1(abs(rows_search1-postion(1))==min(abs(rows_search1-postion(1))));
                                        cols_search1=pos_appropriated(pos_appropriated(:,1)==postion(1),2);
                                        cols_search1=cols_search1(abs(cols_search1-postion(2))==min(abs(cols_search1-postion(2))));
                                        rows_search2=pos_avilable(pos_avilable(:,2)==postion(2),1);
                                        rows_search2(rows_search2==postion(1))=[];
                                        rows_search2=rows_search2(abs(rows_search2-postion(1))==min(abs(rows_search2-postion(1))));
                                        cols_search2=pos_avilable(pos_avilable(:,1)==postion(1),2);
                                        cols_search2(cols_search2==postion(2))=[];
                                        cols_search2=cols_search2(abs(cols_search2-postion(2))==min(abs(cols_search2-postion(2))));                    
                                        pos_arrivable1=[[rows_search1,postion(2).*ones(length(rows_search1),1)];...
                                            [postion(1).*ones(length(cols_search1),1),cols_search1]];
                                        pos_arrivable2=[[rows_search2,postion(2).*ones(length(rows_search2),1)];...
                                            [postion(1).*ones(length(cols_search2),1),cols_search2]];
                                        pos_arrivable=intersect(pos_arrivable1,pos_arrivable2,'rows');
                                    elseif size(blue,1)==3
                                        pos_arrivable=pos_appropriated;
                                    end                               
                                        nowaplace=postion;
                                case checher_board(postion(1)+4,postion(2)+4)==1
                                    pos_arrivable(:,:)=[];
                                    nowaplace(:,:)=[];
                                case ~isempty(intersect(postion,pos_arrivable,'rows'))
                                    checher_board(nowaplace(1)+4,nowaplace(2)+4)=0;
                                    blue(sum(abs(blue-nowaplace),2)==0,:)=[];
                                    blue=[blue;postion];
                                    checher_board(postion(1)+4,postion(2)+4)=-1;
                                    all_piece=[red;blue];   
                                    pos_appropriated(sum(abs(pos_appropriated-postion),2)==0,:)=[];
                                    pos_appropriated=[pos_appropriated;nowaplace];
                                    pos_arrivable(:,:)=[];                
                                    if (sum(checher_board(postion(1)+4,:))*(postion(1)~=0)...
                                            +sum(checher_board(postion(1)+4,(postion(1)~=0)*[1 1 1]+(postion(1)==0)*((postion(2)>0)*(5:7)+(postion(2)<0)*(1:3))))*(postion(1)==0))==-3||...
                                       (sum(checher_board(:,postion(2)+4))*(postion(2)~=0)...
                                            +sum(checher_board((postion(2)~=0)*[1 1 1]+(postion(2)==0)*((postion(1)>0)*(5:7)+(postion(1)<0)*(1:3)),postion(2)+4))*(postion(2)==0))==-3
                                        turn=[1 1];
                                        for i=1:size(red,1)
                                            if (sum(checher_board(red(i,1)+4,:))*(red(i,1)~=0)...
                                                    +sum(checher_board(red(i,1)+4,(red(i,1)~=0)*[1 1 1]+(red(i,1)==0)*((red(i,2)>0)*(5:7)+(red(i,2)<0)*(1:3))))*(red(i,1)==0))==3||...
                                                (sum(checher_board(:,red(i,2)+4))*(red(i,2)~=0)...
                                                    +sum(checher_board((red(i,2)~=0)*[1 1 1]+(red(i,2)==0)*((red(i,1)>0)*(5:7)+(red(i,1)<0)*(1:3)),red(i,2)+4))*(red(i,2)==0))==3
                                            else
                                                pos_arrivable=[pos_arrivable;red(i,:)];
                                            end
                                        end
                                        if isempty(pos_arrivable)
                                            turn=[1 0];
                                        end
                                    else
                                        turn=[mod(turn(1)+1,2),0];
                                    end
                            end
                        end
                    end
                    
                    
                case turn(1)==1&&turn(2)==1
                    if ~isempty(intersect(postion,pos_arrivable,'rows'))
                        red(sum(abs(red-postion),2)==0,:)=[];
                        all_piece=[red;blue];
                        checher_board(postion(1)+4,postion(2)+4)=0;
                        pos_appropriated=[pos_appropriated;postion];
                        pos_arrivable(:,:)=[];
                        turn=[1 0];
                    end
                case turn(1)==0&&turn(2)==-1
                    if ~isempty(intersect(postion,pos_arrivable,'rows'))
                        blue(sum(abs(blue-postion),2)==0,:)=[];
                        all_piece=[red;blue];
                        checher_board(postion(1)+4,postion(2)+4)=0;
                        pos_appropriated=[pos_appropriated;postion];
                        pos_arrivable(:,:)=[];
                        turn=[0 0];
                    end
            end
        end
        redraw()
    end

    function redraw(~,~)
        set(plotred,'XData',red(:,1),'YData',red(:,2));
        set(plotblue,'XData',blue(:,1),'YData',blue(:,2));
        set(plotallpiece1,'XData',all_piece(:,1),'YData',all_piece(:,2));
        set(plotallpiece2,'XData',all_piece(:,1),'YData',all_piece(:,2));
        set(plotpostion1,'XData',postion(1,1),'YData',postion(1,2));
        set(plotpostion2,'XData',postion(1,1),'YData',postion(1,2));
        set(plotarrivable,'XData',pos_arrivable(:,1),'YData',pos_arrivable(:,2));
        judge()     
    end
    function judge(~,~)
        switch 1
            case red_store==0&&(size(red,1)==2||(cantmove(red)&&turn(1)==1&&turn(2)==0&&size(red,1)~=3)),winner=-1;
            case blue_store==0&&(size(blue,1)==2||(cantmove(blue)&&turn(1)==0&&turn(2)==0&&size(blue,1)~=3)),winner=1;
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
    function boolean=cantmove(mat)
        pa=[0 0];
        pa(1,:)=[];
        for i=1:size(mat,1)
            rows_search1=pos_appropriated(pos_appropriated(:,2)==mat(i,2),1);
            rows_search1=rows_search1(abs(rows_search1-mat(i,1))==min(abs(rows_search1-mat(i,1))));
            cols_search1=pos_appropriated(pos_appropriated(:,1)==mat(i,1),2);
            cols_search1=cols_search1(abs(cols_search1-mat(i,2))==min(abs(cols_search1-mat(i,2))));
            rows_search2=pos_avilable(pos_avilable(:,2)==mat(i,2),1);
            rows_search2(rows_search2==mat(i,1))=[];
            rows_search2=rows_search2(abs(rows_search2-mat(i,1))==min(abs(rows_search2-mat(i,1))));
            cols_search2=pos_avilable(pos_avilable(:,1)==mat(i,1),2);
            cols_search2(cols_search2==mat(i,2))=[];
            cols_search2=cols_search2(abs(cols_search2-mat(i,2))==min(abs(cols_search2-mat(i,2))));                    
            pos_arrivable1=[[rows_search1,mat(i,2).*ones(length(rows_search1),1)];...
                [mat(i,1).*ones(length(cols_search1),1),cols_search1]];
            pos_arrivable2=[[rows_search2,mat(i,2).*ones(length(rows_search2),1)];...
                [mat(i,1).*ones(length(cols_search2),1),cols_search2]];
            pa=[pa;intersect(pos_arrivable1,pos_arrivable2,'rows')];            
        end
        boolean=isempty(pa);
    end


    

end
 