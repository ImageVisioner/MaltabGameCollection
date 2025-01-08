% author : slandarer
clc; clear
r=@(n) randi([0,n-1], [1,1]);
P(:,:,1) = randMat();
P(:,:,2) = randMat();
P(:,:,3) = randMat();
imshow(uint8(P))
function M = randMat()
r = @(n) randi([0,n-1],[1,1]);
M = zeros(512,512);
for i = 1:512
    for j = 1:512
        M(i,j) = getC(i,j);
    end
end
    function C = getC(i,j)
        if M(i,j) == 0
            if r(99) ~= 0
                M(i,j) = getC(mod(i+r(2),512)+1,mod(j+r(2),512)+1);
            else
                M(i,j) = r(256);
            end
        end
        C = M(i,j);
    end
end