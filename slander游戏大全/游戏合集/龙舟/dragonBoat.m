function dragonBoat


Mainfig=figure('units','pixels','position',[50 100 760 400],...
                       'Numbertitle','off','menubar','none','resize','off',...
                       'name','dragonBoat');
axes('parent',Mainfig,'position',[0 0 1 1],...
   'XLim', [0 760],...
   'YLim', [0 400],...
   'NextPlot','add',...
   'layer','bottom',...
   'Visible','on',...
   'YDir','reverse',...
   'XTick',[], ...
   'YTick',[]);
[bkg_C,~,~]=imread('river.png');
[boat_C,~,boat_Alp]=imread('boat.png');
[stone_C,~,stone_Alp]=imread('stone.png'); 

bkg_C=imresize(bkg_C,[360,720]);
DrawBkgHdl=image([0 760],[0 400],bkg_C);

stonePos=[600;870;1140;1410];
stonePos=[stonePos,randi([90,330],[4,1])];
for i=1:size(stonePos,1)
    drawStoneHdl(i)=image([stonePos(i,1)-39 stonePos(i,1)+39],[stonePos(i,2)-20 stonePos(i,2)+20],stone_C,'AlphaData',stone_Alp);
end

boatPos=[380,200];
DrawBoatHdl=image([boatPos(1)-75 boatPos(1)+75],[boatPos(2)-50 boatPos(2)+50],boat_C,'AlphaData',boat_Alp);

t=0;
tempBkg_C=[bkg_C,bkg_C];
fps = 20;
game = timer('ExecutionMode', 'FixedRate', 'Period',1/fps, 'TimerFcn', @dragongame);
start(game)

text(10,20,['已前进',num2str(t),'米'],'FontSize',14,'Color','w','tag','txt');

set(gcf,'WindowButtonMotionFcn',@moveBoat,'tag','mov')


    function dragongame(~,~)
        t=t+6;
        modt=mod(t,720);
        
        newBkg_C=tempBkg_C(:,1+modt:684+modt,:);
        set(DrawBkgHdl,'CData',newBkg_C) 
        
        stonePos(:,1)=stonePos(:,1)-20/3;
        stonePos(stonePos(:,1)<0,2)=randi([90,330],[1,1]);
        stonePos(stonePos(:,1)<0,1)=stonePos(stonePos(:,1)<0,1)+1080;
        for ii=1:size(stonePos,1)
            set(drawStoneHdl(ii),'XData',[stonePos(ii,1)-39 stonePos(ii,1)+39],...
                'YData',[stonePos(ii,2)-20 stonePos(ii,2)+20]);
        end
        set(findobj('tag','txt'),'String',['已前进',num2str(t),'米']);
        
        if judge(boatPos,stonePos)
            stop(game)
            set(gcf,'WindowButtonMotionFcn',[]); 
            text(50,200,'游戏结束','FontSize',54,'Color','w','tag','txt')
        end
    end

    function moveBoat(~,~)
        xy=get(gca,'CurrentPoint');
        temp_y=xy(1,2);
        temp_y(temp_y<100)=90;
        temp_y(temp_y>340)=330;
        boatPos=[380,temp_y];
        set(DrawBoatHdl,'YData',[temp_y-50 temp_y+50]);
    end

    function flag=judge(Bpos,Spos)
        flag1=abs(Bpos(1)-Spos(:,1))<80;
        flag2=abs((Bpos(2)+35)-Spos(:,2))<30;
        flag3=flag1&flag2;
        flag=any(flag3);
    end
end
