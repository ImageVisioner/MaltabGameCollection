function self_updata(self,selfTool)
for i=1:4
    if (self.(['player',num2str(i)]).gameOver==0)
        selfTool.(['player',num2str(i)]).Txt.Text=['×Ê½ð £º',num2str(self.(['player',num2str(i)]).property)];  
        selfTool.(['player',num2str(i)]).Lb.Items=self.(['player',num2str(i)]).real_estate;
    else
        %self.(['player',num2str(i)]).real_estate={};
    end
end