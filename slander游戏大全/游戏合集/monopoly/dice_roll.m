function diceHdl=dice_roll(ax,num,diceHdl)
for i=1:2
    for j=1:6
        diceHdl=dice_draw(ax,j,diceHdl);
        pause(0.05)
    end
end
diceHdl=dice_draw(ax,num,diceHdl);
end