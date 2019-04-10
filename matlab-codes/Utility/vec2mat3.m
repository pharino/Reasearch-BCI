function [ matrix3 ] = vec2mat3( vector, dimension)
%   Function : vec2mat3 = create 3 depth matrix from single column vector
%   Input:
%       - vector    : p by 1 vector
%       - dimesion  : [m n k], m,n,k is dimesion for each depth, p = m*n*k
%   Output:
%       - matrix    : m by n by k matrix
%   Check dimension of inputs
if length(vector) ~=  prod(dimension)
    error('myApp:argChk', 'Dimension of input are not equal');
else
    %   Check if 'vector' is column, transpose to row vector to process
    if iscolumn(vector)
        vector  = vector';
    end
    
    %   Create 2-D matrix
    matrix2     = vec2mat(vector,dimension(1));   
    matrix2     = matrix2'; 
    
    %   Create 3-D matrix
    for m = 1:dimension(1)
        temp            = vec2mat(matrix2(m,:),dimension(2));
        matrix3(m,:,:)  = temp';
    end    
end

end

