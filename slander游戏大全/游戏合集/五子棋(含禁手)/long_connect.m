function boolean=long_connect(mat,pos)
    boolean=0;
        if size(get_connection_area2(mat,pos,1),1)>=6||...
           size(get_connection_area2(mat,pos,2),1)>=6||...
           size(get_connection_area2(mat,pos,3),1)>=6||...
           size(get_connection_area2(mat,pos,3),1)>=6
                boolean=1;
        end

end
