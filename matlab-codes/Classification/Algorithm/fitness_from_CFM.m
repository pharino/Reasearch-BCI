function f = fitness_from_CFM(M,v1,alpha,i)
%%  Function f = fitness_from_CFM(M,v1,i)
% Description: calculate various fitness value depend on i index

%% Input: 
%   -   M : confusion matrix
%   -   v1: variable ratio 
%   -   alpha: weights of variable. It is 2 dimension matrix
%   -   i: index indentifies output fitness

% Classification error rate
if isscalar(M)
    error_rate   = 0;
    kappa       = 1; 
else
    % Error rate
    error_rate  = (M(1,2) + M(2,1))/sum(sum(M));
    % Kappa coefficient
    kappa       = kappa_from_CFM(M);
    
end



switch i 
    case 1
        f = error_rate;
    case 2
        f = (alpha(1)*error_rate + alpha(2)*v1)/sum(alpha);
    case 3
        f = error_rate^2;
    case 4
        f = (alpha(1)*error_rate^2 + alpha(2)*v1)/sum(alpha);
    case 5
        f = 1 - kappa;
    case 6
        f = (alpha(1)*(1 - kappa) + alpha(2)*v1)/sum(alpha); 
    case 7
        f = (1-kappa)^2;
    case 8
        f = (alpha(1)*(1-kappa)^2 + alpha(2)*v1)/sum(alpha);
end

end

