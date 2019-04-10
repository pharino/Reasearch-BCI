function [ FeatureSelect ] = position2feature( postion,feature_matrix, index_feature)
%%  position2feature
%   Input : 
%       - postion           : p scalair value of number of feature to be selected
%       - feature_matrix    : m by n matrix, m is trail, n is vaiable
%       - index_feature     : n by 1 vector of the prior selected variable

%   Output: 
%       - FeatureSelect   : m by p matrix of selected variable


%%  Select the number of index with the position
%       Select feature
IndexSelect     = index_feature(1:position);
FeatureSelect   = feature_matrix(:,IndexSelect); 

end

