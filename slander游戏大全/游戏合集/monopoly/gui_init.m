function [monFig,monAx,diceAx,diceTool,selfTool,monMenuS]=gui_init
monFig=uifigure;
monFig.Position=[10 50 1000 620];
monFig.NumberTitle='off';
monFig.MenuBar='none';
monFig.Resize='off';
monFig.Name='monopoly';

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

diceAx=uiaxes(selfPl);
diceAx.Position=[0 450 145 145];

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


diceTool.Btn=uibutton(monFig);
diceTool.Btn.Text='摇  骰  子';
diceTool.Btn.BackgroundColor=[0.31 0.58 0.80];
diceTool.Btn.FontColor=[1 1 1];
diceTool.Btn.FontWeight='bold';
diceTool.Btn.Position=[180 480 180 40];
diceTool.Btn.FontSize=18;

diceTool.Lbl1=uilabel(monFig);
diceTool.Lbl1.Text='剩余玩家：';
diceTool.Lbl1.FontSize=18;
diceTool.Lbl1.FontColor=[185 184 150]./500;
diceTool.Lbl1.FontWeight='bold';
diceTool.Lbl1.Position=[180 560 180 40];

diceTool.Lbl2=uilabel(monFig);
diceTool.Lbl2.Text='当前轮次：';
diceTool.Lbl2.FontSize=18;
diceTool.Lbl2.FontColor=[185 184 150]./500;
diceTool.Lbl2.FontWeight='bold';
diceTool.Lbl2.Position=[180 530 180 40];

for i=1:4
    selfTool.(['player',num2str(i)]).Img=uiimage(monFig);
    selfTool.(['player',num2str(i)]).Img.Position=[30 400-(i-1)*110 60 60];
    selfTool.(['player',num2str(i)]).Img.ImageSource='图片\player0.png';
    selfTool.(['player',num2str(i)]).Img.UserData=i;
    
    selfTool.(['player',num2str(i)]).Ta=uitextarea(monFig);
    selfTool.(['player',num2str(i)]).Ta.Position=[100 402-(i-1)*110 70 23];
    selfTool.(['player',num2str(i)]).Ta.Value='请输入昵称';
    selfTool.(['player',num2str(i)]).Ta.UserData=i;
    
    selfTool.(['player',num2str(i)]).Ta2=uitextarea(monFig);
    selfTool.(['player',num2str(i)]).Ta2.Position=[180 433-(i-1)*110 180 25];
    selfTool.(['player',num2str(i)]).Ta2.Value='';
    selfTool.(['player',num2str(i)]).Ta2.Enable='off';
    
    selfTool.(['player',num2str(i)]).Btn=uibutton(monFig);
    selfTool.(['player',num2str(i)]).Btn.Position=[100 435-(i-1)*110 70 23];
    selfTool.(['player',num2str(i)]).Btn.Text=' 购买地产 ';
    selfTool.(['player',num2str(i)]).Btn.BackgroundColor=[0.31 0.58 0.80];
    selfTool.(['player',num2str(i)]).Btn.FontColor=[1 1 1];
    selfTool.(['player',num2str(i)]).Btn.FontWeight='bold';
    selfTool.(['player',num2str(i)]).Btn.UserData=i;
    
    selfTool.(['player',num2str(i)]).Lb=uilistbox(monFig);
    selfTool.(['player',num2str(i)]).Lb.Position=[180 355-(i-1)*110 180 78];
    selfTool.(['player',num2str(i)]).Lb.Items={'地产一(空)','地产二(空)','地产三(空)','... ...'};
    
    selfTool.(['player',num2str(i)]).Txt=uilabel(monFig);
    selfTool.(['player',num2str(i)]).Txt.Position=[30 370-(i-1)*110 140 30];
    selfTool.(['player',num2str(i)]).Txt.Text='资金 ：0 ';
    selfTool.(['player',num2str(i)]).Txt.FontColor=[185 184 150]./500;
    selfTool.(['player',num2str(i)]).Txt.FontWeight='bold';
    selfTool.(['player',num2str(i)]).Txt.FontSize=14;
end

monMenu=uimenu(monFig);
monMenu.Text='开始游戏';


monMenuS.m2=uimenu(monMenu);
monMenuS.m2.Text='二人游戏';

monMenuS.m3=uimenu(monMenu);
monMenuS.m3.Text='三人游戏';

monMenuS.m4=uimenu(monMenu);
monMenuS.m4.Text='四人游戏';
end