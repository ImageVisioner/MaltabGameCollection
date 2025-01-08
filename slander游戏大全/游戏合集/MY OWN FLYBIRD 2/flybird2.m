function flybird2

%============================Data import===================================
sprites=load('sprites.mat');
%==========================Global variable=================================
global Bird;
global Tub;
global Bkg;
global Floor;
global TubGap;

global RES;
global MainFigurePos;
global MainFigureSize;
global BkgAxesSize;
global FloorAxesSize;

global MainFigure;
global BkgAxes;
global FloorAxes;
global DrawBkgHdl;
global DrawTubGap1Hdl;
global DrawTubGap2Hdl;
global DrawFloorHdl;
global DrawBirdHdl;

global BeginInfoHdl;
global ScoreInfoBackHdl;
global ScoreInfoForeHdl;
global GameOverInfoHdl;
global BestScoreInfoHdl;
global YourScoreInfoHdl;

global gap1_init_xpos;
global gap2_init_xpos;
global gap1_xpos;
global gap2_xpos;
global gap1_hight;
global gap2_hight;

global xgrid;
global ygrid;

global game;
global moment;
global lastmoment;
global begin;
global begintime;
global gravity;
global keyrelease;
global gameover;
global score;
global havepassed;
global timecounter;
init()

 
%==========================================================================
function FlyBirdGame(~,~)
    moment=toc(timecounter);
    redraw()
    GameOver()  
    lastmoment=moment;
end
%==========================================================================
    function GameOverFilm(~,~)
        while 1
            pause(0.01)
            Bird.angle=pi/2;
            Bird.pos(2)=Bird.pos(2)-1;
            [temp_xgrid,temp_ygrid]=meshgrid(1:17,1:13);
            cosa = cos(Bird.angle);
            sina = sin(Bird.angle);
            xgrid = cosa .* temp_xgrid + sina .* temp_ygrid;
            ygrid = cosa .* temp_ygrid - sina .* temp_xgrid;
            set(DrawBirdHdl,'XData',xgrid+Bird.pos(1),...
                            'YData',ygrid+Bird.pos(2),...
                            'CData',flipud(Bird.CDataNan(:,:,:,mod(floor(moment*10),3)+1)));  
            if Bird.pos(2)<17
                break
            end
        end
    end
%==========================================================================
    function GameOver(~,~)
        if Bird.pos(2)<18 ,gameover=1;end
        temp_xgrid=xgrid;
        temp_ygrid=ygrid;
        temp_xgrid(isnan(Bird.CDataNan(:,:,1,1)))=0;
        temp_ygrid(isnan(Bird.CDataNan(:,:,1,1)))=0;
        if any(((temp_xgrid+Bird.pos(1)>gap1_xpos)+...
                (temp_xgrid+Bird.pos(1)<(gap1_xpos+26))+...
                (temp_ygrid+Bird.pos(2)>(gap1_hight+167))+...
                (temp_ygrid+Bird.pos(2)<(gap1_hight+129)))==3)
            gameover=1;
        end
        if any(((temp_xgrid+Bird.pos(1)>gap2_xpos)+...
                (temp_xgrid+Bird.pos(1)<(gap2_xpos+26))+...
                (temp_ygrid+Bird.pos(2)>(gap2_hight+167))+...
                (temp_ygrid+Bird.pos(2)<(gap2_hight+129)))==3)
            gameover=1;
        end
        if gameover==1          
            stop(game);
            set(GameOverInfoHdl,'visible','on');
            set(YourScoreInfoHdl,'visible','on','string',['Score : ',num2str(score)]);
            set(BestScoreInfoHdl,'visible','on','string',[' Best  : ',num2str(max(score,sprites.Best))]);
            set(ScoreInfoBackHdl,'visible','off');
            set(ScoreInfoForeHdl,'visible','off');
            Best=max(score,sprites.Best);
            save sprites.mat Best -append
            GameOverFilm();
        end
    end
%==========================================================================
    function redraw(~,~)
        passedpath=floor((moment-begintime)*50);
        set(DrawFloorHdl,'CData',flipud(Floor.CData(1:56,(1:144)+mod(passedpath,23),:,1)))
        if begin==0
            [xgrid,ygrid]=meshgrid(1:17,1:13);
            set(DrawBirdHdl,'XData',xgrid+Bird.pos(1),...
                            'YData',ygrid+Bird.pos(2)+4*sin(moment*8),...
                            'CData',flipud(Bird.CDataNan(:,:,:,mod(floor(moment*10),3)+1)));
        else
            if gap1_xpos<-26,gap1_init_xpos=gap2_init_xpos+100;gap1_hight=-randi(80);havepassed=1;end
            if gap2_xpos<-26,gap2_init_xpos=gap1_init_xpos+100;gap2_hight=-randi(80);havepassed=1;end
            gap1_xpos=gap1_init_xpos-passedpath;
            gap2_xpos=gap2_init_xpos-passedpath;
            set(DrawTubGap1Hdl,'XData',[0 26]+gap1_xpos,'YData',[0 304]+gap1_hight);
            set(DrawTubGap2Hdl,'XData',[0 26]+gap2_xpos,'YData',[0 304]+gap2_hight);  
            ComputeBirdPos()
            ComputeBirdAngle()
            
            [temp_xgrid,temp_ygrid]=meshgrid(1:17,1:13);
            cosa = cos(Bird.angle);
            sina = sin(Bird.angle);
            xgrid = cosa .* temp_xgrid + sina .* temp_ygrid;
            ygrid = cosa .* temp_ygrid - sina .* temp_xgrid;
            set(DrawBirdHdl,'XData',xgrid+Bird.pos(1),...
                            'YData',ygrid+Bird.pos(2),...
                            'CData',flipud(Bird.CDataNan(:,:,:,mod(floor(moment*10),3)+1)));  
            if gap1_xpos<40&&havepassed==1,score=score+1;havepassed=0;end
            if gap2_xpos<40&&havepassed==1,score=score+1;havepassed=0;end
            set(ScoreInfoBackHdl,'string',num2str(score));
            set(ScoreInfoForeHdl,'string',num2str(score));
        end
    end
%==========================================================================
    function ComputeBirdPos(~,~)
        Bird.speed=Bird.speed-gravity*(moment-lastmoment)*50;
        Bird.pos=[Bird.pos(1),Bird.pos(2)+Bird.speed*(moment-lastmoment)*50];
    end
    function ComputeBirdAngle(~,~)
            Bird.angle=Bird.angle+pi/50 ;
    end
%==========================================================================
    function KeyDownFcn(hObject,~,~)
        key=get(hObject,'CurrentKey');
        if strcmp(key,'space')
            if keyrelease==1&&begin==1&&gameover==0
                keyrelease=0;
                Bird.speed=2.5;
            end
            if begin==0
                begin=1;
                begintime=toc(timecounter);
                set(BeginInfoHdl,'visible','off');
                set(ScoreInfoBackHdl,'visible','on');
                set(ScoreInfoForeHdl,'visible','on');
            end
        end
    end
    function KeyUpFcn(hObject,~,~)
        key=get(hObject,'CurrentKey');
        if strcmp(key,'space')
            keyrelease=1;
        end
    end

%==========================Initial function================================
    function init(~,~)
        Bird=sprites.Bird;
        Tub=sprites.Tub;
        TubGap=sprites.TubGap;      
        Bkg=sprites.Bkg;
        Floor=sprites.Floor;
        Bird.pos=[40 80];
        Bird.speed=0;
        Bird.angle=-0;
        
        
        RES=[144 256];
        MainFigurePos=[500 100];
        MainFigureSize=RES.*2;
        BkgAxesSize=[200 144];
        FloorAxesSize=[56 144];
        
        gap1_init_xpos=300;
        gap2_init_xpos=400;
        gap1_xpos=gap1_init_xpos;
        gap2_xpos=gap2_init_xpos;
        gap1_hight=-20;
        gap2_hight=-50;
        
        score=0;
        begin=0; 
        begintime=0;
        lastmoment=0;
        gravity=0.13;
        keyrelease=1;
        gameover=0;
        havepassed=1;
        
        %Figure initialization
        MainFigure=figure('Name','Fly Bird ',...
            'NumberTitle','off', ...
            'menubar','none',...
            'Units','pixels', ...
            'Position',[MainFigurePos, MainFigureSize],...
            'Renderer','OpenGL',...
            'Color',[1 1 1],...
            'WindowKeyPressFcn',@KeyDownFcn,...
            'WindowKeyReleaseFcn',@KeyUpFcn);
       BkgAxes=axes('parent',MainFigure,...
                    'position',[0 56/256 1 200/256],...
                    'XLim', [0 BkgAxesSize(2)]-0.5,...
                    'YLim', [0 BkgAxesSize(1)]-0.5,...
                    'NextPlot','add',...
                    'Visible','on',...
                    'XTick',[], ...
                    'YTick',[]);
       FloorAxes=axes('parent',MainFigure,...
                    'position',[0 0 1 56/256],...
                    'XLim', [0 FloorAxesSize(2)]-0.5,...
                    'YLim', [0 FloorAxesSize(1)]-0.5,...
                    'NextPlot','add',...
                    'Visible','on',...
                    'XTick',[], ...
                    'YTick',[]);
       DrawBkgHdl=image(BkgAxes,[0 144],[0 200],flipud(Bkg.CData(1:200,1:144,:,1)));
       DrawTubGap1Hdl=image(BkgAxes,[0 26]+gap1_xpos,[0 304]+gap1_hight,flipud(TubGap.CData(1:304,1:26,:)),'alphaData',flipud(TubGap.Alpha(1:304,1:26,:)));
       DrawTubGap2Hdl=image(BkgAxes,[0 26]+gap2_xpos,[0 304]+gap2_hight,flipud(TubGap.CData(1:304,1:26,:)),'alphaData',flipud(TubGap.Alpha(1:304,1:26,:)));
       DrawFloorHdl=image(FloorAxes,[0 144],[0 56],flipud(Floor.CData(1:56,1:144,:,1)));
       BeginInfoHdl=text(72,170,'Tap SPACE to begin', ...
            'FontName','Helvetica','FontSize',20,'HorizontalAlignment','center','Color',[.25 .25 .25],'Visible','on');
       ScoreInfoBackHdl=text(72,190,num2str(score),...
            'FontName','Helvetica','FontSize',30,'HorizontalAlignment','center','Color',[0,0,0],'Visible','off');
       ScoreInfoForeHdl=text(70.5,189.5,num2str(score), ...
            'FontName','Helvetica','FontSize',30,'HorizontalAlignment','center','Color',[1 1 1],'Visible','off');
       GameOverInfoHdl=text(72,140,'GAME OVER', ...
            'FontName','Arial','FontSize',20,'HorizontalAlignment','center','Color',[1 0 0],'Visible','off');
       YourScoreInfoHdl=text(72,120,['Score : ',num2str(score)], ...
            'FontName','Arial','FontSize',16,'HorizontalAlignment','center','Color',[1 1 1],'Visible','off');
       BestScoreInfoHdl=text(72,105,[' Best  : ',num2str(max(score,sprites.Best))], ...
            'FontName','Arial','FontSize',16,'HorizontalAlignment','center','Color',[1 1 1],'Visible','off');
       
       [xgrid,ygrid]=meshgrid(1:17,1:13);
       DrawBirdHdl=surface(xgrid+Bird.pos(1),ygrid+Bird.pos(2),...
            zeros(13,17),flipud(Bird.CDataNan(:,:,:,1)),...
            'CDataMapping','direct',...
            'EdgeColor','none',...
            'Visible','on',...
            'Parent',BkgAxes);
        
        fps = 50;                                    
        game = timer('ExecutionMode', 'FixedRate', 'Period',1/fps, 'TimerFcn', @FlyBirdGame);
        set(gcf,'tag','co','CloseRequestFcn',@clo);
        function clo(~,~),stop(game),delete(findobj('tag','co'));clf,close,end 
        timecounter=uint64(tic);
        start(game)
    end
%==========================================================================
end