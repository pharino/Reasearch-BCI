function [ OffSpring ] = cross_over(Option,Parents)
%%  genetic cross over producing two offspring
%   Input:
%       - Option: string for control method for cross over the chromosome
%           1)  'uniform': create random {0,1} vector with length as
%           parents chromosome and exchange the gene if the value is 1, if 0
%           the gene does not change.
%               Example:
%                       P1  : a b c d e f g
%                       P2  : 1 2 3 4 5 6 7
%                       rand: 0 0 1 1 0 1 0
%                       ch1 : a b 3 4 e 6 g
%                       ch2 : 1 2 c d 5 f 7

%           2)  'single point': create random value in range from 1 to
%           lenght of parents chromosome, and exchange chromosome of the
%           parents at that point
%           3)  'two points': create 2 randome value range from 1 to length
%           of parents chomosome and exhange the segment of the gene
%           between that 2 points.
%       - Parents: 2 by m by n matrix of {'0','1'} string. m is number of gene in a chromosome,
%           n is length of each gene
%   Output:
%       - OffSpring: 2 by m by n matrix of offspring produce by crossover

%%  Cross over:

%       change chromosome to double matrix if it is char matrix
if ischar(Parents)
    cross_over.Parents.Chromosome   = str2double(Parents);
else
    cross_over.Parents.Chromosome   = Parents;
end

cross_over.Parents.Size             = size(cross_over.Parents.Chromosome);

if length(cross_over.Parents.Size) ~= 2
    error('myApp:argChk', 'Wrong Parents matrix formation')
end

if strcmp(Option,'uniform') %   Uniform cross validation
    cross_over.IndexChange(1,:) = round(rand(1,cross_over.Parents.Size(2)));
    cross_over.IndexChange(2,:) = ~cross_over.IndexChange(1,:);
    for id = 1:cross_over.Parents.Size(1)
        if id == 1
            cid = 2;
        elseif id == 2
            cid = 1;
        end
        OffSpring(id,:) = cross_over.Parents.Chromosome(id,:).*cross_over.IndexChange(1,:) +...
            cross_over.Parents.Chromosome(cid,:).*cross_over.IndexChange(2,:);
    end

    
elseif strcmp(Option,'single point') %   Single point cross validation
    
    %   Create single line chrmomsome
    cross_over.CrossPoint           = round(rand*length(cross_over.Parents.Chromosome));
    for id = 1: cross_over.Parents.Size(1)
        if id == 1
            cid = 2;
        elseif id == 2
            cid = 1;
        end
        OffSpring(id,:)    = [cross_over.Parents.Chromosome(id,1:cross_over.CrossPoint),...
            cross_over.Parents.Chromosome(cid,cross_over.CrossPoint+1:length(cross_over.Parents.Chromosome))];       
    end
    
elseif strcmp(Option,'two points') %    Two points cross validation
    %   Create single line chrmomsome
    cross_over.Parents.Chromosome   = cross_over.Parents.Chromosome(:,:);
    cross_over.CrossPoint(1)           = round(rand*length(cross_over.Parents.Chromosome));
    cross_over.CrossPoint(2)           = round(rand*length(cross_over.Parents.Chromosome));
    cross_over.CrossPoint = sort(cross_over.CrossPoint,'ascend');
    for id = 1: cross_over.Parents.Size(1)
        if id == 1
            cid = 2;
        elseif id == 2
            cid = 1;
        end
        OffSpring(id,:)    = [cross_over.Parents.Chromosome(id,1:cross_over.CrossPoint(1)),...
            cross_over.Parents.Chromosome(cid,cross_over.CrossPoint(1)+1:cross_over.CrossPoint(2)),...
            cross_over.Parents.Chromosome(id,cross_over.CrossPoint(2)+1:length(cross_over.Parents.Chromosome))];
    end    
end

%%  Create char array if input is char array 
if ischar(Parents)
    OffSpring   = str2double(OffSpring(:,:));
end

end

