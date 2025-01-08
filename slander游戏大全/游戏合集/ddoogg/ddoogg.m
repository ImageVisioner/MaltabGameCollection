function ddoogg
ddooggFig=uifigure('units','pixels',...
    'position',[320 120 360 400],...
    'Numbertitle','off',...
    'menubar','none',...
    'resize','off',...
    'name','ddoogg',...
    'color',[0.98 0.98 0.98]);

bkgLabel=uilabel(ddooggFig);
bkgLabel.Position=[10 10 340 340];
bkgLabel.Text='';
bkgLabel.BackgroundColor=[193 214 232]./255;


%���ƹ����ͻ�ʤ��ǩ========================================================
dogMat=ones(5,5); %���ݾ���
imgSource={'images\doga.png','images\dogb.png'}; %����ͼƬ����
bkgColor=[[252 251 238]./255;[222 248 252]./255];%����ͼ������ɫ

%����5x5��uiimage�ؼ�
for i=1:5
    for j=1:5
        dogMatHdl(i,j)=uiimage(ddooggFig);
        dogMatHdl(i,j).Position=[20+65*(j-1),280-65*(i-1),60,60];
        dogMatHdl(i,j).ImageSource=imgSource{1};
        dogMatHdl(i,j).BackgroundColor=bkgColor(1,:);
        dogMatHdl(i,j).UserData=[i,j];
    end
end

%��ʤ��ǩ
win=false; %�Ƿ������Ϸ
winLabel=uilabel(ddooggFig);
winLabel.Position=[15 150 330 60];
winLabel.Text='��ϲ�������⣬�������¿�ʼ';
winLabel.BackgroundColor=[238 236 225]./255;
winLabel.FontSize=19;
winLabel.FontWeight='bold';
winLabel.HorizontalAlignment='center';
winLabel.FontColor=[113 106 63]./255;
winLabel.Visible='off';


%����uiimage�ص�
set(dogMatHdl,'ImageClickedFcn',@clickDog)
    function clickDog(~,event)
        if ~win
            objNum=event.Source.UserData;
            crossList=[-1 0;0 1;1 0;0 -1;0 0];
            for ii=1:5
                changePos=crossList(ii,:)+objNum;
                if all(changePos>=1&changePos<=5)
                    dogMat(changePos(1),changePos(2))=mod(dogMat(changePos(1),changePos(2)),2)+1;
                    dogMatHdl(changePos(1),changePos(2)).ImageSource=imgSource{dogMat(changePos(1),changePos(2))};
                    dogMatHdl(changePos(1),changePos(2)).BackgroundColor=bkgColor(dogMat(changePos(1),changePos(2)),:);
                end
            end
            if all(all(dogMat==1))||all(all(dogMat==2))
                win=true;
                winLabel.Visible='on';
            end
        end
    end

%��Ϸ�ȼ���ť==============================================================
gameLevel=1; %��Ϸ�Ѷȼ���
%�����ѶȰ�ť����
levelBtn(1)=uibutton(ddooggFig);
levelBtn(1).Position=[10,360,75,30];
levelBtn(1).Text='����';
levelBtn(1).FontWeight='bold';
levelBtn(1).FontSize=14;
levelBtn(1).BackgroundColor=[13 141 209]./255;
levelBtn(1).FontColor=[1 1 1];
levelBtn(1).UserData=1;
%�м��ѶȰ�ť����
levelBtn(2)=uibutton(ddooggFig);
levelBtn(2).Position=[95,360,75,30];
levelBtn(2).Text='�м�';
levelBtn(2).FontWeight='bold';
levelBtn(2).FontSize=14;
levelBtn(2).BackgroundColor=[2 164 173]./255;
levelBtn(2).FontColor=[1 1 1];
levelBtn(2).UserData=2;
%�߼��ѶȰ�ť����
levelBtn(3)=uibutton(ddooggFig);
levelBtn(3).Position=[180,360,75,30];
levelBtn(3).Text='�߼�';
levelBtn(3).FontWeight='bold';
levelBtn(3).FontSize=14;
levelBtn(3).BackgroundColor=[2 164 173]./255;
levelBtn(3).FontColor=[1 1 1];
levelBtn(3).UserData=3;
%�����Ѷ�ѡ��ص�
set(levelBtn,'ButtonPushedFcn',@changeLevel)
    function changeLevel(~,event)
        levelBtn(gameLevel).BackgroundColor=[2 164 173]./255;
        objNum=event.Source.UserData;
        gameLevel=objNum;
        levelBtn(gameLevel).BackgroundColor=[13 141 209]./255;   
    end


%ˢ����Ϸ��ť==============================================================
restartBtn=uibutton(ddooggFig);
restartBtn.Position=[265,360,85,30];
restartBtn.Text='���¿�ʼ';
restartBtn.FontWeight='bold';
restartBtn.FontSize=14;
restartBtn.BackgroundColor=[2 164 173]./255;
restartBtn.FontColor=[1 1 1];
%����ˢ����Ϸ�ص�
set(restartBtn,'ButtonPushedFcn',@restart)
    function restart(~,~)
        win=false;
        winLabel.Visible='off';
        dogMat=ones(5,5);
        for ii=1:5
            for jj=1:5
                dogMatHdl(ii,jj).ImageSource=imgSource{1};
                dogMatHdl(ii,jj).BackgroundColor=bkgColor(1,:);
            end
        end
        switch gameLevel
            case 1,changeTimes=3;
            case 2,changeTimes=5;
            case 3,changeTimes=11;
        end
        for ii=1:changeTimes
            changePos=randi([1,5],[1,2]);
            simEvent.Source.UserData=changePos;
            clickDog([],simEvent)
        end
    end
restart()
end