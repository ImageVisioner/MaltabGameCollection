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
    tempTime=clock();
    second=round(tempTime(6)+60*tempTime(5)+24*60*tempTime(4));
    rng(second)
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

