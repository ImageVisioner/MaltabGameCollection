function drawp

hold on
axis equal
axis([0 10,0 10])
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
set(gca,'color',[0.85 0.85 0.85])
plot([2,8],[1,1],'w','LineWidth',18)
plot([2,8],[9,9],'w','LineWidth',18)
plot([1,1],[2,8],'w','LineWidth',18)
plot([9,9],[2,8],'w','LineWidth',18)
plot(8+cos(0+(0:pi/(2*10):pi/2)),8+sin(0+(0:pi/(2*10):pi/2)),'w','LineWidth',18)
plot(2+cos(pi/2+(0:pi/(2*10):pi/2)),8+sin(pi/2+(0:pi/(2*10):pi/2)),'w','LineWidth',18)
plot(2+cos(pi+(0:pi/(2*10):pi/2)),2+sin(pi+(0:pi/(2*10):pi/2)),'w','LineWidth',18)
plot(8+cos(-pi/2+(0:pi/(2*10):pi/2)),2+sin(-pi/2+(0:pi/(2*10):pi/2)),'w','LineWidth',18)

plot([2.5,7.5],[5,5],'w','LineWidth',24)
plot([5,5],[2.5,7.5],'w','LineWidth',24)

end