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