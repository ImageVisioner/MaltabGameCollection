function list=get_connection_area(pos_list,pos)
%always add new numbers from partb to parta
A=pos;
B=pos_list;
progress=[A;A+ones(size(A,1),1)*[0 1];...
            A+ones(size(A,1),1)*[0 -1];...
            A+ones(size(A,1),1)*[1 0];...
            A+ones(size(A,1),1)*[-1 0]];
progress=unique(progress,'rows');
while ~isempty(intersect(progress,B,'rows'))
    [a,~,b]=intersect(progress,B,'rows');
    A=[A;a];
    A=unique(A,'rows');
    B(b,:)=[];
    progress=[A;A+ones(size(A,1),1)*[0 1];...
            A+ones(size(A,1),1)*[0 -1];...
            A+ones(size(A,1),1)*[1 0];...
            A+ones(size(A,1),1)*[-1 0]];
    progress=unique(progress,'rows');
end
list=A;
end
