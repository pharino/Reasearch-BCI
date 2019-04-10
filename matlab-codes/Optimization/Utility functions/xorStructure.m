function [z] = xorStructure(x,y,a,b,sigma)
%%  xorStructure(x,y,a,b,sigma):
%   Input:
%   -   x,y: current x and y axis value. Axis is [0 1]
%   -   a,b: marginal inputs
%   -   sigma: maximum width

%%  Function body

if iselement(x,a,sigma) && ~iselement(y,b,sigma)
    z = 1;
elseif ~iselement(x,a,sigma) && iselement(y,b,sigma)
    z = 2;
elseif ~iselement(x,a,sigma) && ~iselement(y,b,sigma)
    z = 3;
elseif iselement(x,a,sigma) && iselement(y,b,sigma)
    z = 4;
end

end

