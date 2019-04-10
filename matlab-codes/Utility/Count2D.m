function [x,y,w] = Count2D(m)

x = sort(FindUnique(m(:,1)),'ascend');
y = sort(FindUnique(m(:,2)),'ascend');

w = zeros(length(y),length(x));

for i = 1:length(x)
    Count2D.Temp1 = m(find(m(:,1) == x(i)),2);
    Count2D.Temp2 = FindUnique(Count2D.Temp1);
    
    for k = 1:length(Count2D.Temp2)
        Count2D.Temp3 = length(find(Count2D.Temp1 == Count2D.Temp2(k)));
        w(Count2D.Temp2(k),i) = Count2D.Temp3;        
    end   
  
end
end

