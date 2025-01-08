function maze2_5D_v3
help maze2_5D_v3

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
LSList=linspace(-1,0,250)';
NMList=-ones(size(LSList));
FLList=[[LSList,NMList];[LSList,NMList.*0];[NMList,LSList];[NMList.*0,LSList]];

BLOCK.pntSet=zeros(2,0);
for n=1:length(rowList) 
    fill(ax2D,sqX+colList(n),sqY+size(mazeMat,1)+1-rowList(n),[1,1,1].*0.9);
    BLOCK.pntSet=[BLOCK.pntSet;FLList+repmat([colList(n),size(mazeMat,1)+1-rowList(n)],[size(FLList,1),1])];
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
%% ========================================================================
% 线条创建
% plot(ax3D,[1,1].*10.*i./length(thetaListV),[5-tLen/2,5+tLen/2],...
% 'LineWidth',1.5,'Color',[1,1,1]./10.*tLen,'Tag','blockLine');
% plot(ax2D,[RP.xpos,RP.xpos+cos(thetaList(i))*abs(minList(i))],[RP.ypos,RP.ypos+sin(thetaList(i))*abs(minList(i))])
lineNum=300;

ttV=linspace(pi/3,-pi/3,lineNum);
for n=1:lineNum
    PLINE.plotLine3(n)=plot(ax3D,-[1,1].*sin(ttV(n)).*10+5,[-1,-1],'LineWidth',3.5);
    PLINE.plotLine2(n)=plot(ax2D,[-1,-1],[-1,-1],'Color',lines(1));
end


draw3D(ROLEP,BLOCK,PLINE,lineNum)
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
    draw3D(ROLEP,BLOCK,PLINE,lineNum)
end
%% ========================================================================
% 视角检测及伪3D图绘制
    function draw3D(RP,BK,PLINE,LN)
    % delete(findobj('Tag','blockLine'))
    thetaListV=linspace(pi/3,-pi/3,LN);
    thetaList=thetaListV+RP.theta;
    % 内积法计算距离
    cutoff=1e-5;
    cosList=cos(thetaList);
    sinList=sin(thetaList);
    vecList=BK.pntSet-[RP.xpos,RP.ypos];
    disMat=vecList*[cosList;sinList];
    disMat(disMat<0)=inf;
    normList=vecnorm(vecList')';
    diffMat=abs(disMat-repmat(normList,[1,size(disMat,2)]));
    disMat(diffMat>cutoff)=inf;
    minList=min(abs(disMat));
    % 图像重绘
    for i=1:length(thetaList)
        tLen=10/abs(minList(i))/abs(cos(thetaListV(i))).*0.8;tLen(tLen>10)=10;
        PLINE.plotLine3(i).Color=[1,1,1]./10.*tLen;
        PLINE.plotLine3(i).YData=[5-tLen/2,5+tLen/2];
        PLINE.plotLine2(i).XData=[RP.xpos,RP.xpos+cos(thetaList(i))*abs(minList(i))];
        PLINE.plotLine2(i).YData=[RP.ypos,RP.ypos+sin(thetaList(i))*abs(minList(i))];
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