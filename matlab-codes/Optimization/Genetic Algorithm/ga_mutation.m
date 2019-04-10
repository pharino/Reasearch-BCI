function [ mpop] = ga_mutation(option,pop,gene_structure,mrate)

%%  -----------------------------------------------------------------------
%   ga_mutation: muation gene in the chromosome population base on the mutation rate and the gene structure
%   Input:
%       -   Option: 
%               1)  'binary': binary genetic problem
%               2)  'custom': custom structure of genetic algorithm
%       -   pop: m by n matrix of chomosom population. m is population
%       number, n is number of variable in gene
%       -   gene_structure: matrix of gene structure
%       -   mrate: mutation rate value [0 1]
%   Output:
%       -   mpop: mutated chromosome population

%%  -----------------------------------------------------------------------
%   Code flow:

if ischar(pop)
    ga_mutation.Population   = pop - '0';
else
    ga_mutation.Population   = pop;
end

ga_mutation.PopSize     = size(ga_mutation.Population);
ga_mutation.GeneSize    = size(gene_structure);
ga_mutation.Number      = round(mrate*prod(ga_mutation.PopSize));
ga_mutation.PopIndex    = [round(rand(1,ga_mutation.Number)*(ga_mutation.PopSize(1)-1))+1;...   
    round(rand(1,ga_mutation.Number)*(ga_mutation.PopSize(2)-1))+1];

%%  Create index of gene in the mutation process
ga_mutation.GeneIndex   = mod(ga_mutation.PopIndex(1,:),ga_mutation.GeneSize(2));

for ind = 1:length(ga_mutation.GeneIndex)
    if ga_mutation.GeneIndex(ind) == 0;
        ga_mutation.GeneIndex(ind) = ga_mutation.GeneSize(2);
    end    
end

%%  Mutation the population
if strcmp(option,'Binary')% Binary case the mutate variable is compliment of the original variable
    
    for ind = 1:ga_mutation.Number
        ga_mutation.Population(ga_mutation.PopIndex(1,ind),ga_mutation.PopIndex(2,ind)) = ~ga_mutation.Population(ga_mutation.PopIndex(1,ind),ga_mutation.PopIndex(2,ind));
    end      
    
elseif strcmp(option,'Custom') % The mutate variable is selected randomly from the gene structure   
    
    for ind = 1:ga_mutation.Number
        ga_mutation.GeneVaribale    = find(gene_structure(:,ga_mutation.GeneIndex(ind)));
        ga_mutation.MVariable       = ga_mutation.GeneVaribale(round(rand*(length(ga_mutation.GeneVaribale)-1)+ 1)); 
        ga_mutation.Population(ga_mutation.PopIndex(1,ind),ga_mutation.PopIndex(2,ind)) = ga_mutation.MVariable;
    end   
    
end
mpop = ga_mutation.Population;
end

