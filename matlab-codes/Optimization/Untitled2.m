x = 0:0.01:1;
y = 0:0.01:1;

for m = 1:length(x)
    for n = 1:length(y)
        z(m,n) = cl2feval(x(m),y(n));
    end
end

figureW;
% colormap(gray)
surf(x,y,z);
view(0,90);
colorbar;
xlabel('Class 1 classification error rate');
ylabel('Class 2 classification error rate');
zlabel('Classification fittness function');
title('z = 1-[(x-y)^2 + (x+y)]/2')




