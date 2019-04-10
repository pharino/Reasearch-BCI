x = 0:.01:1;
y = 0:.01:1;

for i = 1:length(x)
    for k = 1:length(y)
        z(i,k) = cl2feval(x(i),y(k));
   
    end
end

%%  View cost function
surf(x,y,z);
view(-90,0);
colorbar();
axis([0 1 0 1]);