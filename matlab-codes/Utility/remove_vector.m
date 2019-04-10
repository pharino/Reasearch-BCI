function [x,y] = remove_vector(x,y,i)
%%  Function [x,y] = remove_vector(x,y,i)
% Description: remove i_th column vector from matrix x and adds to a column
% of y. x and y must have the same row dimension

%% Code

% Remove ith vector from x
v       = x(:,i);
x(:,i)  = []; 

% Add v to y
if isempty(y)
    y = v;
else
    y(:,end + 1) = v;
end

end

