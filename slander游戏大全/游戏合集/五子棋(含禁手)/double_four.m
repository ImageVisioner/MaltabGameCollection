function boolean=double_four(mat,map,pos)
boolean=0;
temp_list_1=get_connection_area2(mat,pos,1);
temp_list_2=get_connection_area2(mat,pos,2);
temp_list_3=get_connection_area2(mat,pos,3);
temp_list_4=get_connection_area2(mat,pos,4);
temp_list_1_endpoint=[temp_list_1;temp_list_1+ones(size(temp_list_1,1),1)*[0 1];...
                                  temp_list_1+ones(size(temp_list_1,1),1)*[0 -1]];
temp_list_2_endpoint=[temp_list_2;temp_list_2+ones(size(temp_list_2,1),1)*[1 0];...
                                  temp_list_2+ones(size(temp_list_2,1),1)*[-1 0]];
temp_list_3_endpoint=[temp_list_3;temp_list_3+ones(size(temp_list_3,1),1)*[1 1];...
                                  temp_list_3+ones(size(temp_list_3,1),1)*[-1 -1]];
temp_list_4_endpoint=[temp_list_4;temp_list_4+ones(size(temp_list_4,1),1)*[1 -1];...
                                  temp_list_4+ones(size(temp_list_4,1),1)*[-1 1]]; 
temp_list_1_endpoint=unique(temp_list_1_endpoint,'rows');  
temp_list_2_endpoint=unique(temp_list_2_endpoint,'rows');
temp_list_3_endpoint=unique(temp_list_3_endpoint,'rows');
temp_list_4_endpoint=unique(temp_list_4_endpoint,'rows');
[~,d1,~]=intersect(temp_list_1_endpoint,temp_list_1,'rows');
[~,d2,~]=intersect(temp_list_2_endpoint,temp_list_2,'rows');
[~,d3,~]=intersect(temp_list_3_endpoint,temp_list_3,'rows');
[~,d4,~]=intersect(temp_list_4_endpoint,temp_list_4,'rows');
temp_list_1_endpoint(d1,:)=[];
temp_list_2_endpoint(d2,:)=[];
temp_list_3_endpoint(d3,:)=[];
temp_list_4_endpoint(d4,:)=[];
temp_list_1_endpoint(abs(temp_list_1_endpoint(:,1))>9,:)=[];
temp_list_1_endpoint(abs(temp_list_1_endpoint(:,2))>9,:)=[];
temp_list_2_endpoint(abs(temp_list_2_endpoint(:,1))>9,:)=[];
temp_list_2_endpoint(abs(temp_list_2_endpoint(:,2))>9,:)=[];
temp_list_3_endpoint(abs(temp_list_3_endpoint(:,1))>9,:)=[];
temp_list_3_endpoint(abs(temp_list_3_endpoint(:,2))>9,:)=[];
temp_list_4_endpoint(abs(temp_list_4_endpoint(:,1))>9,:)=[];
temp_list_4_endpoint(abs(temp_list_4_endpoint(:,2))>9,:)=[];
boolean1=0;boolean2=0;boolean3=0;boolean4=0;

if sum(map(temp_list_1_endpoint(:,1)+10+(temp_list_1_endpoint(:,2)+9).*19)==0)==2&&size(temp_list_1,1)==4
   boolean1=1;
end
if sum(map(temp_list_2_endpoint(:,1)+10+(temp_list_2_endpoint(:,2)+9).*19)==0)==2&&size(temp_list_2,1)==4
   boolean2=1;
end
if sum(map(temp_list_3_endpoint(:,1)+10+(temp_list_3_endpoint(:,2)+9).*19)==0)==2&&size(temp_list_3,1)==4
   boolean3=1;
end
if sum(map(temp_list_4_endpoint(:,1)+10+(temp_list_4_endpoint(:,2)+9).*19)==0)==2&&size(temp_list_4,1)==4
   boolean4=1;
end
if boolean1+boolean2+boolean3+boolean4>=2
    boolean=1;
end
end
