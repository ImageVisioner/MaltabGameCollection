function SLsXpbombs
global Row; Row=10;%雷区行数
global Col; Col=10;%雷区列数
global MineMap;  MineMap=[];  %地雷图
global aroundMap;aroundMap=[];%周围地雷数
global MarkMap;  MarkMap=ones([Row,Col]);  %标记图

global MineNum; MineNum=8;%地雷总数
global FlagNum; FlagNum=0; %旗子总数
global times;   times=1;   %挖雷次数
%global Surplus; Surplus=MineNum;%剩余地雷=地雷总数-旗子总数

global tool;tool='扫雷';

global XPBlabel XPBimage scoreImage;

XPBFig=uifigure('units','pixels',...
    'position',[500,200,260,310],...
    'Numbertitle','off',...
    'menubar','none',...
    'resize','off',...
    'name','扫雷');

XPBfaceIm=uiimage(XPBFig);
XPBfaceIm.Position=[130-13,275,26,26];
XPBfaceIm.ImageSource='image\face1.png';%'image\none.png';
XPBfaceIm.UserData=0;
set(XPBfaceIm,'ImageClickedFcn',@restart)

uilabel(XPBFig,'Text','','BackgroundColor',[0 0 0],'Position',[20-1,270,66,40]);
uilabel(XPBFig,'Text','','BackgroundColor',[0 0 0],'Position',[+260-40-44-1,270,66,40]);
for i=1:3
    scoreImage(1,i)=uiimage(XPBFig,'ImageSource','image\0.png',...
            'Position',[20+(i-1)*22,270,20,40]);
    scoreImage(2,i)=uiimage(XPBFig,'ImageSource','image\0.png',...
            'Position',[(i-1)*22+260-40-44,270,20,40]);
end;drawScore(MineNum,MarkMap)


XPBMenu=uimenu(XPBFig);
XPBMenu.Text='帮助';

XPBMenu_1=uimenu(XPBMenu);
XPBMenu_1.Text='插旗';
set(XPBMenu_1,'MenuSelectedFcn',@MenuSelected)

    function MenuSelected(~,~)
        switch 1
            case strcmp(XPBMenu_1.Text,'插旗'),XPBMenu_1.Text='扫雷';tool='插旗';
            case strcmp(XPBMenu_1.Text,'扫雷'),XPBMenu_1.Text='插旗';tool='扫雷';
        end
    end

for m=1:Row
    for n=1:Col
        XPBlabel(m,n)=uilabel(XPBFig,'Text','','HorizontalAlignment','center',...
             'FontSize',16,'FontWeight','bold',...
             'BackgroundColor',0.85*[1,1,1],'Position',[10+1+(m-1)*24,10+1+(n-1)*26,24-2,26-2]);
        XPBimage(m,n)=uiimage(XPBFig,'ImageSource','image\button.png',...
            'Position',[10+(m-1)*24,10+(n-1)*26,24,26],'UserData',[m,n],'ImageClickedFcn',@clickButton);
    end
end
%==========================================================================
    function clickButton(obj,~)
        clickPos=obj.UserData;
        
        if strcmp(tool,'插旗')
            switch MarkMap(clickPos(1),clickPos(2))
                case 1,set(XPBimage(clickPos(1),clickPos(2)),'visible','on','ImageSource','image\flagbutton.png');
                case -1,set(XPBimage(clickPos(1),clickPos(2)),'visible','on','ImageSource','image\button.png');
            end
            MarkMap(clickPos(1),clickPos(2))=-MarkMap(clickPos(1),clickPos(2));
            drawScore(MineNum,MarkMap)
            return;
        end
        
        if times==1,[MineMap,aroundMap]=createMap(clickPos);drawNum(aroundMap);times=inf;end  
        if MarkMap(clickPos(1),clickPos(2))==-1,return;end
        
        set(XPBimage(clickPos(1),clickPos(2)),'visible','off');
        MarkMap(clickPos(1),clickPos(2))=0;
        
        switch MineMap(clickPos(1),clickPos(2))
            case 1,gameOver(MineMap,clickPos);
            case 0,searchZone(aroundMap,clickPos);
        end
        
        drawScore(MineNum,MarkMap)
        if all(all(abs(MarkMap)==MineMap))
            win()
        end
    end
%==========================================================================
    function drawScore(MineNum,MarkMap)
        MarkMap(MarkMap==-1)=0;
        score1=num2str(MineNum);L1=length(score1);
        score2=num2str(sum(sum(MarkMap)));L2=length(score2);
        for ii=1:3
            if ii<=3-L1
                set(scoreImage(1,ii),'ImageSource','image\0.png')
            else
                tempStr=score1(ii-(3-L1));
                set(scoreImage(1,ii),'ImageSource',['image\',tempStr,'.png']);
            end
            if ii<=3-L2
                set(scoreImage(2,ii),'ImageSource','image\0.png')
            else
                tempStr=score2(ii-(3-L2));
                set(scoreImage(2,ii),'ImageSource',['image\',tempStr,'.png']);
            end
        end
    end

    function win(~,~)
        for mm=1:Row
            for nn=1:Col
                if MineMap(mm,nn)==1
                    set(XPBimage(mm,nn),'visible','on','ImageSource','image\flagbutton.png');
                end
            end
        end
        XPBfaceIm.ImageSource='image\face3.png';
    end

    function gameOver(MineMap,pos)
        for mm=1:Row
            for nn=1:Col
                set(XPBimage(mm,nn),'visible','off');
                if MineMap(mm,nn)==1
                    set(XPBimage(mm,nn),'visible','on','ImageSource','image\mine.png');
                end
            end
        end
        set(XPBlabel(pos(1),pos(2)),'BackgroundColor',[1 0 0]);
        XPBfaceIm.ImageSource='image\face2.png';
    end
    
    function searchZone(aroundMap,pos)
        if aroundMap(pos(1),pos(2))~=0,return;end
        
        begins=pos;
        [nonea,noneb]=find(aroundMap==0);
        none=[nonea,noneb];
        listZone=[begins;begins+[1,0];begins+[-1,0];
                         begins+[0,1];begins+[0,-1];
                         begins+[-1,1];begins+[-1,-1];
                         begins+[1,1];begins+[1,-1]];
        while ~isempty(intersect(none,listZone,'rows'))
            [a,b,~]=intersect(none,listZone,'rows');
            begins=[a;begins];none(b,:)=[];
            ad=length(sum(begins,2));
            listZone=[begins;begins+ones(ad,1)*[1,0];begins+ones(ad,1)*[-1,0];
                             begins+ones(ad,1)*[0,1];begins+ones(ad,1)*[0,-1];
                             begins+ones(ad,1)*[-1,1];begins+ones(ad,1)*[-1,-1];
                             begins+ones(ad,1)*[1,1];begins+ones(ad,1)*[1,-1]];
            listZone=unique(listZone,'rows');
        end
        listZone(sum(listZone<1,2)>0,:)=[];
        listZone(sum(listZone>10,2)>0,:)=[];
        listZone=round(listZone);
        for ii=1:size(listZone,1)
            set(XPBimage(listZone(ii,1),listZone(ii,2)),'visible','off')
            MarkMap(listZone(ii,1),listZone(ii,2))=0;
        end
    end

    function restart(~,~)
        MineMap=[];
        aroundMap=[];
        MarkMap=ones([Row,Col]);
        
        times=1;
        tool='扫雷';
        for mm=1:Row
            for nn=1:Col
                set(XPBlabel(mm,nn),'Text','','BackgroundColor',0.85*[1,1,1])
                set(XPBimage(mm,nn),'ImageSource','image\button.png','visible','on');
            end
        end
        drawScore(MineNum,MarkMap)
        XPBfaceIm.ImageSource='image\face1.png';
    end
    
        
        
        
        
%==========================================================================
    function drawNum(aroundMap)
        for mm=1:Row
            for nn=1:Col
                switch aroundMap(mm,nn)
                    case 0
                    case 1,set(XPBlabel(mm,nn),'Text','1','FontColor',[0 0 1])
                    case 2,set(XPBlabel(mm,nn),'Text','2','FontColor',[0,0.7,0])
                    case 3,set(XPBlabel(mm,nn),'Text','3','FontColor',[0.8,0,0])
                    case 4,set(XPBlabel(mm,nn),'Text','4','FontColor',[0,0,0.6])
                    case 5,set(XPBlabel(mm,nn),'Text','5','FontColor',[0.5,0,0])
                    case 6,set(XPBlabel(mm,nn),'Text','6','FontColor',[0,0.6,0])
                    case 7,set(XPBlabel(mm,nn),'Text','7','FontColor',[0.75,0,0]) 
                    case 8,set(XPBlabel(mm,nn),'Text','8','FontColor',[0.4,0,0])
                end
            end
        end
    end

    %第一次挖雷时生成地雷分布图（这样第一次不会碰到雷）
    function [randMap,surrMap]=createMap(pos)
        %生成地雷分布图
        randMap=rand([Row,Col]);
        randMap(pos(1),pos(2))=inf;
        [~,St]=sort(randMap(:));
        randMap=(randMap<=randMap(St(MineNum)));
        
        %生成周围地雷数分布图
        frameMap=zeros([Row+2,Col+2]);
        xSet=2:Row+1;ySet=2:Col+1;
        frameMap(xSet,ySet)=randMap;
        surrMap(xSet-1,ySet-1)=frameMap(xSet-1,ySet+1)+frameMap(xSet-1,ySet)+...
                               frameMap(xSet-1,ySet-1)+frameMap(xSet,ySet+1)+...
                               frameMap(xSet,ySet-1)+frameMap(xSet+1,ySet+1)+...
                               frameMap(xSet+1,ySet)+frameMap(xSet+1,ySet-1);  
        surrMap(randMap==1)=0;
    end
%==========================================================================







end