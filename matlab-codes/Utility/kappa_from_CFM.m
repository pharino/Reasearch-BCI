function k = kappa_from_CFM(m)
%% k = kappa_from_CFM(m)
%   Calcuating Kappa coefficient from confusion matrix m. m is 2x2 matrix 
%   where m(1,1) is number of true positive,m(1,2) is number of true 
%   negative,m(2,1) is number of false negative, m(2,2) is number of true
%   negative

%% Code

kappa_from_CFM.All = sum(sum(m));
kappa_from_CFM.Pr_a     = (m(1,1) + m(2,2))/kappa_from_CFM.All;
kappa_from_CFM.True     = ((m(1,1)+m(1,2))/kappa_from_CFM.All)*(m(1,1)+m(2,1))/kappa_from_CFM.All;
kappa_from_CFM.False    = ((m(2,1)+m(2,2))/kappa_from_CFM.All)*(m(1,2)+m(2,2))/kappa_from_CFM.All;
kappa_from_CFM.Pr_e     = kappa_from_CFM.True  + kappa_from_CFM.False;

k = (kappa_from_CFM.Pr_a - kappa_from_CFM.Pr_e)/(1 - kappa_from_CFM.Pr_e);

end

