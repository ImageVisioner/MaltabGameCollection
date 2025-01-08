function snake  
%axis set..............................................................
axis equal
len=40;
axis(0.5+[0,len,0,len])
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
set(gca,'color','k')
hold on
%snake and food begining set...........................................
snaketop=[5,5;4.5,5];
body=[5,5;4.5,5;4,5;3.5,5;3,5;2.5,5];
food=[10,10];
direction=[1,0];
long=6;
plotsnake=scatter(gca,body(:,1),body(:,2),120,'w','filled');
plotfood=scatter(gca,food(1),food(2),120,'w','filled');
%timer set.............................................................
set(gcf,'WindowButtonMotionFcn',@snakefcn)
fps = 8;
game = timer('ExecutionMode', 'FixedRate', 'Period',1/fps, 'TimerFcn', @snakegame);
start(game)
%..................................................................................
set(gcf,'tag','co','CloseRequestFcn',@clo);
    function clo(~,~)
        stop(game)
        delete(findobj('tag','co'));
        clf
        close
    end
    function snakegame(~,~)
        snaketop=[body(1,:)+direction;body(1,:)+1/2*direction];
        snaketop(snaketop>len)=snaketop(snaketop>len)-len;
        snaketop(snaketop<1)=snaketop(snaketop<1)+len;
        body=[snaketop;body];
        body(long+1:end,:)=[];
        if (snaketop(1,1)-food(1))^2+(snaketop(1,2)-food(2))^2<1
            long = long + 2;
            food = randi(len, [1, 2]);
        end
        set(plotfood,'XData',food(1),'YData',food(2))
        set(plotsnake,'XData',body(:,1),'YData',body(:,2))
    end
    function snakefcn(~,~)
        xy=get(gca,'CurrentPoint');
        x=xy(1,1);y=xy(1,2);
        dir=[x-body(1,1),y-body(1,2)];
        dis=sqrt((x-body(1,1))^2+(y-body(1,2))^2);
        direction=dir/dis;
    end
end
