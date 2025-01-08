function air_battle2
global game;
global bkg;
global line;
global planeown;
global planeopp;

global bulletlist;
global bullet

global ControlTimer;

global Mainfig;
global Mainaxes;

global DrawBkgHdl;
global DrawLineHdl;
global DrawPlaneOwnHdl;
global DrawPlaneOppHdl;
global DrawBulletHdl;
init()
    function init(~,~)
        ControlTimer=0;
        bulletlist=[];
        
        bkg.CData=imread('bkg1.jpg');
        bkg.CData(:,:,1)=flipud(bkg.CData(:,:,1));
        bkg.CData(:,:,2)=flipud(bkg.CData(:,:,2));
        bkg.CData(:,:,3)=flipud(bkg.CData(:,:,3));
        bkg.Size=size(bkg.CData);
        
        [line.CData,~,line.AlpData]=imread('line2.png');
        line.Size=size(line.CData);
        
        
        [planeown.CData,~,planeown.AlpData]=imread('planeown.png');
        planeown.AlpData=flipud(planeown.AlpData);
        planeown.CData(:,:,1)=flipud(planeown.CData(:,:,1));
        planeown.CData(:,:,2)=flipud(planeown.CData(:,:,2));
        planeown.CData(:,:,3)=flipud(planeown.CData(:,:,3));
        planeown.Size=size(planeown.CData);
        planeown.Pos=[bkg.Size(2)/2-planeown.Size(2)/2,40];
        
        [planeopp.CData,~,planeopp.AlpData]=imread('planeopp.png');
        planeopp.AlpData=flipud(planeopp.AlpData);
        planeopp.CData(:,:,1)=flipud(planeopp.CData(:,:,1));
        planeopp.CData(:,:,2)=flipud(planeopp.CData(:,:,2));
        planeopp.CData(:,:,3)=flipud(planeopp.CData(:,:,3));
        planeopp.Size=size(planeopp.CData);
        planeopp.Pos=[bkg.Size(2)/2-planeopp.Size(2)/2,750];
        
        for i=1:6
            [temp_CData,~,temp_AlpData]=imread(['bullet',num2str(i),'.png']);
            bullet.(['CData',num2str(i)])(:,:,1)=flipud(temp_CData(:,:,1));
            bullet.(['CData',num2str(i)])(:,:,2)=flipud(temp_CData(:,:,2));
            bullet.(['CData',num2str(i)])(:,:,3)=flipud(temp_CData(:,:,3));
            bullet.(['AlpData',num2str(i)])=flipud(temp_AlpData);
            bullet.Size(i,:)=size(temp_CData);
        end
        
        Mainfig=figure('units','pixels','position',[550 50 bkg.Size(1,[2,1])./1.2],...
                       'Numbertitle','off','menubar','none','resize','off',...
                       'name','air battle2.0');
        Mainaxes=axes('parent',Mainfig,'position',[0 0 1 1],...
                    'XLim', [0 bkg.Size(2)],...
                    'YLim', [0 bkg.Size(1)],...
                    'NextPlot','add',...
                    'layer','bottom',...
                    'Visible','on',...
                    'XTick',[], ...
                    'YTick',[]);
       DrawBkgHdl=image([0 bkg.Size(2)],[0 bkg.Size(1)],bkg.CData);
       DrawLineHdl=image([0 bkg.Size(2)],[0 line.Size(1)]+180,line.CData,'alphaData',line.AlpData.*0.5);
       DrawPlaneOwnHdl=image([0 planeown.Size(2)]+planeown.Pos(1),[0 planeown.Size(1)]+planeown.Pos(2),...
                             planeown.CData,...
                             'alphaData',planeown.AlpData);
       DrawPlaneOppHdl=image([0 planeopp.Size(2)]+planeopp.Pos(1),[0 planeopp.Size(1)]+planeopp.Pos(2),...
                             planeopp.CData,...
                             'alphaData',planeopp.AlpData);
       
       fps = 20;                                    
       game = timer('ExecutionMode', 'FixedRate', 'Period',1/fps, 'TimerFcn', @airgame);
       set(gcf,'tag','co','CloseRequestFcn',@clo);
       
       
       function clo(~,~),stop(game),delete(findobj('tag','co'));clf,close,end 
       
       
       start(game)
       set(gcf,'WindowButtonMotionFcn',@planown_move)
       set(gcf,'WindowButtonDownFcn',@planown_shoot)
       set(gcf,'KeyPressFcn',@shoot_by_key)  
    end
% 知乎         : slandarer
% CSDN       : slandarer
% 公众号    : slandarer随笔
    function airgame(~,~)
        ControlTimer=ControlTimer+1;
        temp_bkg=[bkg.CData;bkg.CData];
        set(DrawBkgHdl,'CData',...
            temp_bkg(mod(ControlTimer,bkg.Size(1))+1:mod(ControlTimer,bkg.Size(1))+bkg.Size(1),:,:)); 
        
        planeopp.Pos(2)=planeopp.Pos(2)-1.5;
        set(DrawPlaneOppHdl,'XData',[0 planeopp.Size(2)]+planeopp.Pos(1),'YData',[0 planeopp.Size(1)]+planeopp.Pos(2));
        if ~isempty(bulletlist)
            for i=length(bulletlist):-1:1
                temp_num=bulletlist(i);
                set(DrawBulletHdl(temp_num),'YData',get(DrawBulletHdl(temp_num),'YData')+4);
                temp_y=get(DrawBulletHdl(temp_num),'YData');
                if temp_y(1)>766
                    bulletlist(bulletlist==temp_num)=[];
                    delete(DrawBulletHdl(temp_num));
                else
                    temp_judge_pos(1)=mean(get(DrawBulletHdl(temp_num),'XData'));
                    temp_judge_pos(2)=mean(get(DrawBulletHdl(temp_num),'YData'))-20;
                    if(planeopp.Pos(1)<=temp_judge_pos(1))&&...
                      (temp_judge_pos(1)<=planeopp.Size(2)+planeopp.Pos(1))&&...
                      (planeopp.Pos(2)<=temp_judge_pos(2))&&...
                      (temp_judge_pos(2)<=planeopp.Size(1)+planeopp.Pos(2))
                        bulletlist(bulletlist==temp_num)=[];
                        delete(DrawBulletHdl(temp_num));
                        planeopp.Pos=[randi(floor(bkg.Size(2)-planeopp.Size(2)/2)),750];
                    end
                end
            end
        end
        judge()
    end
% 知乎         : slandarer
% CSDN       : slandarer
% 公众号    : slandarer随笔
    function planown_move(~,~)
        xy=get(gca,'CurrentPoint');
        temp_x=xy(1,1);%temp_y=xy(1,2);
        planeown.Pos(1)=temp_x-planeown.Size(2)/2;
        set(DrawPlaneOwnHdl,'XData',[0 planeown.Size(2)]+planeown.Pos(1),...
                            'YData',[0 planeown.Size(1)]+planeown.Pos(2)); 
    end

    function planown_shoot(~,~)
        temp_num=getMax(bulletlist);
        DrawBulletHdl(temp_num)=image([0 bullet.Size(1,2)]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(1,2)/2,...
                                      [0 bullet.Size(1,1)]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData1,...
                             'alphaData',bullet.AlpData1);   
        bulletlist=[bulletlist;temp_num];
    end

    function shoot_by_key(~,event)
        switch event.Key
            case 'a'
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image([0 bullet.Size(1,2)]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(1,2)/2,...
                                      [0 bullet.Size(1,1)]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData1,...
                             'alphaData',bullet.AlpData1);   
                bulletlist=[bulletlist;temp_num];
            case 's'
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image(30+[0 bullet.Size(2,2)/2]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(2,2)/4,...
                                      [0 bullet.Size(2,1)/2]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData2,...
                             'alphaData',bullet.AlpData2);   
                bulletlist=[bulletlist;temp_num];
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image(-30+[0 bullet.Size(2,2)/2]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(2,2)/4,...
                                      [0 bullet.Size(2,1)/2]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData2,...
                             'alphaData',bullet.AlpData2);   
                bulletlist=[bulletlist;temp_num];
            case 'd'
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image([0 bullet.Size(1,2)]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(1,2)/2,...
                                      [0 bullet.Size(1,1)]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData1,...
                             'alphaData',bullet.AlpData1);  
                bulletlist=[bulletlist;temp_num];
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image([0 bullet.Size(3,2)]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(3,2)/2,...
                                      30+[0 bullet.Size(3,1)]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData3,...
                             'alphaData',bullet.AlpData3);   
                bulletlist=[bulletlist;temp_num];
            case 'f'
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image(30+[0 bullet.Size(4,2)/2]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(4,2)/4,...
                                      30+[0 bullet.Size(4,1)/2]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData4,...
                             'alphaData',bullet.AlpData4);   
                bulletlist=[bulletlist;temp_num];
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image(-30+[0 bullet.Size(4,2)/2]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(4,2)/4,...
                                      30+[0 bullet.Size(4,1)/2]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData4,...
                             'alphaData',bullet.AlpData4);   
                bulletlist=[bulletlist;temp_num];
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image(30+[0 bullet.Size(4,2)/2]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(4,2)/4,...
                                      [0 bullet.Size(4,1)/2]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData4,...
                             'alphaData',bullet.AlpData4);   
                bulletlist=[bulletlist;temp_num];
                temp_num=getMax(bulletlist);
                DrawBulletHdl(temp_num)=image(-30+[0 bullet.Size(4,2)/2]+planeown.Pos(1)+planeown.Size(2)/2-bullet.Size(4,2)/4,...
                                      [0 bullet.Size(4,1)/2]+planeown.Pos(2)+planeown.Size(1)/2,...
                             bullet.CData4,...
                             'alphaData',bullet.AlpData4);   
                bulletlist=[bulletlist;temp_num];
        end
        
        
    end

    function judge(~,~)
        temp_y=min(get(DrawPlaneOppHdl,'YData'));
        if temp_y<=180
            stop(game)
            set(gcf,'WindowButtonMotionFcn',[])
            set(gcf,'WindowButtonDownFcn',[])
            set(gcf,'KeyPressFcn',[]) 
            buttonName=questdlg('You lose. What do you mean to do?','You lose','close','restart','close');
            switch buttonName
                case 'restart',delete(gcf),init()
                case 'close',delete(gcf)
            end
        end
    end

% 知乎         : slandarer
% CSDN       : slandarer
% 公众号    : slandarer随笔
%==========================================================================
    function num=getMax(list)
        if isempty(list)
            num=1;
        else
            num=max(list)+1;
        end
    end
end