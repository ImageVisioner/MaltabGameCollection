function boolean=weather_surrounded(mat,pos)
%to detect if the piece is surrounded
%the mat is a matrix composed of 1,0,-1
[m,n]=size(mat);
temp_mat=abs(mat);
new_mat=temp_mat+[ones(m,1),temp_mat(:,1:n-1)]...
                +[temp_mat(:,2:end),ones(m,1)]...
                +[ones(1,n);temp_mat(1:m-1,:)]...
                +[temp_mat(2:end,:);ones(1,n)];
boolean=new_mat(pos(:,1)+(pos(:,2)-1).*m)==5;
end
