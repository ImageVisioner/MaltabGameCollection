function drawpp

hold on
axis equal
axis([0 10,0 10])
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
set(gca,'color',[0.95 0.95 0.95])

t=0:0.01:2*pi;
fill([2 2 8 8 5],[2 1 1 2 7],[25 202 173]./255,'LineWidth',8)
fill(5+2*cos(t),7.5+2*sin(t),[25 202 173]./255,'LineWidth',8)


end