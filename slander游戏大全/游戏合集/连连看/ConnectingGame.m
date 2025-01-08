function ConnectingGame
%连连看图片导入============================================================
path='图片';
picInformation=dir(fullfile(path,'*.jpg'));
N=length(picInformation);
for i=1:N
    picList.(['pic',num2str(i)])=...
        imread([path,'\',picInformation(i).name]);
end


%全局变量==================================================================
global selectedPos clickPos
global redLinePnts
global picMat

selectedPos=[];
redLinePnts=[];
%图片矩阵生成==============================================================
    function createMat(~,~)
        tempMat=zeros(8,6);
        while any(any(tempMat==0))
            zeosPos=find(tempMat==0);
            temprand=rand(1,length(zeosPos));
            [~,tempSort]=sort(temprand);
            tempNum=zeosPos(tempSort(1:2));
            tempMat(tempNum)=randi(N);
        end
        picMat=zeros(10,8);
        picMat(2:9,2:7)=tempMat;
    end

createMat()
%主要框架生成==============================================================
MainFig=figure('units','pixels','position',[750 250 (9*100+10*5+20)*0.5 (7*100+8*5+20)*0.5],...
    'Numbertitle','off','menubar','none','resize','off',...
    'name','ConnectingGame | by slandarer');
axes('parent',MainFig,'position',[0 0 1 1],...
    'XLim', [40 10*100+10*5-40],...
    'YLim', [40 8*100+8*5-40],...
    'color',[0.95,0.95,0.95],...
    'NextPlot','add',...
    'layer','bottom',...
    'Visible','on',...
    'XTick',[], ...
    'YTick',[]);
uh1=uimenu('label','帮助');
uimenu(uh1,'label','重新开始','callback',@restartGame)
for i=2:9
    for j=2:7
        drawPicHdl(i,j)=image([(i-1)*100,i*100]+(i-1)*5,[(j-1)*100,j*100]+(j-1)*5,...
            picList.(['pic',num2str(picMat(i,j))]),'tag',[num2str(i),num2str(j)],...
            'ButtonDownFcn',@clickOnPic);
    end
end


%重新开始函数==============================================================
    function restartGame(~,~)
        createMat()
        for ii=2:9
            for jj=2:7
                set(drawPicHdl(ii,jj),'CData',picList.(['pic',num2str(picMat(ii,jj))]))
            end
        end
    end


%主函数====================================================================
    function clickOnPic(object,~)
        redLinePnts=[];
        clickPos=[str2num(object.Tag(1)),str2num(object.Tag(2))];
        if isempty(selectedPos),selectedPos=clickPos;end
        if ~all(selectedPos==clickPos)
            %-------------------------------------------------------------------------------------------------
            condition1=0;condition2=0;
            switch 1
                case any(selectedPos(1)==clickPos(1))
                    condition1=abs(selectedPos(2)-clickPos(2))==1;
                    tempVector1=sort([selectedPos(2),clickPos(2)])+[1 -1];
                    tempSum=sum(picMat(clickPos(1),tempVector1(1):tempVector1(2)));
                    condition2=(tempSum==0)&~isempty(picMat(clickPos(1),tempVector1(1):tempVector1(2)));
                case any(selectedPos(2)==clickPos(2))
                    condition1=abs(selectedPos(1)-clickPos(1))==1;
                    tempVector1=sort([selectedPos(1),clickPos(1)])+[1 -1];
                    tempSum=sum(picMat(tempVector1(1):tempVector1(2),clickPos(2)));
                    condition2=(tempSum==0)&~isempty(picMat(clickPos(1),tempVector1(1):tempVector1(2)));
            end
            if (condition1||condition2)&&picMat(clickPos(1),clickPos(2))==picMat(selectedPos(1),selectedPos(2))
                redLinePnts=[selectedPos;clickPos];
            end
            %-------------------------------------------------------------------------------------------------
            if isempty(redLinePnts)
                tempNode=[selectedPos(1),clickPos(2)];
                tempVector1=[selectedPos(2)+1,clickPos(2)].*(clickPos(2)>selectedPos(2))+...
                    [clickPos(2),selectedPos(2)-1].*(clickPos(2)<=selectedPos(2));
                tempVector2=[selectedPos(1),clickPos(1)-1].*(clickPos(1)>selectedPos(1))+...
                    [clickPos(1)+1,selectedPos(1)].*(clickPos(1)<=selectedPos(1));
                condition1=(sum(picMat(selectedPos(1),tempVector1(1):tempVector1(2)))==0);
                condition2=sum(picMat(tempVector2(1):tempVector2(2),clickPos(2)))==0;
                condition3=picMat(selectedPos(1),selectedPos(2))==picMat(clickPos(1),clickPos(2));
                if all([condition1,condition2,condition3])
                    redLinePnts=[selectedPos;tempNode;clickPos];
                end
            end
            if isempty(redLinePnts)
                tempNode=[clickPos(1),selectedPos(2)];
                tempVector1=[clickPos(2)+1,selectedPos(2)].*(selectedPos(2)>clickPos(2))+...
                    [selectedPos(2),clickPos(2)-1].*(selectedPos(2)<=clickPos(2));
                tempVector2=[clickPos(1),selectedPos(1)-1].*(selectedPos(1)>clickPos(1))+...
                    [selectedPos(1)+1,clickPos(1)].*(selectedPos(1)<=clickPos(1));
                condition1=sum(picMat(clickPos(1),tempVector1(1):tempVector1(2)))==0;
                condition2=sum(picMat(tempVector2(1):tempVector2(2),selectedPos(2)))==0;
                condition3=picMat(selectedPos(1),selectedPos(2))==picMat(clickPos(1),clickPos(2));
                if all([condition1,condition2,condition3])
                    redLinePnts=[selectedPos;tempNode;clickPos];
                end
            end
            %-------------------------------------------------------------------------------------------------
            if isempty(redLinePnts)
                for ii=[selectedPos(1):-1:1,selectedPos(1):10]
                    tempNode1=[ii,selectedPos(2)];
                    tempNode2=[ii,clickPos(2)];
                    tempVector1=[selectedPos(1)+1,ii].*(ii>selectedPos(1))+[ii,selectedPos(1)-1].*(ii<=selectedPos(1));
                    tempVector2=[clickPos(1)+1,ii].*(ii>clickPos(1))+[ii,clickPos(1)-1].*(ii<=clickPos(1));
                    tempVector3=sort([selectedPos(2),clickPos(2)]);
                    condition1=sum(picMat(tempVector1(1):tempVector1(2),selectedPos(2)))==0;
                    condition2=sum(picMat(tempVector2(1):tempVector2(2),clickPos(2)))==0;
                    condition3=sum(picMat(ii,tempVector3(1):tempVector3(2)))==0;
                    condition4=picMat(selectedPos(1),selectedPos(2))==picMat(clickPos(1),clickPos(2));
                    if all([condition1,condition2,condition3,condition4])
                        redLinePnts=[selectedPos;tempNode1;tempNode2;clickPos];
                        break
                    end
                end
            end
            if isempty(redLinePnts)
                for jj=[selectedPos(2):-1:1,selectedPos(2):8]
                    tempNode1=[selectedPos(1),jj];
                    tempNode2=[clickPos(1),jj];
                    tempVector1=[selectedPos(2)+1,jj].*(jj>selectedPos(2))+[jj,selectedPos(2)-1].*(jj<=selectedPos(2));
                    tempVector2=[clickPos(2)+1,jj].*(jj>clickPos(2))+[jj,clickPos(2)-1].*(jj<=clickPos(2));
                    tempVector3=sort([selectedPos(1),clickPos(1)]);
                    condition1=sum(picMat(selectedPos(1),tempVector1(1):tempVector1(2)))==0;
                    condition2=sum(picMat(clickPos(1),tempVector2(1):tempVector2(2)))==0;
                    condition3=sum(picMat(tempVector3(1):tempVector3(2),jj))==0;
                    condition4=picMat(selectedPos(1),selectedPos(2))==picMat(clickPos(1),clickPos(2));
                    if all([condition1,condition2,condition3,condition4])
                        redLinePnts=[selectedPos;tempNode1;tempNode2;clickPos];
                        break
                    end
                end
            end
            %-------------------------------------------------------------------------------------------------
            if ~isempty(redLinePnts)
                redLinePntsX=(redLinePnts(:,1)-1).*100+(redLinePnts(:,1)-1).*5+50;
                redLinePntsY=(redLinePnts(:,2)-1).*100+(redLinePnts(:,2)-1).*5+50;
                RedLine=plot(redLinePntsX,redLinePntsY,'Color',[1 0 0],'LineWidth',2.5);
                pause(0.3)
                delete(RedLine)
                picMat(selectedPos(1),selectedPos(2))=0;
                picMat(clickPos(1),clickPos(2))=0;
                set(drawPicHdl(selectedPos(1),selectedPos(2)),'CData',ones(100,100,3).*0.95);
                set(drawPicHdl(clickPos(1),clickPos(2)),'CData',ones(100,100,3).*0.95);
                selectedPos=[];
            else
                selectedPos=clickPos;
            end    
        end 
    end
end















