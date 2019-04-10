function z = cost1(x)
%%  z = cost1(x,y) : cost fintion for testing algorithm

z   = x(:,1).*sin(4*pi.*x(:,1)) + 1.1*x(:,2).*sin(2*pi.*x(:,2));

end

