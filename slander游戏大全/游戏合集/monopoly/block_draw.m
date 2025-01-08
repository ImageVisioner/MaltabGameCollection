function block_draw(ax,x,y,xLen,yLen,Color,String,stringColor,stringSize)
hold(ax,'on');
fill(ax,[x,x+xLen,x+xLen,x],[y,y,y+yLen,y+yLen],Color);
text(ax,x+xLen/2,y+yLen/2,String,'Color',stringColor,'FontSize',stringSize,'HorizontalAlignment','center','FontWeight','bold')
hold(ax,'off');
end