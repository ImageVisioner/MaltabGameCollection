function elos
hold on
axis equal
axis(0.5+[0,10,0,20])
set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w')
set(gca,'color','k')
%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%% %%%%%%%%%
A1=[5,23;5,24;6,23;6,24];%1
B1=[5,23;5,24;5,22;5,21];%21
B2=[5,23;4,23;6,23;7,23];%23
C1=[5,23;5,24;5,22;4,24];%31
C2=[5,23;6,23;4,23;6,24];%33
C3=[5,23;5,24;5,22;6,22];%35
C4=[5,23;4,23;6,23;4,22];%37
D1=[5,23;5,24;5,22;6,24];%41
D2=[5,23;4,23;6,23;6,22];%43
D3=[5,23;5,24;5,22;4,22];%45
D4=[5,23;4,23;6,23;4,24];%47
E1=[5,23;5,24;4,24;6,23];%51
E2=[5,23;6,24;6,23;5,22];%53
E3=[5,23;4,23;5,22;6,22];%55
E4=[5,23;5,24;4,23;4,22];%57
F1=[5,23;5,24;6,24;4,23];%61
F2=[5,23;6,23;6,22;5,24];%63
F3=[5,23;6,23;5,22;4,22];%65
F4=[5,23;4,24;4,23;5,22];%67
G1=[5,23;5,24;4,23;6,23];%71
G2=[5,23;6,23;5,24;5,22];%73
G3=[5,23;4,23;6,23;5,22];%75
G4=[5,23;4,23;5,24;5,22];%77
%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%% %%%%%%%%%
r=[1 0 0;1 0 0;1 0 0;1 0 0];
b=[0 0 1;0 0 1;0 0 1;0 0 1];
g=[0 1 0;0 1 0;0 1 0;0 1 0];
c=[0 1 1;0 1 1;0 1 1;0 1 1];
w=[1 1 1;1 1 1;1 1 1;1 1 1];
h=[-50,-50,0,0,1;-49,-49,0,0,1;-48,-48,0,0,1;-47,-47,0,0,1];
wall1=[1 0;2 0;3 0;4 0;5 0;6 0;7 0;8 0;9 0;10 0];
wall2=[0,0;0,1;0,2;0,3;0,4;0,5;0,6;0,7;0,8;0,9;0,10;0,11;0,12;0,13;0,14;0,15;
    0,16;0,17;0,18;0,19;0,20];
wall3=[11,0;11,1;11,2;11,3;11,4;11,5;11,6;11,7;11,8;11,9;11,10;11,11;11,12;
    11,13;11,14;11,15;11,16;11,17;11,18;11,19;11,20];
direct=[0,-1,0,0,0;0,-1,0,0,0;0,-1,0,0,0;0,-1,0,0,0];
dir=[0,-1;0,-1;0,-1;0,-1];
left=[-1,0,0,0,0;-1,0,0,0,0;-1,0,0,0,0;-1,0,0,0,0];
right=[1,0,0,0,0;1,0,0,0,0;1,0,0,0,0;1,0,0,0,0];
lefty=[-1,0;-1,0;-1,0;-1,0];
leftyy=[-1,-1;-1,-1;-1,-1;-1,-1];
righty=[1,0;1,0;1,0;1,0];
rightyy=[1,-1;1 ,-1;1,-1;1,-1];
s=[A1,c];
s1=A1;
change=1;
waigua=1;
color=1;
score=0;
%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%% %%%%%%%%%
kill1=[1,17;2,17;3,17;4,17;5,17;6,17;7,17;8,17;9,17;10,17];
kill2=[1,16;2,16;3,16;4,16;5,16;6,16;7,16;8,16;9,16;10,16];
kill3=[1,15;2,15;3,15;4,15;5,15;6,15;7,15;8,15;9,15;10,15];
kill4=[1,14;2,14;3,14;4,14;5,14;6,14;7,14;8,14;9,14;10,14];
kill5=[1,13;2,13;3,13;4,13;5,13;6,13;7,13;8,13;9,13;10,13];
kill6=[1,12;2,12;3,12;4,12;5,12;6,12;7,12;8,12;9,12;10,12];
kill7=[1,11;2,11;3,11;4,11;5,11;6,11;7,11;8,11;9,11;10,11];
kill8=[1,10;2,10;3,10;4,10;5,10;6,10;7,10;8,10;9,10;10,10];
kill9=[1,9;2,9;3,9;4,9;5,9;6,9;7,9;8,9;9,9;10,9];
kill10=[1,8;2,8;3,8;4,8;5,8;6,8;7,8;8,8;9,8;10,8];
kill11=[1,7;2,7;3,7;4,7;5,7;6,7;7,7;8,7;9,7;10,7];
kill12=[1,6;2,6;3,6;4,6;5,6;6,6;7,6;8,6;9,6;10,6];
kill13=[1,5;2,5;3,5;4,5;5,5;6,5;7,5;8,5;9,5;10,5];
kill14=[1,4;2,4;3,4;4,4;5,4;6,4;7,4;8,4;9,4;10,4];
kill15=[1,3;2,3;3,3;4,3;5,3;6,3;7,3;8,3;9,3;10,3];
kill16=[1,2;2,2;3,2;4,2;5,2;6,2;7,2;8,2;9,2;10,2];
kill17=[1,1;2,1;3,1;4,1;5,1;6,1;7,1;8,1;9,1;10,1];
%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%% %%%%%%%%%
plotelos=scatter(gca,s(:,1),s(:,2),220,s(:,3:5),'s','filled');
plott=scatter(gca,h(:,1),h(:,2),220,h(:,3:5),'s','filled');
set(gcf, 'KeyPressFcn', @key)
fps = 5;                                    
game = timer('ExecutionMode', 'FixedRate', 'Period',1/fps, 'TimerFcn', @elosgame);
start(game) 
%%%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%%% %%%%%%%%% %%%%%%%%%
    function elosgame(~,~)
        talant=find(h>18);
        if length(talant)==0
        else
            stop(game);
            ButtonName1 = questdlg('Game over','what do you mean to do?','restart','end', 'end');
            if ButtonName1 == 'restart';
                clf;
                elos();
            else
                close;
            end
        end
        if length(wall1)==length(unique([wall1;kill1],'rows'));
            wall1(find(wall1(:,2)==17),:)=[];
            h(find(h(:,2)==17),:)=[];
            wall1(wall1(:,2)>17)=wall1(wall1(:,2)>17)-1;
            h(h(:,2)>17)=h(h(:,2)>17)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill2],'rows'));
            wall1(find(wall1(:,2)==16),:)=[];
            h(find(h(:,2)==16),:)=[];
            wall1(wall1(:,2)>16)=wall1(wall1(:,2)>16)-1;
            h(h(:,2)>16)=h(h(:,2)>16)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill3],'rows'));
            wall1(find(wall1(:,2)==15),:)=[];
            h(find(h(:,2)==15),:)=[];
            wall1(wall1(:,2)>15)=wall1(wall1(:,2)>15)-1;
            h(h(:,2)>15)=h(h(:,2)>15)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill4],'rows'));
            wall1(find(wall1(:,2)==14),:)=[];
            h(find(h(:,2)==14),:)=[];
            wall1(wall1(:,2)>14)=wall1(wall1(:,2)>14)-1;
            h(h(:,2)>14)=h(h(:,2)>14)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill5],'rows'));
            wall1(find(wall1(:,2)==13),:)=[];
            h(find(h(:,2)==13),:)=[];
            wall1(wall1(:,2)>13)=wall1(wall1(:,2)>13)-1;
            h(h(:,2)>13)=h(h(:,2)>13)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill6],'rows'));
            wall1(find(wall1(:,2)==12),:)=[];
            h(find(h(:,2)==12),:)=[];
            wall1(wall1(:,2)>12)=wall1(wall1(:,2)>12)-1;
            h(h(:,2)>12)=h(h(:,2)>12)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill7],'rows'));
            wall1(find(wall1(:,2)==11),:)=[];
            h(find(h(:,2)==11),:)=[];
            wall1(wall1(:,2)>11)=wall1(wall1(:,2)>11)-1;
            h(h(:,2)>11)=h(h(:,2)>11)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill8],'rows'));
            wall1(find(wall1(:,2)==10),:)=[];
            h(find(h(:,2)==0),:)=[];
            wall1(wall1(:,2)>10)=wall1(wall1(:,2)>10)-1;
            h(h(:,2)>10)=h(h(:,2)>10)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill9],'rows'));
            wall1(find(wall1(:,2)==9),:)=[];
            h(find(h(:,2)==9),:)=[];
            wall1(wall1(:,2)>9,2)=wall1(wall1(:,2)>9,2)-1;
            h(h(:,2)>9,2)=h(h(:,2)>9,2)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill10],'rows'));
            wall1(find(wall1(:,2)==8),:)=[];
            h(find(h(:,2)==8),:)=[];            
            wall1(wall1(:,2)>8,2)=wall1(wall1(:,2)>8,2)-1;
            h(h(:,2)>8,2)=h(h(:,2)>8,2)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill11],'rows'));
            wall1(find(wall1(:,2)==7),:)=[];
            h(find(h(:,2)==7),:)=[];
            wall1(wall1(:,2)>7,2)=wall1(wall1(:,2)>7,2)-1;
            h(h(:,2)>7,2)=h(h(:,2)>7,2)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill12],'rows'));
            wall1(find(wall1(:,2)==6),:)=[];
            h(find(h(:,2)==6),:)=[];
            wall1(wall1(:,2)>6,2)=wall1(wall1(:,2)>6,2)-1;
            h(h(:,2)>6,2)=h(h(:,2)>6,2)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill13],'rows'));
            wall1(find(wall1(:,2)==5),:)=[];
            h(find(h(:,2)==5),:)==[];
            wall1(wall1(:,2)>5,2)=wall1(wall1(:,2)>59,2)-1;
            h(h(:,2)>5,2)=h(h(:,2)>5,2)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill14],'rows'));
            wall1(find(wall1(:,2)==4),:)=[];
            h(find(h(:,2)==4),:)=[];
            wall1(wall1(:,2)>4,2)=wall1(wall1(:,2)>4,2)-1;
            h(h(:,2)>4,2)=h(h(:,2)>4,2)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill15],'rows'));
            wall1(find(wall1(:,2)==3),:)=[];
            h(find(h(:,2)==3),:)=[];
            wall1(wall1(:,2)>3,2)=wall1(wall1(:,2)>3,2)-1;
            h(h(:,2)>3,2)=h(h(:,2)>3,2)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill16],'rows'));
            wall1(find(wall1(:,2)==2),:)=[];
            h(find(h(:,2)==2),:)=[];
            wall1(wall1(:,2)>2,2)=wall1(wall1(:,2)>2,2)-1;
            h(h(:,2)>2,2)=h(h(:,2)>2,2)-1;
            score=score+10;
        end
        if length(wall1)==length(unique([wall1;kill17],'rows'));
            wall1(find(wall1(:,2)==1),:)=[];
            h(find(h(:,2)==1),:)=[];
            wall1(wall1(:,2)>1,2)=wall1(wall1(:,2)>1,2)-1;
            h(h(:,2)>1,2)=h(h(:,2)>1,2)-1;
            score=score+10;
        end
        s1=s1+dir;
        s=s+direct;
        control=length(intersect(dir+s1,wall1,'rows'));
        if control==0;
        else
            h=[h;s];
            wall1=[wall1;s1];
            power=randi(7);
            power2=randi(4);
            if power==1;
                sn=A1;
                change=1;
            end
            if power==2;
                sn=B1;
                change=21;
            end
            if power==3;
                sn=C1;
                change=31;
            end
            if power==4;
                sn=D1;
                change=41;
            end
            if power==5;
                sn=E1;
                change=51;
            end
            if power==6;
                sn=F1;
                change=61;
            end
            if power==7;
                sn=G1;
                change=71;
            end
            if power2==1;
                co=r;
            end
            if power2==2;
                co=b;
            end
            if power2==3;
                co=g;
            end
            if power2==4;
                co=c;
            end
            if waigua==1;
                s=[sn,co];
                s1=sn;
                tip=1;
            end
            if waigua==2;
                s=[B1,co];
                s1=B1;
                tip=1;
                change=21;
            end
        end
        if color==1;
            set(plott,'XData',h(:,1),'YData',h(:,2),'CData',h(:,3:5))
            set(plotelos,'XData',s(:,1),'YData',s(:,2),'CData',s(:,3:5))
        end
        if color==2;
            set(plott,'XData',h(:,1),'YData',h(:,2),'CData',[1 1 1])
            set(plotelos,'XData',s(:,1),'YData',s(:,2),'CData',[1 1 1])
        end
    end
    function key(~,event);
        switch event.Key;
            case 'uparrow';
                po=[s1(1,:);s1(1,:);s1(1,:);s1(1,:)];
                pp=[5,23;5,23;5,23;5,23];
                pa=[s(1,3:5);s(1,3:5);s(1,3:5);s(1,3:5)];
                pos=po-pp;
                if change==21;
                    if length(intersect(B2+pos,wall1,'rows'))==0;
                        if length(intersect(B2+pos,wall2,'rows'))==0;
                            if length(intersect(B2+pos,wall3,'rows'))==0;
                                s=[B2+pos,pa];
                                s1=B2+pos;
                                change=22;
                            end
                        end
                    end
                end
                if change==23;
                    if length(intersect(B1+pos,wall1,'rows'))==0;
                        if length(intersect(B1+pos,wall2,'rows'))==0;
                            if length(intersect(B1+pos,wall3,'rows'))==0;
                                s=[B1+pos,pa];
                                s1=B1+pos;
                                change=20;
                            end
                        end
                    end
                end
                if change==31;
                    if length(intersect(C2+pos,wall1,'rows'))==0;
                        if length(intersect(C2+pos,wall2,'rows'))==0;
                            if length(intersect(C2+pos,wall3,'rows'))==0;
                                s=[C2+pos,pa];
                                s1=C2+pos;
                                change=32;
                            end
                        end
                    end
                end
                if change==33;
                    if length(intersect(C3+pos,wall1,'rows'))==0;
                        if length(intersect(C3+pos,wall2,'rows'))==0;
                            if length(intersect(C3+pos,wall3,'rows'))==0;
                                s=[C3+pos,pa];
                                s1=C3+pos;
                                change=34;
                            end
                        end
                    end
                end
                if change==35;
                    if isempty(intersect(C4+pos,wall1,'rows'));
                        if length(intersect(C4+pos,wall2,'rows'))==0;
                            if length(intersect(C4+pos,wall3,'rows'))==0;
                                s=[C4+pos,pa];
                                s1=C4+pos;
                                change=36;
                            end
                        end
                    end
                end
                if change==37;
                    if length(intersect(C1+pos,wall1,'rows'))==0;
                        if length(intersect(C1+pos,wall2,'rows'))==0;
                            if length(intersect(C1+pos,wall3,'rows'))==0;
                                s=[C1+pos,pa];
                                s1=C1+pos;
                                change=30;
                            end
                        end
                    end
                end
                if change==41;
                    if length(intersect(D2+pos,wall1,'rows'))==0; 
                        if length(intersect(D2+pos,wall2,'rows'))==0;  
                            if length(intersect(D2+pos,wall3,'rows'))==0;  
                                s=[D2+pos,pa];
                                s1=D2+pos;
                                change=42;
                            end
                        end
                    end
                end
                if change==43;
                    if length(intersect(D3+pos,wall1,'rows'))==0;
                        if length(intersect(D3+pos,wall2,'rows'))==0;
                            if length(intersect(D3+pos,wall3,'rows'))==0;
                                s=[D3+pos,pa];
                                s1=D3+pos;
                                change=44;
                            end
                        end
                    end
                end
                if change==45;
                    if length(intersect(D4+pos,wall1,'rows'))==0;
                        if length(intersect(D4+pos,wall2,'rows'))==0;
                            if length(intersect(D4+pos,wall3,'rows'))==0;
                                s=[D4+pos,pa];
                                s1=D4+pos;
                                change=46;
                            end
                        end
                    end
                end
                if change==47;
                    if length(intersect(D1+pos,wall1,'rows'))==0;
                        if length(intersect(D1+pos,wall2,'rows'))==0;
                            if length(intersect(D1+pos,wall3,'rows'))==0;
                                s=[D1+pos,pa];
                                s1=D1+pos;
                                change=40;
                            end
                        end
                    end
                end
                if change==51;
                    if length(intersect(E2+pos,wall1,'rows'))==0;
                        if length(intersect(E2+pos,wall2,'rows'))==0;
                            if length(intersect(E2+pos,wall3,'rows'))==0;
                                s=[E2+pos,pa];
                                s1=E2+pos;
                                change=52;
                            end
                        end
                    end
                end
                if change==53;
                    if length(intersect(E3+pos,wall1,'rows'))==0;
                        if length(intersect(E3+pos,wall2,'rows'))==0;
                            if length(intersect(E3+pos,wall3,'rows'))==0;
                                s=[E3+pos,pa];
                                s1=E3+pos;
                                change=54;
                            end
                        end
                    end
                end
                if change==55;
                    if length(intersect(E4+pos,wall1,'rows'))==0;
                        if length(intersect(E4+pos,wall2,'rows'))==0;
                            if length(intersect(E4+pos,wall3,'rows'))==0;
                                s=[E4+pos,pa];
                                s1=E4+pos;
                                change=56;
                            end
                        end
                    end
                end
                if change==57;
                    if length(intersect(E1+pos,wall1,'rows'))==0;
                        if length(intersect(E1+pos,wall2,'rows'))==0;
                            if length(intersect(E1+pos,wall3,'rows'))==0;  
                                s=[E1+pos,pa];
                                s1=E1+pos;
                                change=50;
                            end
                        end
                    end
                end
                if change==61;
                    if length(intersect(F2+pos,wall1,'rows'))==0;
                        if length(intersect(F2+pos,wall2,'rows'))==0;
                            if length(intersect(F2+pos,wall3,'rows'))==0;
                                s=[F2+pos,pa];
                                s1=F2+pos;
                                change=62;
                            end
                        end
                    end
                end
                if change==63;
                    if length(intersect(F3+pos,wall1,'rows'))==0;
                        if length(intersect(F3+pos,wall2,'rows'))==0;
                            if length(intersect(F3+pos,wall3,'rows'))==0;
                                s=[F3+pos,pa];
                                s1=F3+pos;
                                change=64;
                            end
                        end
                    end
                end
                if change==65;
                    if length(intersect(F4+pos,wall1,'rows'))==0;
                        if length(intersect(F4+pos,wall2,'rows'))==0;
                            if length(intersect(F4+pos,wall3,'rows'))==0;
                                s=[F4+pos,pa];
                                s1=F4+pos;
                                change=66;
                            end
                        end
                    end
                end
                if change==67;
                    if length(intersect(F1+pos,wall1,'rows'))==0;
                        if length(intersect(F1+pos,wall2,'rows'))==0;
                            if length(intersect(F1+pos,wall3,'rows'))==0;
                                s=[F1+pos,pa];
                                s1=F1+pos;
                                change=60;
                            end
                        end
                    end
                end
                if change==71;
                    if length(intersect(G2+pos,wall1,'rows'))==0;
                        if length(intersect(G2+pos,wall2,'rows'))==0;
                            if length(intersect(G2+pos,wall3,'rows'))==0;
                                s=[G2+pos,pa];
                                s1=G2+pos;
                                change=72;
                            end
                        end
                    end
                end
                if change==73;
                    if length(intersect(G3+pos,wall1,'rows'))==0;
                        if length(intersect(G3+pos,wall2,'rows'))==0;
                            if length(intersect(G3+pos,wall3,'rows'))==0;
                                s=[G3+pos,pa];
                                s1=G3+pos;
                                change=74;
                            end
                        end
                    end
                end
                if change==75;
                    if length(intersect(G4+pos,wall1,'rows'))==0;
                        if length(intersect(G4+pos,wall2,'rows'))==0;
                            if length(intersect(G4+pos,wall3,'rows'))==0;
                                s=[G4+pos,pa];
                                s1=G4+pos;
                                change=76;
                            end
                        end
                    end
                end
                if change==77;
                    if length(intersect(G1+pos,wall1,'rows'))==0;
                        if length(intersect(G1+pos,wall2,'rows'))==0;
                            if length(intersect(G1+pos,wall3,'rows'))==0;
                                s=[G1+pos,pa];
                                s1=G1+pos;
                                change=70;
                            end
                        end
                    end
                end
                change=change+1;
            case 'w'
                color=2;
            case 'c'
                color=1
            case '1';
                waigua=1;
            case '2';
                waigua=2; 
            case 'leftarrow';
                if length(intersect(s1+lefty,wall1,'rows'))==0
                    if length(intersect(s1+leftyy,wall1,'rows'))==0
                        if length(intersect(s1+lefty,wall2,'rows'))==0;
                            s=s+left;
                            s1=s1+lefty;
                        end
                    end
                end
            case 'rightarrow';
                if length(intersect(s1+righty,wall1,'rows'))==0
                    if length(intersect(s1+rightyy,wall1,'rows'))==0
                        if length(intersect(s1+righty,wall3,'rows'))==0;
                            s=s+right;
                            s1=s1+righty;
                        end
                    end
                end
        end
    end
end

