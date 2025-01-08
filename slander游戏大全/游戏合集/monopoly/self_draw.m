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