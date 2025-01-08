function self=self_init(n)
for i=1:4
    self.(['player',num2str(i)]).property=5000;
    self.(['player',num2str(i)]).pos=0;
    self.(['player',num2str(i)]).real_estate={};
    self.(['player',num2str(i)]).estateNum=0;
    if i>n
        self.(['player',num2str(i)]).gameOver=1;
    else
        self.(['player',num2str(i)]).gameOver=0;
    end
    self.(['player',num2str(i)]).name=['Íæ¼Ò',num2str(i)];
end
end