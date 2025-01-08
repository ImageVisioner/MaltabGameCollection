%% ����MATLABʵ��
%  ʹ��MATLABʵ���˴�����Ϸ�Ļ�������
%  ֧���Զ������ͷ���������������صȹ���

%% ������(main)
function monopoly_main
%����ȫ�ֱ���
global aliveList nameList presentPlayer owenerList
global self selfHdl diceHdl


%�����ʼ��
[~,monAx,diceAx,diceTool,selfTool,monMenuS]=gui_init();

%���Ƶ�ͼ
blockData=block_load();
for i=1:size(blockData,1)
    block_draw(monAx,blockData{i,:})
end

%��������------------------------------------------------------------------
diceHdl=dice_draw(diceAx,6);
set(diceTool.Btn,'ButtonPushedFcn',@diceRoll);
function diceRoll(~,~)
    diceNum=randi(6);
    diceHdl=dice_roll(diceAx,diceNum,diceHdl);
    if strcmp(monMenuS.m2.Parent.Text,'���¿�ʼ')
        oriPos=self.(['player',num2str(aliveList(presentPlayer))]).pos;
        for ii=1:diceNum
            self.(['player',num2str(aliveList(presentPlayer))]).pos=self.(['player',num2str(aliveList(presentPlayer))]).pos+1;
            self.(['player',num2str(aliveList(presentPlayer))]).pos=mod(self.(['player',num2str(aliveList(presentPlayer))]).pos,size(blockData,1));
            selfHdl=self_draw(monAx,self,blockData,selfHdl);
            pause(0.25)
        end
        newPos=self.(['player',num2str(aliveList(presentPlayer))]).pos;
        
        [self,owenerList,aliveList]=action_exchange(self,selfTool,diceTool,oriPos,newPos,aliveList(presentPlayer),blockData,owenerList,aliveList,nameList);
        
        
        selfHdl=self_draw(monAx,self,blockData,selfHdl);
        self_updata(self,selfTool)
        
        presentPlayer(presentPlayer>length(aliveList))=length(aliveList);
        presentPlayer=mod(presentPlayer+1,length(aliveList));
        presentPlayer(presentPlayer==0)=length(aliveList);
        
        diceTool.Lbl2.Text=['��ǰ�ִΣ�',nameList{aliveList(presentPlayer)}]; 
    end
end

%�����ص�------------------------------------------------------------------
nameList={'���1','���2','���3','���4'};
for i=1:4
    set(selfTool.(['player',num2str(i)]).Ta,'ValueChangedFcn',@reName);
end
function reName(~,obj)
    reNameBox=obj.Source;
    n=reNameBox.UserData;
    nameList(n)=reNameBox.Value;
    if strcmp(monMenuS.m2.Parent.Text,'���¿�ʼ')
        diceTool.Lbl2.Text=['��ǰ�ִΣ�',nameList{aliveList(presentPlayer)}]; 
    end
end


%��ͼ�ص�------------------------------------------------------------------
for i=1:4
    set(selfTool.(['player',num2str(i)]).Img,'ImageClickedFcn',@chPic);
end
function chPic(~,obj)
    picBox=obj.Source;
    n=picBox.UserData;
    [filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
            '*.*','All Files' });
    if filename~=0
        selfTool.(['player',num2str(n)]).Img.ImageSource=[pathname,filename];
    end
end


%��ť�ص�------------------------------------------------------------------
for i=1:4
    set(selfTool.(['player',num2str(i)]).Btn,'ButtonPushedFcn',@buy_estate);
end
function buy_estate(~,obj)
    btn=obj.Source;
    n=btn.UserData;
    DataStr=selfTool.(['player',num2str(n)]).Ta2.Value{:};
    if ~strcmp(DataStr,'')
        bp=regexp(DataStr,'B:')+2;
        tp=regexp(DataStr,'T:')-2;
        price=str2num(DataStr(bp:tp));
        if self.(['player',num2str(n)]).property-price>=0
            NameS=DataStr(1:(bp-2));
            if strcmp(DataStr(end),'1')
                self.(['player',num2str(n)]).property=self.(['player',num2str(n)]).property-price;
                self.(['player',num2str(n)]).real_estate(self.(['player',num2str(n)]).estateNum+1)={selfTool.(['player',num2str(n)]).Ta2.Value{:}};
                self.(['player',num2str(n)]).estateNum=self.(['player',num2str(n)]).estateNum+1;  
                for ii=1:4
                    DataStrO=selfTool.(['player',num2str(ii)]).Ta2.Value{:};
                    if ~strcmp(DataStrO,'')
                        NameO=DataStrO(1:(bp-2));
                        if strcmp(NameS,NameO)
                            selfTool.(['player',num2str(ii)]).Ta2.Value='';
                        end
                    end
                end
                owenerList=[owenerList;self.(['player',num2str(n)]).pos,n,1];
            else
                for ii=1:self.(['player',num2str(n)]).estateNum
                    DataStrS=self.(['player',num2str(n)]).real_estate{ii};
                    NameSab=DataStrS(1:(bp-2));
                    if strcmp(NameS,NameSab)
                        self.(['player',num2str(n)]).real_estate(ii)={selfTool.(['player',num2str(n)]).Ta2.Value{:}};
                    end   
                end
                stag=str2num(DataStr(end));
                owenerPos=owenerList(:,1)==self.(['player',num2str(n)]).pos;
                owenerList(owenerPos,:)=[self.(['player',num2str(n)]).pos,n,stag];
                selfTool.(['player',num2str(n)]).Ta2.Value='';
            end
            self_updata(self,selfTool)
        end
    end
end

%��ʼ��Ϸ�ص�--------------------------------------------------------------
for i=2:4
    set(monMenuS.(['m',num2str(i)]),'MenuSelectedFcn',@game_init)
end



%==========================================================================
    function game_init(~,obj)
        %��ȡ��Ϸ����
        selectedMenu=obj.Source;
        switch 1
            case strcmp(selectedMenu.Text,'������Ϸ'),playerNum=2;
            case strcmp(selectedMenu.Text,'������Ϸ'),playerNum=3;
            case strcmp(selectedMenu.Text,'������Ϸ'),playerNum=4;
        end
        %��ʼ�����������Ϣ
        self=self_init(playerNum);
        
        %��ʼ������ģ��
        if strcmp(selectedMenu.Parent.Text,'���¿�ʼ')
            selfHdl=self_draw(monAx,self,blockData,selfHdl);
            nameList={'���1','���2','���3','���4'};
        else
            selfHdl=self_draw(monAx,self,blockData);
        end
        
        %���ÿ�ʼ��Ϸѡ��
        selectedMenu.Parent.Text='���¿�ʼ';
        
        %������Ϣ����
        aliveList=1:playerNum;
        presentPlayer=1;
        %owenerList=[pos,owner,stage];
        owenerList=[0 0 0];
        owenerList(1,:)=[];
        
        
        %������
        for ii=1:playerNum
            if ~strcmp(selfTool.(['player',num2str(ii)]).Ta.Value,'�������ǳ�')
                nameList(ii)=selfTool.(['player',num2str(ii)]).Ta.Value;
            end
            if strcmp(selfTool.(['player',num2str(ii)]).Img.ImageSource,'ͼƬ\player0.png')
                selfTool.(['player',num2str(ii)]).Img.ImageSource=['ͼƬ\player',num2str(ii),'.png'];
            end
            selfTool.(['player',num2str(ii)]).Ta.Enable = 'on';
            
            selfTool.(['player',num2str(ii)]).Lb.Items={};
            selfTool.(['player',num2str(ii)]).Txt.Text=['�ʽ� ��',num2str(self.(['player',num2str(ii)]).property)];
            selfTool.(['player',num2str(ii)]).Ta.Value=nameList{ii};
            selfTool.(['player',num2str(ii)]).Lb.Enable ='on';
            selfTool.(['player',num2str(ii)]).Btn.Enable='on';
            selfTool.(['player',num2str(ii)]).Img.Enable='on';
            selfTool.(['player',num2str(ii)]).Txt.Enable='on';
            
            selfTool.(['player',num2str(ii)]).Ta2.Value='';
        end
        for ii=4:-1:(playerNum+1)
            nameList(ii)=[];
            selfTool.(['player',num2str(ii)]).Ta.Value='�������ǳ�';
            selfTool.(['player',num2str(ii)]).Ta.Enable = 'off';
            
            selfTool.(['player',num2str(ii)]).Lb.Items={'�ز�һ(��)','�ز���(��)','�ز���(��)','... ...'};
            selfTool.(['player',num2str(ii)]).Lb.Enable ='off';
            selfTool.(['player',num2str(ii)]).Btn.Enable='off';
            
            selfTool.(['player',num2str(ii)]).Img.ImageSource='ͼƬ\player0.png';
            selfTool.(['player',num2str(ii)]).Img.Enable='off';
            
            selfTool.(['player',num2str(ii)]).Txt.Text='�ʽ� ��0 ';
            selfTool.(['player',num2str(ii)]).Txt.Enable='off';
            
            selfTool.(['player',num2str(ii)]).Ta2.Value='';
        end
        diceTool.Lbl1.Text=['ʣ����ң�',num2str(length(aliveList))];
        diceTool.Lbl2.Text=['��ǰ�ִΣ�',nameList{aliveList(presentPlayer)}];     
    end
end

%% ����UI���
%  ʵ��ʹ��App designer�ؼ�
%  ����uifigure��uiaxes����ť���˵����������Ϣ��
function [monFig,monAx,diceAx,diceTool,selfTool,monMenuS]=gui_init
%uifigure����
monFig=uifigure;
monFig.Position=[10 50 1000 620];
monFig.NumberTitle='off';
monFig.MenuBar='none';
monFig.Resize='off';
monFig.Name='monopoly';

%��ͼ����uiaxes����
monAx=uiaxes(monFig);
monAx.PlotBoxAspectRatio=[1 1 1];
monAx.Position=[380 10 600 600];
%monAx.Box='on';
monAx.XLim=[0 100];
monAx.YLim=[0 100];
%monAx.Color=[0.9 0.9 0.9];
monAx.XColor=[0.95,0.95,0.95];
monAx.YColor=[0.95,0.95,0.95];
monAx.Toolbar.Visible='off';

selfPl=uipanel(monFig);
selfPl.Title='';
selfPl.Position=[10 10 370 600];

%���Ӳ���uiaxes����
diceAx=uiaxes(monFig);
diceAx.Position=[15 460 145 145];
diceAx.XLim=[0 10];
diceAx.YLim=[0 10];
diceAx.Color=[0.98 0.98 0.98];
diceAx.XColor=[0.95,0.95,0.95];
diceAx.YColor=[0.95,0.95,0.95];
diceAx.Toolbar.Visible='off';
hold(diceAx,'on')
plot(diceAx,[2,8],[1,1],'k','LineWidth',2)
plot(diceAx,[2,8],[9,9],'k','LineWidth',2)
plot(diceAx,[1,1],[2,8],'k','LineWidth',2)
plot(diceAx,[9,9],[2,8],'k','LineWidth',2)
plot(diceAx,8+cos(0+(0:pi/(2*10):pi/2)),8+sin(0+(0:pi/(2*10):pi/2)),'k','LineWidth',2)
plot(diceAx,2+cos(pi/2+(0:pi/(2*10):pi/2)),8+sin(pi/2+(0:pi/(2*10):pi/2)),'k','LineWidth',2)
plot(diceAx,2+cos(pi+(0:pi/(2*10):pi/2)),2+sin(pi+(0:pi/(2*10):pi/2)),'k','LineWidth',2)
plot(diceAx,8+cos(-pi/2+(0:pi/(2*10):pi/2)),2+sin(-pi/2+(0:pi/(2*10):pi/2)),'k','LineWidth',2)
hold(diceAx,'off')

%ҡ���Ӱ�ť����
diceTool.Btn=uibutton(monFig);
diceTool.Btn.Text='ҡ  ��  ��';
diceTool.Btn.BackgroundColor=[0.31 0.58 0.80];
diceTool.Btn.FontColor=[1 1 1];
diceTool.Btn.FontWeight='bold';
diceTool.Btn.Position=[180 480 180 40];
diceTool.Btn.FontSize=18;

%�������Ϣ������
diceTool.Lbl1=uilabel(monFig);
diceTool.Lbl1.Text='ʣ����ң�';
diceTool.Lbl1.FontSize=18;
diceTool.Lbl1.FontColor=[185 184 150]./500;
diceTool.Lbl1.FontWeight='bold';
diceTool.Lbl1.Position=[180 560 180 40];

diceTool.Lbl2=uilabel(monFig);
diceTool.Lbl2.Text='��ǰ�ִΣ�';
diceTool.Lbl2.FontSize=18;
diceTool.Lbl2.FontColor=[185 184 150]./500;
diceTool.Lbl2.FontWeight='bold';
diceTool.Lbl2.Position=[180 530 180 40];

%��Ҹ�����Ϣ������
for i=1:4
    selfTool.(['player',num2str(i)]).Img=uiimage(monFig);
    selfTool.(['player',num2str(i)]).Img.Position=[30 400-(i-1)*110 60 60];
    selfTool.(['player',num2str(i)]).Img.ImageSource='ͼƬ\player0.png';
    selfTool.(['player',num2str(i)]).Img.UserData=i;
    
    selfTool.(['player',num2str(i)]).Ta=uitextarea(monFig);
    selfTool.(['player',num2str(i)]).Ta.Position=[100 402-(i-1)*110 70 23];
    selfTool.(['player',num2str(i)]).Ta.Value='�������ǳ�';
    selfTool.(['player',num2str(i)]).Ta.UserData=i;
    
    selfTool.(['player',num2str(i)]).Ta2=uitextarea(monFig);
    selfTool.(['player',num2str(i)]).Ta2.Position=[180 433-(i-1)*110 180 25];
    selfTool.(['player',num2str(i)]).Ta2.Value='';
    selfTool.(['player',num2str(i)]).Ta2.Enable='off';
    
    selfTool.(['player',num2str(i)]).Btn=uibutton(monFig);
    selfTool.(['player',num2str(i)]).Btn.Position=[100 435-(i-1)*110 70 23];
    selfTool.(['player',num2str(i)]).Btn.Text=' ����ز� ';
    selfTool.(['player',num2str(i)]).Btn.BackgroundColor=[0.31 0.58 0.80];
    selfTool.(['player',num2str(i)]).Btn.FontColor=[1 1 1];
    selfTool.(['player',num2str(i)]).Btn.FontWeight='bold';
    selfTool.(['player',num2str(i)]).Btn.UserData=i;
    
    selfTool.(['player',num2str(i)]).Lb=uilistbox(monFig);
    selfTool.(['player',num2str(i)]).Lb.Position=[180 355-(i-1)*110 180 78];
    selfTool.(['player',num2str(i)]).Lb.Items={'�ز�һ(��)','�ز���(��)','�ز���(��)','... ...'};
    
    selfTool.(['player',num2str(i)]).Txt=uilabel(monFig);
    selfTool.(['player',num2str(i)]).Txt.Position=[30 370-(i-1)*110 140 30];
    selfTool.(['player',num2str(i)]).Txt.Text='�ʽ� ��0 ';
    selfTool.(['player',num2str(i)]).Txt.FontColor=[185 184 150]./500;
    selfTool.(['player',num2str(i)]).Txt.FontWeight='bold';
    selfTool.(['player',num2str(i)]).Txt.FontSize=14;
end


%�˵�������
monMenu=uimenu(monFig);
monMenu.Text='��ʼ��Ϸ';


monMenuS.m2=uimenu(monMenu);
monMenuS.m2.Text='������Ϸ';

monMenuS.m3=uimenu(monMenu);
monMenuS.m3.Text='������Ϸ';

monMenuS.m4=uimenu(monMenu);
monMenuS.m4.Text='������Ϸ';
end

%% ��Ƭ��Ϣ����
%  ��ͼ��Ϣ
function blockData=block_load
blockData={90,0,10,10,[1.0000    0.3451    0.3765],'���',[1.0000    0.9647    0.7725],24;
           80,0,10,10,[0.9725    0.7961    0.7922],'1'   ,[1 1 1],32;
           70,0,10,10,[0.8627    0.7608    0.7961],'2'   ,[1 1 1],32;
           
           60,0,10,10,[0.31      0.58      0.80  ].*1.1,'�շ�վ'   ,[1 1 1],16;
           
           50,0,10,10,[0.9294    0.8941    0.6196],'4'   ,[1 1 1],32;
           40,0,10,10,[0.9412    0.8588    0.7098],'5'   ,[1 1 1],32;
           
           30,0,10,10,[0.9882    0.5451    0.5765],'6'   ,[1 1 1],32;
           20,0,10,10,[0.9725    0.7961    0.7922],'7'   ,[1 1 1],32;
           10,0,10,10,[255 110 151 ]./255,{'ǰ��';'����'}   ,[1 0.9 0.8],17;
           0,0,10,10,[0.7451    0.8353    0.8824],'9'   ,[1 1 1],32;
           0,10,10,10,[0.31      0.58      0.80  ].*1.1,{'ɭ��';'��԰'}   ,[1 1 1],16;
           0,20,10,10,[0.9412    0.8588    0.7098],'11'   ,[1 1 1],32;
           
           10,20,10,10,[0.9882    0.5451    0.5765],'12'   ,[1 1 1],32;
           20,20,10,10,[0.31      0.58      0.80  ].*1.1,'����'   ,[1 1 1],16;
           30,20,10,10,[0.8627    0.7608    0.7961],'14'   ,[1 1 1],32;
           40,20,10,10,[0.7451    0.8353    0.8824],'15'   ,[1 1 1],32;
           50,20,10,10,[0.9294    0.8941    0.6196],'16'   ,[1 1 1],32;
           60,20,10,10,[0.9412    0.8588    0.7098],'17'   ,[1 1 1],32;
           
           60,30,10,10,[0.9882    0.5451    0.5765],'18'   ,[1 1 1],32;
           60,40,10,10,[255 110 151 ]./255,{'ǰ��';'����'}   ,[1 0.9 0.8],17;
           50,40,10,10,[0.31      0.58      0.80  ].*1.1,{'����';'����'}   ,[1 1 1],16;
           40,40,10,10,[0.7451    0.8353    0.8824],'21'   ,[1 1 1],32;
           30,40,10,10,[0.9294    0.8941    0.6196],'22'   ,[1 1 1],32;
           20,40,10,10,[0.9412    0.8588    0.7098],'23'   ,[1 1 1],32;
           
           
           10,40,10,10,[0.9882    0.5451    0.5765],'24'   ,[1 1 1],32;
           0,40,10,10,[0.9725    0.7961    0.7922],'25'   ,[1 1 1],32;
           0,50,10,10,[0.8627    0.7608    0.7961],'26'   ,[1 1 1],32;
           0,60,10,10,[0.31      0.58      0.80  ].*1.1,{'�Ӻ�';'��԰'}   ,[1 1 1],16;
           0,70,10,10,[0.9294    0.8941    0.6196],'28'   ,[1 1 1],32;
           0,80,10,10,[0.9412    0.8588    0.7098],'29'   ,[1 1 1],32;
           
           0,90,10,10,[0.9882    0.5451    0.5765],'30'   ,[1 1 1],32;
           10,90,10,10,[0.9725    0.7961    0.7922],'31'   ,[1 1 1],32;
           20,90,10,10,[0.8627    0.7608    0.7961],'32'   ,[1 1 1],32;
           20,80,10,10,[0.7451    0.8353    0.8824],'33'   ,[1 1 1],32;
           20,70,10,10,[0.9294    0.8941    0.6196],'34'   ,[1 1 1],32;
           20,60,10,10,[0.9412    0.8588    0.7098],'35'   ,[1 1 1],32;
           
           30,60,10,10,[0.9882    0.5451    0.5765],'36'   ,[1 1 1],32;
           40,60,10,10,[0.9725    0.7961    0.7922],'37'   ,[1 1 1],32;
           40,70,10,10,[0.31      0.58      0.80  ].*1.1,{'����';'����'}   ,[1 1 1],16;
           40,80,10,10,[0.7451    0.8353    0.8824],'39'   ,[1 1 1],32;
           40,90,10,10,[0.9294    0.8941    0.6196],'40'   ,[1 1 1],32;
           50,90,10,10,[0.9412    0.8588    0.7098],'41'   ,[1 1 1],32;
           
           60,90,10,10,[0.9882    0.5451    0.5765],'42'   ,[1 1 1],32;
           70,90,10,10,[0.9725    0.7961    0.7922],'43'   ,[1 1 1],32;
           80,90,10,10,[0.8627    0.7608    0.7961],'44'   ,[1 1 1],32;
           90,90,10,10,[0.7451    0.8353    0.8824],'45'   ,[1 1 1],32;
           90,80,10,10,[0.9294    0.8941    0.6196],'46'   ,[1 1 1],32;
           90,70,10,10,[0.9412    0.8588    0.7098],'47'   ,[1 1 1],32;
           
           80,70,10,10,[0.9882    0.5451    0.5765],'48'   ,[1 1 1],32;
           80,60,10,10,[0.9725    0.7961    0.7922],'49'   ,[1 1 1],32;
           80,50,10,10,[0.31      0.58      0.80  ].*1.1,{'����';'��԰'}   ,[1 1 1],16;
           80,40,10,10,[0.7451    0.8353    0.8824],'51'   ,[1 1 1],32;
           80,30,10,10,[0.9294    0.8941    0.6196],'52'   ,[1 1 1],32;
           80,20,10,10,[255 110 151 ]./255,{'ǰ��';'����'}   ,[1 0.9 0.8],17;
           
           90,20,10,10,[0.9882    0.5451    0.5765],'48'   ,[1 1 1],32;
           90,10,10,10,[0.9725    0.7961    0.7922],'49'   ,[1 1 1],32;};
end

%% ��Ƭ����
function block_draw(ax,x,y,xLen,yLen,Color,String,stringColor,stringSize)
hold(ax,'on');
fill(ax,[x,x+xLen,x+xLen,x],[y,y,y+yLen,y+yLen],Color);
text(ax,x+xLen/2,y+yLen/2,String,'Color',stringColor,'FontSize',stringSize,'HorizontalAlignment','center','FontWeight','bold')
hold(ax,'off');
end
%% �������������
%  ����1~6��Χ�������������ҡ���ӽ��
function diceHdl=dice_roll(ax,num,diceHdl)
for i=1:2
    for j=1:6
        diceHdl=dice_draw(ax,j,diceHdl);
        pause(0.05)
    end
end
diceHdl=dice_draw(ax,num,diceHdl);
end
%% �����ػ���
function diceHdl=dice_draw(ax,num,diceHdl)
hold(ax,'on');
if nargin==3
    delete(diceHdl);
end
switch num
    case 1,diceHdl=scatter(ax,5,5,300,[0.8 0 0],'filled');
    case 2,diceHdl=scatter(ax,[3,7],[3,7],150,'k','filled');
    case 3,diceHdl=scatter(ax,[3,7,5],[3,7,5],150,'k','filled');
    case 4,diceHdl=scatter(ax,[3,7,3,7],[3,3,7,7],150,'k','filled');
    case 5,diceHdl=scatter(ax,[3,7,3,7,5],[3,3,7,7,5],150,'k','filled');
    case 6,diceHdl=scatter(ax,[3,7,3,7,3,7],[3,3,5,5,7,7],150,'k','filled');
end
hold(ax,'off');
end
%% �����Ϣ��ʼ��
function self=self_init(n)
for i=1:4
    self.(['player',num2str(i)]).property=5000;
    self.(['player',num2str(i)]).pos=0;
    self.(['player',num2str(i)]).real_estate={};
    self.(['player',num2str(i)]).estateNum=0;
    if i>n
        self.(['player',num2str(i)]).gameOver=1;
    else
        self.(['player',num2str(i)]).gameOver=0;
    end
    self.(['player',num2str(i)]).name=['���',num2str(i)];
end
end
%% �����Ϣ����
function self_updata(self,selfTool)
for i=1:4
    if (self.(['player',num2str(i)]).gameOver==0)
        selfTool.(['player',num2str(i)]).Txt.Text=['�ʽ� ��',num2str(self.(['player',num2str(i)]).property)];  
        selfTool.(['player',num2str(i)]).Lb.Items=self.(['player',num2str(i)]).real_estate;
    else
        %self.(['player',num2str(i)]).real_estate={};
    end
end
end
%% �����Ϣ���ػ���
function selfHdl=self_draw(ax,self,blockData,selfHdl)
posList=[1.5 1.5;1.5 8.5;8.5 8.5;8.5 1.5];
colorList=[205 50 120;122 103 238;255 242 157;25 202 173 ]./255;

hold(ax,'on')
if nargin<4
    for i=1:4
        selfHdl(i)=scatter(ax,[],[],120,'filled','CData',colorList(i,:),'LineWidth',2,'MarkerEdgeColor',[0.3 0.3 0.3]);
    end
end
for i=1:4
    if self.(['player',num2str(i)]).gameOver==0
        tempPos=self.(['player',num2str(i)]).pos;
        tempPos=[blockData{tempPos+1,1},blockData{tempPos+1,2}];
        set(selfHdl(i),'XData',tempPos(1)+posList(i,1),'YData',tempPos(2)+posList(i,2));
    else
        set(selfHdl(i),'XData',[],'YData',[]);
    end
end
hold(ax,'off')
end
%% �����Ϊ�ж�����
function [self,owenerList,aliveList]=action_exchange(self,selfTool,diceTool,oriPos,newPos,numNum,blockData,owenerList,aliveList,nameList)
type=[1200 1000 1300 1400 1400 1600 0 0;
      1000 1000 1000 1200 1000 1400 0 0;
      2000 1500 1000 1600 1000 1800 0 0];
Ty=0;
SetName=[];
if oriPos>newPos
    self.(['player',num2str(numNum)]).property=self.(['player',num2str(numNum)]).property+2000;
end
if size(blockData{newPos+1,6},1)==2
    tempCell=blockData{newPos+1,6};
    switch 1
        case strcmp(tempCell{2},'����')
            self.(['player',num2str(numNum)]).pos=self.(['player',num2str(numNum)]).pos+3;
            self.(['player',num2str(numNum)]).pos=mod(self.(['player',num2str(numNum)]).pos,size(blockData,1));
            pause(0.2)
        case strcmp(tempCell{2},'����')
            self.(['player',num2str(numNum)]).pos=self.(['player',num2str(numNum)]).pos+2;
            self.(['player',num2str(numNum)]).pos=mod(self.(['player',num2str(numNum)]).pos,size(blockData,1));
            pause(0.2)
        case strcmp(tempCell{1},'ɭ��'),Ty=3;SetName=[tempCell{1},tempCell{2}];
        case strcmp(tempCell{1},'����'),Ty=2;SetName=[tempCell{1},tempCell{2}];
        case strcmp(tempCell{1},'�Ӻ�'),Ty=3;SetName=[tempCell{1},tempCell{2}];
        case strcmp(tempCell{1},'����'),Ty=2;SetName=[tempCell{1},tempCell{2}];
        case strcmp(tempCell{1},'����'),Ty=3;SetName=[tempCell{1},tempCell{2}];
    end
else
    tempStr=blockData{newPos+1,6};
    switch 1
        case strcmp(tempStr,'�շ�վ'),Ty=1;SetName=[tempStr,'��'];
        case strcmp(tempStr,'����'),  Ty=1;SetName=[tempStr,'����'];
    end
end
if Ty~=0
    tempPos=find(owenerList(:,1)==newPos);
    switch 1
        case isempty(tempPos)
            selfTool.(['player',num2str(numNum)]).Ta2.Value=[SetName,' B:',num2str(type(Ty,1)),' T:',num2str(type(Ty,2)),' #',num2str(Ty),' 1'];
        case (~isempty(tempPos))&&owenerList(tempPos,2)==numNum 
            if type(Ty,(owenerList(tempPos,3)+1)*2)~=0
                selfTool.(['player',num2str(numNum)]).Ta2.Value=[SetName,' B:',num2str(type(Ty,(owenerList(tempPos,3)+1)*2-1)),' T:',num2str(type(Ty,(owenerList(tempPos,3)+1)*2)),' #',num2str(Ty),' ',num2str(owenerList(tempPos,3)+1)];
            else
                selfTool.(['player',num2str(numNum)]).Ta2.Value='';
            end
        case (~isempty(tempPos))&&owenerList(tempPos,2)~=numNum
            selfTool.(['player',num2str(numNum)]).Ta2.Value=['#֧�� ',nameList{owenerList(tempPos,2)},' �ʽ�:',num2str(type(Ty,owenerList(tempPos,3)*2)),'#'];
            self.(['player',num2str(numNum)]).property=self.(['player',num2str(numNum)]).property-type(Ty,owenerList(tempPos,3)*2);    
            self.(['player',num2str(owenerList(tempPos,2))]).property=self.(['player',num2str(owenerList(tempPos,2))]).property+type(Ty,owenerList(tempPos,3)*2); 
            
    end
else
    selfTool.(['player',num2str(numNum)]).Ta2.Value='';
end


    if self.(['player',num2str(numNum)]).gameOver==0
        if self.(['player',num2str(numNum)]).property<0
           self.(['player',num2str(numNum)]).gameOver=1;
           owenerList(owenerList(:,2)==numNum)=[];
           self.(['player',num2str(numNum)]).real_estate={};
           self.(['player',num2str(numNum)]).estateNum=0;
           self.(['player',num2str(numNum)]).pos=[];
           
           aliveList(aliveList==numNum)=[];
           
            selfTool.(['player',num2str(numNum)]).Ta.Enable = 'off';
            
            selfTool.(['player',num2str(numNum)]).Lb.Items={'�ز�һ(��)','�ز���(��)','�ز���(��)','... ...'};
            selfTool.(['player',num2str(numNum)]).Lb.Enable ='off';
            selfTool.(['player',num2str(numNum)]).Btn.Enable='off';
            
            selfTool.(['player',num2str(numNum)]).Img.Enable='off';
            
            selfTool.(['player',num2str(numNum)]).Txt.Text='�ʽ� ����ծ�˳���Ϸ ';
            selfTool.(['player',num2str(numNum)]).Txt.Enable='off';
            
            selfTool.(['player',num2str(numNum)]).Ta2.Value='';
            diceTool.Lbl1.Text=['ʣ����ң�',num2str(length(aliveList))];
        end
    end  
end