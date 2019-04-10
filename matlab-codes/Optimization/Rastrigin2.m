function [ y] = Rastrigin2( x)
%   Rastrigin( x,y )
%   
y = 10*2 + (x(1)^2-10*x(2)*cos(3*pi*x(1))) + (x(2)^2-10*x(1)*cos(3*pi*x(2)));

end

