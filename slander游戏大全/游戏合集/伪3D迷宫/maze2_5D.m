function maze2_5D
help maze2_5D

%% ========================================================================
% figure窗口创建
fig=figure();
fig.Position=[50,60,1200,600];
fig.Name='maze 2.5D by slandarer';
fig.NumberTitle='off';
fig.MenuBar='none';
% 俯视图axes坐标区域
ax2D=axes('Parent',fig);
ax2D.XTick=[];ax2D.XColor='none';
ax2D.YTick=[];ax2D.YColor='none';
ax2D.XLim=[0,15];
ax2D.YLim=[0,15];
ax2D.Color=[0,0,0];
ax2D.Position=[0,0,1/2,1];
hold(ax2D,'on')
% 伪3D图axes坐标区域
ax3D=axes('Parent',fig);
ax3D.XTick=[];ax2D.XColor='none';
ax3D.YTick=[];ax2D.YColor='none';
ax3D.XLim=[0,10];
ax3D.YLim=[0,10];
ax3D.Color=[0,0,0];
ax3D.Position=[1/2,0,1/2,1];
hold(ax3D,'on')
%% ========================================================================
% 左侧俯视地图初始化
mazeMat=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
         1 0 0 0 0 0 1 0 1 0 1 0 0 0 1;
         1 1 1 1 1 0 1 0 0 0 1 1 1 0 1;
         1 0 0 0 1 0 1 0 1 0 1 0 0 0 1;
         1 0 1 1 1 0 0 0 1 0 0 0 1 1 1;
         1 0 0 0 0 2 1 1 1 0 1 1 1 0 1;
         1 0 1 0 1 1 1 0 1 0 0 0 1 0 1;
         1 0 1 0 0 0 0 0 1 1 1 0 1 0 1;
         1 0 1 1 1 1 1 1 1 0 1 0 0 0 1;
         1 0 1 0 0 0 0 0 0 0 1 0 1 0 1;
         1 0 1 1 1 1 1 0 1 0 1 0 1 0 1;
         1 0 1 0 1 0 1 0 1 0 0 0 1 0 1;
         1 0 1 0 1 0 1 0 1 1 1 1 1 0 1;
         1 0 0 0 0 0 0 0 1 0 0 0 0 0 1;
         1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
[rowList,colList]=find(mazeMat==1);
sqX=[-1;0;0;-1];sqY=[-1;-1;0;0];
for n=1:length(rowList) 
    pBlock(n)=polyshape(sqX+colList(n),sqY+size(mazeMat,1)+1-rowList(n));
    plot(ax2D,pBlock(n),'FaceColor',[1,1,1].*.9,'FaceAlpha',1);
end
% -------------------------------------------------------------------------
% 角色创建
[trow,tcol]=find(mazeMat==2);
ROLEP.xpos=tcol-0.5;
ROLEP.ypos=size(mazeMat,1)+0.5-trow;
ROLEP.theta=pi/2;
ROLEP.triX=cos([pi/3,pi,-pi/3]).*0.15;
ROLEP.triY=sin([pi/3,pi,-pi/3]).*0.15;
[tX,tY]=rotateData(ROLEP.triX,ROLEP.triY,ROLEP.theta);
ROLEP.pfill=fill(ax2D,tX+ROLEP.xpos,tY+ROLEP.ypos,[1,1,1]);
ROLEP.pshape=polyshape(tX+ROLEP.xpos,tY+ROLEP.ypos);
ROLEP.viewRange=size(mazeMat,1)*sqrt(2);

draw3D(ROLEP,pBlock,ax3D)
%% ========================================================================
% 角色移动函数
set(fig,'KeyPressFcn',@key)
function key(~,event)
    %按键函数
    switch event.Key
        case 'uparrow'
            ROLEP.xpos=ROLEP.xpos+cos(ROLEP.theta).*.2;
            ROLEP.ypos=ROLEP.ypos+sin(ROLEP.theta).*.2;
        case 'leftarrow'
            ROLEP.theta=ROLEP.theta+pi/20;
        case 'rightarrow'
            ROLEP.theta=ROLEP.theta-pi/20;
    end
    [tX,tY]=rotateData(ROLEP.triX,ROLEP.triY,ROLEP.theta);
    ROLEP.pfill.XData=tX+ROLEP.xpos;
    ROLEP.pfill.YData=tY+ROLEP.ypos;
    ROLEP.pshape=polyshape(tX+ROLEP.xpos,tY+ROLEP.ypos);
    draw3D(ROLEP,pBlock,ax3D)
end
%% ========================================================================
% 视角检测及伪3D图绘制
function draw3D(RP,BK,ax2)
    delete(findobj('Tag','blockLine'))
    thetaListV=linspace(pi/3,-pi/3,100);
    thetaList=thetaListV+RP.theta;

    % 计算到最近墙的距离
    % disList(length(thetaList))=0; 
    for i=1:length(thetaList)
        tLine=[RP.xpos,RP.ypos;...
              RP.xpos+RP.viewRange*cos(thetaList(i)),...
              RP.ypos+RP.viewRange*sin(thetaList(i))];

        inSet=zeros(2,0);
        for j=1:length(BK)
            [in,~]=intersect(BK(j),tLine);
            if ~isempty(in)
                inSet=[inSet;[in([1,end],1),in([1,end],2)]];
                %plot(in([1,end],1),in([1,end],2),'Parent',ax1,'LineWidth',2)
            end
        end
        tDis=vecnorm((inSet-[RP.xpos,RP.ypos])');
        % disList(i)=min(tDis);
        tLen=10/(min(tDis))/abs(cos(thetaListV(i))).*0.6;tLen(tLen>10)=10;
        plot(ax2,[1,1].*10.*i./length(thetaListV),[5-tLen/2,5+tLen/2],...
            'LineWidth',5,'Color',[1,1,1]./10.*tLen,'Tag','blockLine');
    end
end
%% ========================================================================
% 数据旋转角度
function [X,Y]=rotateData(X,Y,theta)
    rotateMat=[cos(theta),-sin(theta);sin(theta),cos(theta)];
    XY=rotateMat*[X;Y];
    X=XY(1,:);Y=XY(2,:);
end
end