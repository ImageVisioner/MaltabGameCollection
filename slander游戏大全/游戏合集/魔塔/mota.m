function mota
clear,clf,clc
board_background=imread('board_background.jpg');%01
board_key_b=imread('board_key_b.jpg');%02
board_key_r=imread('board_key_r.jpg');%03
board_key_y=imread('board_key_y.jpg');%04
board_person=imread('board_person.jpg');%05
gift=imread('gift.jpg');%06
star=imread('star.jpg');%07
background_g=imread('background_g.jpg');%08
background_star=imread('background_star.jpg');%9
background_stone=imread('background_stone.jpg');%10
wall_ice=imread('wall_ice.jpg');%11
wall_mud=imread('wall_mud.jpg');%12
stairs_down=imread('stairs_down.jpg');%13
stairs_up=imread('stairs_up.jpg');%14
person_down=imread('person_down.jpg');%15
person_left=imread('person_left.jpg');%16
person_right=imread('person_right.jpg');%17
person_up=imread('person_up.jpg');%18
gem_b=imread('gem_b.jpg');%19
gem_r=imread('gem_r.jpg');%20
gem_y=imread('gem_y.jpg');%21
key_b=imread('key_b.jpg');%22
key_r=imread('key_r.jpg');%23
key_y=imread('key_y.jpg');%24
door_b=imread('door_b.jpg');%25
door_i=imread('door_i.jpg');%26
door_r=imread('door_r.jpg');%27
door_t=imread('door_t.jpg');%28
door_y=imread('door_y.jpg');%29
bottle_b=imread('bottle_b.jpg');%30
bottle_r=imread('bottle_r.jpg');%31
bottle_y=imread('bottle_y.jpg');%32
bottle_b_big=imread('bottle_b_big.jpg');%33
bottle_y_big=imread('bottle_y_big.jpg');%34
coin=imread('coin.jpg');%35
npc_1=imread('npc_1.jpg');%36
npc_2=imread('npc_2.jpg');%37
npc_3=imread('npc_3.jpg');%38
npc_4=imread('npc_4.jpg');%39
npc_5=imread('npc_5.jpg');%40
artifact_1=imread('artifact_1.jpg');%41
artifact_2=imread('artifact_2.jpg');%42
artifact_3=imread('artifact_3.jpg');%43
artifact_4=imread('artifact_4.jpg');%44
artifact_5=imread('artifact_5.jpg');%45
artifact_6=imread('artifact_6.jpg');%46
artifact_book=imread('artifact_book.jpg');%47
artifact_pick=imread('artifact_pick.jpg');%48
artifact_star=imread('artifact_star.jpg');%49

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
monster_bat_b=imread('monster_bat_b.jpg');%50 %4
monster_bat_r=imread('monster_bat_r.jpg');%51
monster_bat_s=imread('monster_bat_s.jpg');%52 %3
monster_skeleton=imread('monster_skeleton.jpg');%53 %5
monster_slime_b=imread('monster_slime_b.jpg');%54  %2
monster_slime_g=imread('monster_slime_g.jpg');%55
monster_slime_r=imread('monster_slime_r.jpg');%56  %1
boss_b_1=imread('boss_b_1.jpg');boss_b_2=imread('boss_b_2.jpg');boss_b_3=imread('boss_b_3.jpg');%57-59
boss_b_4=imread('boss_b_4.jpg');boss_b_5=imread('boss_b_5.jpg');boss_b_6=imread('boss_b_6.jpg');%60-62
boss_b_7=imread('boss_b_7.jpg');boss_b_8=imread('boss_b_8.jpg');boss_b_9=imread('boss_b_9.jpg');%63-65

imagemap={board_background,board_key_b,board_key_r,board_key_y,board_person,...
    gift,star,background_g,background_star,background_stone,wall_ice,wall_mud,...
    stairs_down,stairs_up,person_down,person_left,person_right,person_up,...
    gem_b,gem_r,gem_y,key_b,key_r,key_y,door_b,door_i,door_r,door_t,door_y,...
    bottle_b,bottle_r,bottle_y,bottle_b_big,bottle_y_big,coin,npc_1,npc_2,npc_3,npc_4,npc_5,...
    artifact_1,artifact_2,artifact_3,artifact_4,artifact_5,artifact_6,...
    artifact_book,artifact_pick,artifact_star,monster_bat_b,monster_bat_r,monster_bat_s,...
    monster_skeleton,monster_slime_b,monster_slime_g,monster_slime_r,...
    boss_b_1,boss_b_2,boss_b_3,boss_b_4,boss_b_5,boss_b_6,boss_b_7,boss_b_8,boss_b_9};



key_b_num=0;
key_r_num=0;
key_y_num=0;
health_point=1000;
ATK=10;
DEF=10;



    function drawpic(matrix)
        [m,n]=size(matrix);
        mainpic=uint8(255*ones(50*m,50*n,3));
        for row=1:m
            for col=1:n
                mainpic(1+50*(row-1):50*row,1+50*(col-1):50*col,:)=imagemap{matrix(row,col)};
            end
        end
        delete(findobj(gcf,'type','text'))
        imshow(mainpic),hold on
        text(90,120,levelname{level},'Fontsize',12,'color','w');
        text(60,155,'ÉúÃü','Fontsize',11,'color','w');
        text(60,190,'¹¥»÷','Fontsize',11,'color','w');
        text(60,225,'·ÀÓù','Fontsize',11,'color','w');
        text(139,155,num2str(health_point),'Fontsize',11,'color','w');
        text(139,190,num2str(ATK),'Fontsize',11,'color','w');
        text(139,225,num2str(DEF),'Fontsize',11,'color','w');
        text(139,275,num2str(key_b_num),'Fontsize',11,'color','w');
        text(139,325,num2str(key_r_num),'Fontsize',11,'color','w');
        text(139,375,num2str(key_y_num),'Fontsize',11,'color','w'); 
 
    end


set(gcf, 'KeyPressFcn', @key);
    function key(~,event)
        place=find(pic_combine==direction);
        switch event.Key
            case 'downarrow'
                if direction~=15,pic_combine(place)=15;direction=15;dir=0;
                else if mod(place+1,10)~=1,dir=1;end,end
            case 'leftarrow'
                if direction~=16,pic_combine(place)=16;direction=16;dir=0;
                else,dir=-m;end
            case 'rightarrow'
                if direction~=17,pic_combine(place)=17;direction=17;dir=0;
                else if place+m<161,dir=m;end,end
            case 'uparrow'
                if direction~=18,pic_combine(place)=18;direction=18;dir=0;
                else if mod(place-1,10)~=0,dir=-1;end,end
        end
        if pic_combine(place+dir)==10,pic_combine(place+dir)=direction;pic_combine(place)=10;end
        if pic_combine(place+dir)==24,pic_combine(place+dir)=direction;pic_combine(place)=10;key_y_num=key_y_num+1;end
        if pic_combine(place+dir)==23,pic_combine(place+dir)=direction;pic_combine(place)=10;key_r_num=key_r_num+1;end
        if pic_combine(place+dir)==22,pic_combine(place+dir)=direction;pic_combine(place)=10;key_b_num=key_b_num+1;end
        if pic_combine(place+dir)==31,pic_combine(place+dir)=direction;pic_combine(place)=10;health_point=health_point+200;end
        if pic_combine(place+dir)==30,pic_combine(place+dir)=direction;pic_combine(place)=10;health_point=health_point+450;end
        if pic_combine(place+dir)==19,pic_combine(place+dir)=direction;pic_combine(place)=10;DEF=DEF+3;end
        if pic_combine(place+dir)==20,pic_combine(place+dir)=direction;pic_combine(place)=10;ATK=ATK+3;end
        if (pic_combine(place+dir)==29),if (key_y_num>0),pic_combine(place+dir)=10;key_y_num=key_y_num-1;end,end
        if (pic_combine(place+dir)==27),if (key_r_num>0),pic_combine(place+dir)=10;key_r_num=key_r_num-1;end,end
        if (pic_combine(place+dir)==25),if (key_b_num>0),pic_combine(place+dir)=10;key_b_num=key_b_num-1;end,end
        if pic_combine(place+dir)==26,pic_combine(place+dir)=10;end
        if pic_combine(place+dir)==14,change_the_floor();end
        if pic_combine(place+dir)==13,change_the_floor();end
        
        if pic_combine(place+dir)==62,if (ATK>339)&&(DEF>339),pic_combine(94:96)=[10,10,10];...
           pic_combine(104:106)=[10,10,10];pic_combine(114:116)=[10,10,10];pic_combine(105)=23;end,end
        if pic_combine(place+dir)==55,pic_combine(place+dir)=direction;pic_combine(place)=10;health_point=health_point-120;end
        if pic_combine(place+dir)==56,fight(1);end,if pic_combine(place+dir)==54,fight(2);end
        if pic_combine(place+dir)==52,fight(3);end,if pic_combine(place+dir)==50,fight(4);end
        if pic_combine(place+dir)==53,fight(5);end
        drawpic(pic_combine)
        dir=0;
    end


    function change_the_floor(~,~)
        change=1;
        if (level==1)&&(place==65)&&(dir==-m)&&(change==1),pic_combine(place)=17;levelmap{1}=pic_combine(:,6:end);
            level=2;pic_b=levelmap{level};pic_combine=[pic_a,pic_b];direction=16;drawpic(pic_combine);change=0;end
        if (level==1)&&(place==145)&&(dir==m)&&(change==1),pic_combine(place)=16;levelmap{1}=pic_combine(:,6:end);
            level=4;pic_b=levelmap{level};pic_combine=[pic_a,pic_b];direction=18;drawpic(pic_combine);change=0;end
        if (level==2)&&(place==145)&&(dir==m)&&(change==1),pic_combine(place)=16;levelmap{2}=pic_combine(:,6:end);
            level=1;pic_b=levelmap{level};pic_combine=[pic_a,pic_b];direction=17;drawpic(pic_combine);change=0;end
        if (level==2)&&(place==63)&&(dir==-1)&&(change==1),pic_combine(place)=15;levelmap{2}=pic_combine(:,6:end);
            level=3;pic_b=levelmap{level};pic_combine=[pic_a,pic_b];direction=17;drawpic(pic_combine);change=0;end
        if (level==3)&&(place==70)&&(dir==-m)&&(change==1),pic_combine(place)=17;levelmap{3}=pic_combine(:,6:end);
            level=2;pic_b=levelmap{level};pic_combine=[pic_a,pic_b];direction=15;drawpic(pic_combine);change=0;end
        if (level==4)&&(place==109)&&(dir==1)&&(change==1),pic_combine(place)=18;levelmap{4}=pic_combine(:,6:end);
            level=1;pic_b=levelmap{level};pic_combine=[pic_a,pic_b];direction=17;drawpic(pic_combine);change=0;end
    end


pic_a=[01 01 01 01 01;05 01 06 01 07;01 01 01 01 01;01 01 01 01 01;01 01 01 01 01;01 02 01 01 01;01 03 01 01 01;01 04 01 01 01;01 01 01 01 01;01 01 01 01 01];
level1=[12 12 12 12 12 12 12 12 12 12 12;12 41 12 42 12 24 12 43 12 44 12;12 10 12 10 12 24 12 10 12 10 12;12 28 12 28 12 40 12 28 12 28 12;14 24 10 10 10 10 10 10 10 24 14;
        12 12 29 12 10 10 10 12 29 12 12;12 36 10 12 10 10 10 12 10 38 12;12 10 10 12 10 18 10 12 10 10 12;12 22 37 12 10 10 10 12 39 23 12;12 12 12 12 12 12 12 12 12 12 12];
level2=[12 12 12 12 12 12 12 12 12 12 12;12 14 12 19 31 19 12 20 20 20 12;12 10 12 31 56 31 25 54 30 30 12;12 29 12 12 29 12 12 12 12 12 12;12 10 31 22 10 12 10 10 10 16 13; 
        12 56 12 12 12 12 24 12 12 12 12;12 19 56 30 56 12 55 12 22 22 12;12 12 29 12 12 12 55 12 31 31 12;12 24 10 55 55 24 10 25 10 31 12;12 12 12 12 12 12 12 12 12 12 12];
level3=[31 31 12 54 10 24 10 31 54 10 10;31 31 12 10 12 12 12 12 12 12 29;52 52 12 24 12 20 20 19 27 10 53;52 54 29 31 12 20 19 19 12 10 52;27 12 12 24 12 12 12 12 12 12 25;
        50 31 12 54 10 56 10 29 10 10 56;31 30 12 12 25 12 12 12 12 12 25;30 45 12 22 10 12 47 20 20 20 20;12 12 12 22 10 12 27 12 12 12 12;13 17 10 10 10 10 10 52 23 10 14];
level4=[11 11 11 11 11 14 11 11 11 11 11;11 11 11 11 11 10 11 11 11 11 11;11 11 11 11 11 29 11 11 11 11 11;11 11 11 11 57 60 63 11 11 11 11;11 11 11 11 58 61 64 11 11 11 11;
        11 11 11 11 59 62 65 11 11 11 11;11 11 11 11 11 25 11 11 11 11 11;11 11 11 11 11 10 11 11 11 11 11;11 11 11 11 11 18 11 11 11 11 11;11 11 11 11 11 13 11 11 11 11 11];
 
%monster=[ÉúÃü£¬¹¥»÷£¬·ÀÓù]    
monster1=[180,20,5];monster2=[350,25,20];monster3=[450,20,20];monster4=[750,45,45];monster5=[800,45,40];
monster={monster1,monster2,monster3,monster4,monster5};

    function fight(x)
        opp=monster{x};
        if ATK>opp(3)
            if DEF>opp(2)
                health_lose=0;
            else
                times=ceil(opp(1)/(ATK-opp(3)));
                health_lose=times*(opp(2)-DEF);
            end
            if health_point>health_lose
                health_point=health_point-health_lose;
                pic_combine(place+dir)=direction;pic_combine(place)=10;
                drawpic(pic_combine);
            end
        end
    end


level=1;
levelname={'½µÄ§Õò','ÍÁËþÒ»²ã','ÍÁËþ¶þ²ã','±ùËþÍâÎ§'};
levelmap={level1,level2,level3,level4};
pic_b=levelmap{level};
pic_combine=[pic_a,pic_b];
direction=18;
place=find(pic_combine==direction);
dir=0;
[m,n]=size(pic_combine);
drawpic(pic_combine)



end