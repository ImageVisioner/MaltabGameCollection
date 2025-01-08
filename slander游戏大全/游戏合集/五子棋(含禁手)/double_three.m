function boolean=double_three(map,pos)
boolean=0;
map(pos(1)+10,pos(2)+10)=1;
boolean1=0;boolean2=0;boolean3=0;boolean4=0;
end_point11=get_endpoint([0 1],pos);
end_point12=get_endpoint([0 -1],pos);

end_point21=get_endpoint([1 0],pos);
end_point22=get_endpoint([-1 0],pos);

end_point31=get_endpoint([1 1],pos);
end_point32=get_endpoint([-1 -1],pos);

end_point41=get_endpoint([1 -1],pos);
end_point42=get_endpoint([-1 1],pos);
if get_connection_dir([0 1],pos)==3&&...
   map(end_point11(1)+10,end_point11(2)+10-1)~=1&&...
   map(end_point12(1)+10,end_point12(2)+10+1)~=1&&...
   abs(end_point11(2)-end_point12(2))>=7
    boolean1=1;
end
if get_connection_dir([1 0],pos)==3&&...
   map(end_point21(1)+10-1,end_point21(2)+10)~=1&&...
   map(end_point22(1)+10+1,end_point22(2)+10)~=1&&...
   abs(end_point21(1)-end_point22(1))>=7
    boolean2=1;
end
if get_connection_dir([1 1],pos)==3&&...
   map(end_point31(1)+10-1,end_point31(2)+10-1)~=1&&...
   map(end_point32(1)+10+1,end_point32(2)+10+1)~=1&&...
   abs(end_point31(2)-end_point32(2))>=7
    boolean3=1;
end
if get_connection_dir([1 -1],pos)==3&&...
   map(end_point41(1)+10-1,end_point41(2)+10+1)~=1&&...
   map(end_point42(1)+10+1,end_point42(2)+10-1)~=1&&...
   abs(end_point41(2)-end_point42(2))>=7
    boolean4=1;
end
if boolean1+boolean2+boolean3+boolean4>=2
    boolean=1;
end

    function sums=get_connection_dir(dir,pos)
        sums=0;
        for i=-3:1:3
            if any(abs(pos+dir.*i)>9)
            else
                temp_pos=pos+dir.*i;
                if map(temp_pos(1)+10,temp_pos(2)+10)==1
                    sums=sums+1;
                end
            end
        end
    end

    function endpoint=get_endpoint(dir,pos)
        for i=1:5
            temp_pos=pos+dir.*i;
            if any(abs(pos+dir.*i)>9)
                endpoint=pos+dir.*i;break;
            end
            if map(temp_pos(1)+10,temp_pos(2)+10)==-1
                endpoint=pos+dir.*i;break;
            end
            endpoint=pos+dir.*i;
        end
    end
end
