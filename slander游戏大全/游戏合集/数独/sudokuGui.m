function sudokuGui

% GUI图窗创建
SDKFig=uifigure('units','pixels',...
    'position',[300 100 450 500],...
    'Numbertitle','off',...
    'menubar','none',...
    'resize','off',...
    'name','数独求解器 1.0',...
    'color',[1,1,1].*0.97);
SDKFig.AutoResizeChildren='off';
SDKAxes=uiaxes('Units','pixels',...
      'parent',SDKFig,...
      'PlotBoxAspectRatio',[1 1 1],...
      'Position',[15 15 420 420],...
      'Color',[0.99 0.99 0.99],... 
      'Box','on', ...
      'XLim',[0 1],'YLim',[0 1],...
      'XTick',[],'YTick',[]);
hold(SDKAxes,'on');
% SDKAxes.Toolbar.Visible='off';
% 按钮创建
uibutton(SDKFig,'Text','导  入  图  片','BackgroundColor',[0.31 0.58 0.80],'FontColor',[1 1 1],...
    'FontWeight','bold','Position',[25,450,150,35],'FontSize',13,'ButtonPushedFcn',@loadPic);  
uibutton(SDKFig,'Text','开  始  计  算','BackgroundColor',[0.31 0.58 0.80],'FontColor',[1 1 1],...
    'FontWeight','bold','Position',[200,450,150,35],'FontSize',13,'ButtonPushedFcn',@solveSDK); 
% =========================================================================
% 读取图像库内图像
path='数字图像库';
picInfor=dir(fullfile(path,'*.jpg'));
SDKPicSet{size(picInfor,1)}=[];
for n=1:size(picInfor,1)
    tempPic=imread([path,'\',picInfor(n).name]);
    SDKPicSet(n)={tempPic};
end
oriPic=[];

    % 图像读取函数
    function loadPic(~,~)
        try
            [filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
                '*.*','All Files' });
            oriPic=imread([pathname,filename]);
            Lim=max(size(oriPic));
            SDKAxes.XLim=[0 Lim];
            SDKAxes.YLim=[0 Lim];
            imshow(oriPic,'parent',SDKAxes)
        catch
        end
    end

    % 数独求解函数
    function solveSDK(~,~)
        % 提取数独矩阵及数独矩阵在图片中位置
        [XLim,YLim,sudokuMat]=getMat(oriPic);
        
        % 整数规划求解数独
        resultMat=sudoku(sudokuMat);disp(resultMat)

        % 补全数独图像
        fillSDK(XLim,YLim,resultMat,sudokuMat)
    end


% =========================================================================
    % 提取数独矩阵
    function [XLim,YLim,sudokuMat]=getMat(oriPic)
        bw=~im2bw(oriPic);
        deletedRange=round(((size(bw,1)+size(bw,2))/2)^2*0.00005);
        bw=bwareaopen(bw,deletedRange);
        % 定位数独表格
        xDistrib=find(sum(bw,2)~=0);
        yDistrib=find(sum(bw,1)~=0);
        XLim=[xDistrib(1),xDistrib(end)];
        YLim=[yDistrib(1),yDistrib(end)];
        % 将图像进行切割并将数字填入矩阵
        numPicSize=[round((XLim(2)-XLim(1)+1)/9),round((YLim(2)-YLim(1)+1)/9)];
        selectedPic=imresize(bw(XLim(1):XLim(2),YLim(1):YLim(2)),9.*numPicSize);
        sudokuMat=zeros(9,9);
        for i=1:9
            for j=1:9
                % 切割出每个数字
                numPic=selectedPic((i-1)*numPicSize(1)+1:i*numPicSize(1),(j-1)*numPicSize(2)+1:j*numPicSize(2));
                numPic=imclearborder(numPic);
                xDistrib=find(sum(numPic,2)~=0);
                yDistrib=find(sum(numPic,1)~=0);
                if ~any(xDistrib)||~any(yDistrib)% 若是方框是空的设置矩阵数值为0
                    sudokuMat(i,j)=0;
                else
                    xLim=[xDistrib(1),xDistrib(end)];
                    yLim=[yDistrib(1),yDistrib(end)];
                    % 为了区分1和7,这里多删去一块
                    numPic=numPic(xLim(1):xLim(2)-round(0.1*(xLim(2)-xLim(1))),yLim(1):yLim(2));
                    xDistrib=find(sum(numPic,2)~=0);
                    yDistrib=find(sum(numPic,1)~=0);
                    xLim=[xDistrib(1),xDistrib(end)];
                    yLim=[yDistrib(1),yDistrib(end)];
                    numPic=numPic(xLim(1):xLim(2),yLim(1):yLim(2));
                    numPic=imresize(numPic,[70 40]);
                    % 最小二乘法选出最可能的数值
                    tempVarin=inf.*ones(1,size(picInfor,1));
                    % 循环和图像库中图像做差值并求平方和
                    for k=1:size(picInfor,1)
                        tempVarin(k)=sum((double(SDKPicSet{k})-numPic.*255).^2,[1,2]);
                    end
                    tempStr=picInfor(tempVarin==min(tempVarin)).name;
                    sudokuMat(i,j)=str2double(tempStr(1));
                end
            end
        end
    end
% -------------------------------------------------------------------------
    % 整数规划求解数独
    function resultMat=sudoku(sudokuMat)
        % 记录原本1所在位置，构造等式约束
        n0Ind=find(sudokuMat~=0);
        Aeq0=zeros(length(n0Ind),9^3);
        for i=1:length(n0Ind)
            Aeq0(i,n0Ind(i)+(sudokuMat(n0Ind(i))-1)*81)=1;
        end
        % 每一行、列、管都只能有一个1
        Aeq1=zeros(81,9^3);
        Aeq2=zeros(81,9^3);
        Aeq3=zeros(81,9^3);
        for i=1:9
            for j=1:9
                A1=zeros(9,9,9);
                A2=zeros(9,9,9);
                A3=zeros(9,9,9);
                A1(:,i,j)=1;Aeq1((i-1)*9+j,:)=A1(:)';
                A2(i,:,j)=1;Aeq2((i-1)*9+j,:)=A2(:)';
                A3(i,j,:)=1;Aeq3((i-1)*9+j,:)=A3(:)';
            end
        end
        % 每个3x3的小矩阵都只能有一个1
        Aeq4=zeros(81,9^3);
        for k=1:9
            for i=1:3
                for j=1:3
                    A4=zeros(9,9,9);
                    A4((i-1)*3+1:i*3,(j-1)*3+1:j*3,k)=1;
                    Aeq4((k-1)*9+(i-1)*3+j,:)=A4(:)';
                end
            end
        end
        f=ones(1,9^3);  % 不重要，随便设置
        intcon=1:9^3;   % 所有元素都要求为整数
        lb=zeros(9^3,1);% 下限为0
        ub=ones(9^3,1); % 上限为1
        Aeq=[Aeq0;Aeq1;Aeq2;Aeq3;Aeq4];
        beq=ones(size(Aeq,1),1);
        % 求解整数规划
        X=intlinprog(f,intcon,[],[],Aeq,beq,lb,ub);
        % 重新 构造数独矩阵
        X=reshape(X,[9,9,9]);
        resultMat=zeros(9,9);
        for i=1:9
            resultMat=resultMat+X(:,:,i).*i;
        end
    end
% -------------------------------------------------------------------------
    % 补全数独
    function fillSDK(xLim,yLim,resultMat,sudokuMat)
        for i=0:9
            plot(SDKAxes,[yLim(1),yLim(1)]+i*(yLim(2)-yLim(1))/9,[xLim(1),xLim(2)],'Color',[0.29 0.65 0.85],'lineWidth',2)
            plot(SDKAxes,[yLim(1),yLim(2)],[xLim(1),xLim(1)]+i*(xLim(2)-xLim(1))/9,'Color',[0.29 0.65 0.85],'lineWidth',2)
        end
        fontSize=18;
        if (xLim(2)-xLim(1))>0.8*size(oriPic,1)
            fontSize=36;
        end
        for i=1:9
            for j=1:9
                if (resultMat(j,i)~=0)&&(sudokuMat(j,i)==0)
                text(SDKAxes,yLim(1)+(i-1)*(yLim(2)-yLim(1))/9+(yLim(2)-yLim(1))/9/2,...
                             xLim(1)+(j-1)*(xLim(2)-xLim(1))/9+(xLim(2)-xLim(1))/9/2,...
                             num2str(resultMat(j,i)),'HorizontalAlignment','center',...
                             'Color',[0.29 0.65 0.85],'fontWeight','bold','fontSize',fontSize)
                end
            end
        end
    end
end