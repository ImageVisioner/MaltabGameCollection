function jigsaw2(path)

if nargin<1||isempty(path)
    [filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.jpeg','All Image Files';...
            '*.*','All Files' });
    path = [pathname,filename];
    
end
oriPic=imread(path);
%imshow(oriPic)

jigsawMask=zeros(101*5,101*5);
jigsawMask(102:404,102:404)=1;
[xMesh,yMesh]=meshgrid(1:101*5,1:101*5);
dis1=sqrt((xMesh-51).^2+(yMesh-253).^2);
dis2=sqrt((xMesh-505+50).^2+(yMesh-253).^2);
dis3=sqrt((xMesh-253).^2+(yMesh-152).^2);
dis4=sqrt((xMesh-253).^2+(yMesh-505+151).^2);
bool1=dis1<=50;
bool2=dis2<=50;
bool3=dis3<=50;
bool4=dis4<=50;
jigsawMask(bool1)=1;
jigsawMask(bool2)=1;
jigsawMask(bool3)=0;
jigsawMask(bool4)=0;
jigsawMask(253-25:253+25,51:505-50)=1;
jigsawMask(1:152,253-25:253+25)=0;
jigsawMask(505-151:505,253-25:253+25)=0;


resizePic=imresize(oriPic,[101*(3*4+2),101*(3*4+2)]);
Mainfig=figure('units','pixels','position',[300 80 720 400],...
                       'Numbertitle','off','menubar','none','resize','off',...
                       'name','jigsaw');
Mainaxes=axes('parent',Mainfig,'position',[0 0 1 1],...
                    'XLim', [0 720],...
                    'YLim', [0 400],...
                    'NextPlot','add',...
                    'layer','bottom',...
                    'YDir','reverse',...
                    'Visible','on',...
                    'XTick',[], ...
                    'YTick',[]);
                
                
image(Mainaxes,[420,420+14*20],[20,20+14*20],resizePic)
whiteMask=150*ones(100,100,3);
whiteMask(2:99,2:99,:)=255;
for i=1:4
    for j=1:4
        image(Mainaxes,440+[0,60]+(j-1)*60,40+[0,60]+(i-1)*60,uint8(whiteMask),...
            'UserData',[i,j]','Visible','on');
    end
end
for i=1:4
    for j=1:4
        picHdlR(j+(i-1)*4)=image(Mainaxes,420+[0,100]+(j-1)*60,20+[0,100]+(i-1)*60,uint8(zeros(100,100,3)),'alphaData',zeros(100,100),...
            'UserData',j+(i-1)*4,'ButtonDownFcn',@putPiece,'Visible','on');
    end
end

logsheetR=zeros(1,16);
    function putPiece(object,~)
        object.UserData
        if logsheetR(object.UserData)==0&&handHdl.UserData~=0
            object.CData=handHdl.CData;
            object.AlphaData=handHdl.AlphaData;
            logsheetR(object.UserData)=handHdl.UserData;
            handHdl.UserData=0;
            handHdl.CData=uint8(zeros(100,100,3));
            handHdl.AlphaData=zeros(100,100);
        elseif logsheetR(object.UserData)~=0&&handHdl.UserData==0
            handHdl.UserData=logsheetR(object.UserData);
            handHdl.CData=object.CData;
            handHdl.AlphaData=object.AlphaData;
            logsheetR(object.UserData)=0;
            object.CData=uint8(zeros(100,100,3));
            object.AlphaData=zeros(100,100);
        end
        if all(logsheetR==1:16)
            text1.String='恭喜你，游戏胜利!';
        end
    end



%==========================================================================
                
for i=1:4
    for j=1:4
        tempPiece=resizePic((i-1)*303+1:(i-1)*303+505,(j-1)*303+1:(j-1)*303+505,:);
        if mod(i+j,2)==0     
            tempMask=jigsawMask';
        else
            tempMask=jigsawMask;
        end
        if j==1
            tempMask(:,1:101)=0;
            tempMask(102:404,102:201)=1;
        end
        if j==4
            tempMask(:,405:505)=0;
            tempMask(102:404,304:404)=1;
        end
        if i==1
            tempMask(1:101,:)=0;
            tempMask(102:201,102:404)=1;
        end
        if i==4
            tempMask(405:505,:)=0;
            tempMask(304:404,102:404)=1;
        end
        picHdl(j+(i-1)*4)=image(Mainaxes,[0,100]+(j-1)*100,[0,100]+(i-1)*100,tempPiece,'alphaData',tempMask,...
            'UserData',j+(i-1)*4,'ButtonDownFcn',@selectPiece);
        
        whiteHdl(j+(i-1)*4)=image(Mainaxes,[0,100]+(j-1)*100,[0,100]+(i-1)*100,uint8(240*ones(100,100,3)),'alphaData',ones(100,100),...
            'UserData',[i,j],'ButtonDownFcn',@selectPiece,'Visible','off');
    end
end

RandNum=rand(1,16);
[~,logSheet]=sort(RandNum);

for i=1:4
    for j=1:4
        picHdl(logSheet(j+(i-1)*4)).XData=[0,100]+(j-1)*100;
        picHdl(logSheet(j+(i-1)*4)).YData=[0,100]+(i-1)*100;
    end
end


handHdl=image(Mainaxes,[0,100],[0,100],uint8(zeros(100,100,3)),...
    'alphaData',zeros(100,100),'UserData',0,'PickableParts','none');

    set(gcf,'WindowButtonMotionFcn',@onhandfunc)
    function onhandfunc(~,~)
        xy=get(gca,'CurrentPoint');
        x=xy(1,1);y=xy(1,2);
        handHdl.XData=[x-50,x+50];
        handHdl.YData=[y-50,y+50];  
    end

    function selectPiece(object,~)
        %object.UserData
        if length(object.UserData)==1
            if handHdl.UserData~=0
                picHdl(handHdl.UserData).Visible='on';  
                whiteHdl(logSheet==handHdl.UserData).Visible='off';
            end
            object.Visible='off';
            whiteHdl(logSheet==object.UserData).Visible='on';
            
            handHdl.UserData=object.UserData;
            handHdl.CData=object.CData;
            handHdl.AlphaData=object.AlphaData;
        else
            if handHdl.UserData==0
            else
                ii=object.UserData(1);
                jj=object.UserData(2);
                object.Visible='off';
                picHdl(handHdl.UserData).XData=[0,100]+(jj-1)*100;
                picHdl(handHdl.UserData).YData=[0,100]+(ii-1)*100;
                picHdl(handHdl.UserData).Visible='on';
                logSheet(jj+(ii-1)*4)=handHdl.UserData;
                
                handHdl.UserData=0;
                handHdl.CData=uint8(zeros(100,100,3));
                handHdl.AlphaData=zeros(100,100);              
            end
        end 
    end
%==========================================================================
fill([420,420+14*20,420+14*20,420],[320,320,380,380],[0.9412    0.9412    0.9412],'LineWidth',5,'EdgeColor',[0.7,0.7,0.7])
text1=text(430,350,'请点击拼图块中心位置移动拼图块','fontSize',12);

end
