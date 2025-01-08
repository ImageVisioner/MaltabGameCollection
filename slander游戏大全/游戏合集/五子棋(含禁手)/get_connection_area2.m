function list=get_connection_area2(pos_list,pos,dir)
%always add new numbers from partb to parta
switch dir
    case 1,dir=[0 1];
    case 2,dir=[1 0];
    case 3,dir=[1 1];
    case 4,dir=[1 -1];
end
A=pos;
B=pos_list;
progress=[A;A+ones(size(A,1),1)*dir;...
            A+ones(size(A,1),1)*(-dir)];
progress=unique(progress,'rows');
while ~isempty(intersect(progress,B,'rows'))
    [a,~,b]=intersect(progress,B,'rows');
    A=[A;a];
    A=unique(A,'rows');
    B(b,:)=[];
    progress=[A;A+ones(size(A,1),1)*dir;...
                A+ones(size(A,1),1)*(-dir)];
    progress=unique(progress,'rows');
end
list=A;
end
