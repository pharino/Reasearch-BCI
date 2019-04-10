function [Q R] = matrix_qr(X)

%%  Definition
%   function [Q R] = matrix_qr(X): deconpose matrix A: m by n to
%   orthonormal unitary matrix Q(m by m) and a upper diagonal matrix R(m by
%   n) such that A = Q*R

%%  Data
%       Input
%       -   X: m X n matrix
%       Output
%       -   Q
%       -   R

%%  Coding
[m n] = size(X);

Q = zeros(m,m);
R = zeros(m,n);

for i = 1:n    
    if i == 1
        u = X(:,i);        
    else        
        s = 0;
        for k = 1:(i-1)
            s = s + ((X(:,i)')*Q(:,k))*Q(:,k);
            R(k,i) = (X(:,i)')*Q(:,k);
        end        
        u = X(:,i) - s;        
    end    
    Q(:,i) = u/norm(u,2);
    R(i,i) = (X(:,i)')*Q(:,i);    
end

