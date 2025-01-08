function pianoKeys
%======================%========
[v1,notes,fs]=getMusic;%读取音乐
%======================%========

fig=uifigure;
fig.Position=[10 50 4*90 4*150];
fig.NumberTitle='off';
fig.MenuBar='none';
fig.Resize='off';
fig.Name='pianoKeys';

ax=uiaxes(fig);
ax.Position=[-22 -15 4*90+36 4*150+40];
ax.XLim=[0 4*90];
ax.YLim=[0 4*150];
ax.XColor=[0 0 0];
ax.YColor=[0 0 0];
ax.Box='on';
ax.XTick=0:90:360;
ax.YTick=[0 600];
ax.XGrid='on';
ax.GridColor=[0 0 0];
ax.GridAlpha=1;
ax.Toolbar.Visible='off';

%==========================================================================

blockList(1)=drawBlock(changeData(1),0,{'开始';'游戏'},v1{1});
noDeleteList=1:4;
newBlockY=600;
newBlockNum=5;
startFlag=0;
gameOver=0;
for i=2:4
    x=changeData(i);
    blockList(i)=drawBlock(x,(i-1)*150,'',v1{i});
end


%==========================================================================
set(fig,'KeyPressFcn',@keyPressFcn) 
%==========================================================================
fps=10;
PKtimer=timer('ExecutionMode', 'fixedRate', 'Period',1/fps, 'TimerFcn', @pianoGame);
start(PKtimer)
%==========================================================================

function pianoGame(~,~)
    if startFlag
        if newBlockY<=600&&newBlockNum<=length(v1)
            tempX=changeData(newBlockNum);
            blockList(newBlockNum)=drawBlock(tempX,newBlockY,'',v1{newBlockNum});
            noDeleteList=[noDeleteList,newBlockNum];
            newBlockNum=newBlockNum+1;
            newBlockY=newBlockY+150;
        end
        for ii=noDeleteList
            blockList(ii).Position(2)=blockList(ii).Position(2)-150/8;
        end
        newBlockY=newBlockY-150/8;
        if (~isempty(noDeleteList))&&blockList(noDeleteList(1)).Position(2)<-10
            gameOverFcn(1);
            gameOver=1;
            %tempStr=blockList(noDeleteList(1)).UserData;
            %sound(notes.(tempStr),fs)
            %delete(blockList(noDeleteList(1)))
            %noDeleteList(1)=[];
        end
    end
end

    function gameOverFcn(coe)
        sound([notes.do0f,notes.do1f,notes.do2f,notes.do2f],fs)
        switch coe
            case 1
                blockList(noDeleteList(1)).BackgroundColor=[0.6 0 0];
                blockList(noDeleteList(1)).Text={'游戏';'失败'};
                startFlag=0;
            otherwise
                object=uilabel(fig);
                object.Text={'游戏';'失败'};
                object.Position=[coe,0+3-18.75,90,150];
                object.FontSize=26;
                object.FontWeight='bold';
                object.FontColor=[1 1 1];
                object.BackgroundColor=[0.6 0 0];
                object.HorizontalAlignment='center';
                
        end      
    end

function keyPressFcn(~,event)
    switch event.Key
        case 'a',xPos=0+3;
        case 's',xPos=90+3;
        case 'd',xPos=180+3;
        case 'f',xPos=270+3;
        otherwise,xPos=-1;
    end
    if (~isempty(noDeleteList))&&blockList(noDeleteList(1)).Position(1)==xPos&&gameOver==0
        tempStr=blockList(noDeleteList(1)).UserData;
        sound(notes.(tempStr),fs)
        delete(blockList(noDeleteList(1)))
            if noDeleteList(1)==1
                startFlag=1;
            end
        noDeleteList(1)=[];
    elseif blockList(noDeleteList(1)).Position(1)~=xPos&&xPos~=-1&&gameOver==0&&startFlag==1
        startFlag=0;
        gameOverFcn(xPos);
        gameOver=1;   
    end
    
end
%==========================================================================
    function x=changeData(sort)
        note=v1{sort}; 
        switch note(1)
            case 'd',x=0;
            case 'r',x=0;
            case 'm',x=90;
            case 'f',x=90;
            case 's',x=180;
            case 'l',x=180;
            case 't',x=270;
            case 'b',x=270;
        end
    end

    function object=drawBlock(x,y,string,note)
        object=uilabel(fig);
        object.Text=string;
        object.Position=[x+3,y+3,90,150];
        object.FontSize=26;
        object.FontWeight='bold';
        object.FontColor=[1 1 1];
        object.BackgroundColor=[0 0 0];
        object.HorizontalAlignment='center';     
        object.UserData=note;
    end
end
 