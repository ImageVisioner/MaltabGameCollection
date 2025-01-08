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