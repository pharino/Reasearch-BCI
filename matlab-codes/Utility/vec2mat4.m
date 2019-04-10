function [ matrix4 ] = vec2mat4( vector, dimension)
%   Function : vec2mat3 = create 3 depth matrix from single column vector
%   Input:
%       - vector    : p by 1 vector
%       - dimesion  : [m n k q], m,n,k ,q is dimesion for each depth, p =
%       m*n*k*q
%   Output:
%       - matrix    : m by n by k by q matrix
%   Check dimension of inputs
if length(vector) ~=  prod(dimension)
    error('myApp:argChk', 'Dimension of input are not equal');
else
    %   Check if 'vector' is column, transpose to row vector to process
    if iscolumn(vector)
        vector  = vector';
    end
    
    %   Create 2-D matrix
    temp1     = vec2mat(vector,dimension(1));   
    temp1     = temp1'; 
    
    %   Create 4-D matrix
    progressbar;
    for m = 1:dimension(1)
        temp2   = vec2mat(temp1(m,:),dimension(2));
        temp2   = temp2';
        
        for n = 1:dimension(2)
            temp3   = vec2mat(temp2(n,:),dimension(3));
            temp3   = temp3';
            matrix4(m,n,:,:) = temp3;
        end
        progressbar(m/dimension(1));
    end 
    
    %   Create 4-D matrix
end

end

