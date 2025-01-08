function game20483D
global squaremap
global colorlist
global fontsizelist
global baseX baseY baseZ
global barHdl textHdl
global txtBest txtScore
global best


fig=figure('units','pixels');
fig.Position=[560 50 575,400];
fig.Color=[0.9804 0.9725 0.9373];
fig.NumberTitle='off';
fig.Name='2048Game3D';
fig.MenuBar='none';
fig.Resize='off';
fig.KeyPressFcn=@key;
%
ax=axes(fig);
hold(ax,'on');
ax.Position=[0.1 0 1 1];
ax.ZLim=[0,17];
ax.XLim=[0,4]+0.5;
ax.YLim=[0,4]+0.5;
ax.View=[60   30];
fill([0 4 4 0]+0.5,[0 0 4 4]+0.5,[0.7333 0.6784 0.6275],'EdgeColor','none');
ax.Color=[0.8039 0.7569 0.7059].*1.02;
ax.XTick=[];
ax.YTick=[];
ax.ZTick=[];
ax.Box='on';
ax.LineWidth=3;
ax.XColor=[0.7333 0.6784 0.6275];
ax.YColor=[0.7333 0.6784 0.6275];
ax.ZColor=[0.7333 0.6784 0.6275];
% for i=1:4
%     for j=1:4
%         fill((i-1)+0.5+[.1 .8 .8 .1],(j-1)+0.5+[.1 .1 .8 .8],...
%             [0.8039 0.7569 0.7059],'EdgeColor','none');
%         
%     end
% end
% ==========================================================================
% 方块颜色表
colorlist=[ 0.8039    0.7569    0.7059
    0.9333    0.8941    0.8549
    0.9373    0.8784    0.8039
    0.9608    0.6863    0.4824
    0.9529    0.5922    0.4078
    0.9529    0.4902    0.3725
    0.9686    0.3686    0.2431
    0.9255    0.8118    0.4510
    0.9373    0.7882    0.3922
    0.9333    0.7804    0.3216
    0.9216    0.7686    0.2627
    0.9255    0.7608    0.1804
    0.9412    0.4078    0.4157
    0.9216    0.3137    0.3451
    0.9451    0.2549    0.2627
    0.4392    0.7020    0.8157
    0.3765    0.6353    0.8745
    0.0902    0.5098    0.7843];
% 数字大小表
fontsizelist=[18 24 24 24 24 24 24 24 24 24 22 22 22 22 20 20 20 16].*0.8;
% 立方体数据
baseX=[0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0].*0.7-0.35;
baseY=[0 0 1 0 0 0;0 1 1 1 0 0;0 1 1 1 1 1;0 0 1 0 1 1].*0.7-0.35;
baseZ=[0 0 0 0 0 1;0 0 0 0 0 1;1 1 1 1 0 1;1 1 1 1 0 1];

text(-0.6,0.75,17,'2048-3D GAME','HorizontalAlignment','left','Color',...
    [0.4667 0.4314 0.3961],'FontSize',15,'FontWeight','bold')
text(-0.8,0.75,-7,' BEST  ','HorizontalAlignment','left','Color',...
    [0.9333 0.8941 0.8549],'FontSize',14,'FontWeight','bold','BackgroundColor',[0.7333 0.6784 0.6275])
text(-0.8,0.75,-10,'SCORE','HorizontalAlignment','left','Color',...
    [0.9333 0.8941 0.8549],'FontSize',14,'FontWeight','bold','BackgroundColor',[0.7333 0.6784 0.6275])
txtBest=text(0.4,0.9,-4.7,'0','HorizontalAlignment','left','Color',...
    [0.4667 0.4314 0.3961],'FontSize',14,'FontWeight','bold');
txtScore=text(0.4,0.9,-7.7,'0','HorizontalAlignment','left','Color',...
    [0.4667 0.4314 0.3961],'FontSize',14,'FontWeight','bold');
% ==========================================================================


%按键函数，通过moveevent调整矩阵
    function key(~,event)
        temp_map=squaremap;
        switch event.Key
            case 'uparrow'
                temp_map=moveevent(temp_map');
                temp_map=temp_map';
            case 'downarrow'
                temp_map=temp_map';
                temp_map=moveevent(temp_map(:,4:-1:1));
                temp_map=temp_map(:,4:-1:1);
                temp_map=temp_map';
            case 'rightarrow'
                temp_map=moveevent(temp_map(:,4:-1:1));
                temp_map=temp_map(:,4:-1:1);
            case 'leftarrow'
                temp_map=moveevent(temp_map);
        end
        score=sum(sum(squaremap));
        best=max([best,score]);
        save best.mat best -append
        
        %若新矩阵与原矩阵不同，则重新绘制方块
        if any(any(squaremap~=temp_map))
            squaremap=temp_map;
            createNewNum()
            drawBlock()
        end
    end

    %主函数
    function temp_matrix=moveevent(temp_matrix)
        for ii = 1: 4
            temp_array=temp_matrix(ii,:);
            temp_array(temp_array==0)=[];

            for jj = 1: (length(temp_array)-1)
                if temp_array(jj)==temp_array(jj+1)
                    temp_array(jj)=temp_array(jj)+temp_array(jj+1);
                    temp_array(jj+1)=0;
                end
            end

            temp_array(temp_array==0)=[];
            temp_array((length(temp_array)+1):4)=0;
            temp_matrix(ii,:)=temp_array;
        end
    end
% =========================================================================
for i=1:4
    for j=1:4
        barHdl{i,j}=fill3(baseX+i,baseY+j,baseZ,'y','EdgeColor',[0.7333 0.6784 0.6275].*0.3);
        textHdl{i,j}=text(i,j,1.5,'0','Color',[0.7333 0.6784 0.6275].*0.4,...
            'FontWeight','bold','HorizontalAlignment','center');
    end
end
init()

    function init()
        %若没有游戏记录则最高分为0
        if ~exist('best.mat')
            best=0;
            save best.mat best;
        end
        data=load('best.mat');
        best=data.best;
        txtBest.String=num2str(best);
        
        squaremap=zeros(4,4);
        createNewNum()
        createNewNum()
        drawBlock()
    end


    function drawBlock(~,~)
        score=sum(sum(squaremap));
        txtScore.String=num2str(score);
        hmap=log(squaremap)/log(2);
        hmap(isinf(hmap))=0;
        for ii=1:4
            for jj=1:4
                tNum=squaremap(ii,jj);
                tH=hmap(ii,jj);
                for kk=1:6
                    tZ=barHdl{ii,jj}(kk).ZData;tZ(tZ>0)=tH+0.01;
                    barHdl{ii,jj}(kk).ZData=tZ;
                    barHdl{ii,jj}(kk).FaceColor=colorlist(tH+1,:);
                    if tNum~=0
                        barHdl{ii,jj}(kk).EdgeColor=[0.7333 0.6784 0.6275].*0.3;
                    else
                        barHdl{ii,jj}(kk).EdgeColor=[0.7333 0.6784 0.6275];
                    end
                end
                if tNum~=0
                    textHdl{ii,jj}.Position(3)=tH+1;
                    textHdl{ii,jj}.FontSize=fontsizelist(tH+1);
                    textHdl{ii,jj}.String=num2str(tNum);        
                else
                    textHdl{ii,jj}.String='';   
                end
            end
        end
        judge()
    end

% 在矩阵空白处创建新的数字2或4
    function createNewNum(~,~)
        zerospos=find(squaremap==0);
        temp_pos=zerospos(randi(length(zerospos)));
        temp_num=randi(2)*2;
        squaremap(temp_pos)=temp_num;
    end

% 判断游戏结束函数
    function judge(~,~)
        temp_judge_zeros=sum(sum(squaremap==0));
        temp_judge_row=any(any(squaremap(1:3,:)==squaremap(2:4,:)));
        temp_judge_col=any(any(squaremap(:,1:3)==squaremap(:,2:4)));
        if temp_judge_row+temp_judge_col+temp_judge_zeros==0
            gameOver()
        end
    end

% gameOver
    function gameOver(~,~)
        answer = questdlg('GAME OVER, what would you like to do', ...
            '2048-3D-GAME', ...
            'restart','quit','restart');
        % Handle response
        switch answer
            case 'restart'
                init()
            case 'quit'
                close all
                clear
        end
    end
end