function [y] = ga_selection(varargin)
%%  Description
%   y = ga_selection(varargin) : selecting 1 individual in processs of mating of genetic algorithm
%   Input: varargin = combine string indentifier and the value of variable
%       - 'Method', method: could be one of the selection method below
%           -   'Random'    : select a random individual from population
%           -   'Rank'      : select an individual bases on rearrange ftiness value in desceding order.
%               -   'Type', type:
%                       -   'Odd'   : select the maximum odd index fitness
%                       value
%                       -   'Even'  : select the maximum even index fitness
%                       value
%           -   'Roulette'  : select an invidual by rouletting wheel method
%           -   'Tournament': selet an champion individual(the largest fitness) from the tournament candidates
%               -   'Size', size:   an integer number of the tournament
%               size for selecting candidates from the population
%           -   'FUSS'

%       - 'Fitness', fitness: 1 by n of population fitness values.
%

ga_selection.Option     = varargin{find(strcmp(varargin,'Method'))+1};
ga_selection.Fitness    = varargin{find(strcmp(varargin,'Fitness'))+1};
ga_selection.PopSize    = length(ga_selection.Fitness);

switch ga_selection.Option
    
    case 'Random'
        ga_selection.Random.Indivudual  = randi([1 ga_selection.PopSize],1);
        y = ga_selection.Random.Indivudual;
        
    case 'Rank'
        ga_selection.Rank.Type          = varargin{find(strcmp(varargin,'Type'))+1};
        [ga_selection.Rank.Fitness ga_selection.Rank.Index] = sort(ga_selection.Fitness,'descend');
        
        if strcmp(ga_selection.Rank.Type,'Odd')
            y = ga_selection.Rank.Index(1);
        elseif strcmp(ga_selection.Rank.Type,'Even')
            y = ga_selection.Rank.Index(2);
        end
        
    case 'Roulette'
        
    case 'Tournament'        
             
        %   Set tournament size to 4 if user not specify
        if ~strcmp(varargin, 'Size')
            ga_selection.Tournament.Size            = 4;
        else
            ga_selection.Tournament.Size            = varargin{find(strcmp(varargin,'Size'))+1};
        end
        
        ga_selection.Tournament.Candidate           = randi([1 ga_selection.PopSize],...
            1,ga_selection.Tournament.Size);
        while length(ga_selection.Tournament.Candidate) > length(unique(ga_selection.Tournament.Candidate))
            ga_selection.Tournament.Candidate       = randi([1 ga_selection.PopSize],...
                1,ga_selection.Tournament.Size);
        end
        ga_selection.Tournament.CandidateFitness    = ga_selection.Fitness(ga_selection.Tournament.Candidate);
        ga_selection.Tournament.Champion            = min(ga_selection.Tournament.Candidate(ga_selection.Tournament.CandidateFitness == max(ga_selection.Tournament.CandidateFitness)));
        
        %   Output the selected individual
        y = ga_selection.Tournament.Champion;
        
    case 'FUSS'
        ga_selection.FMax       = max(ga_selection.Fitness);
        ga_selection.FMin       = min(ga_selection.Fitness);
        ga_selection.FRandom    = ga_selection.FMin + (ga_selection.FMax - ga_selection.FMin)*rand;
        ga_selection.FDistance  = abs(repmat(ga_selection.FRandom,size(ga_selection.Fitness))- ga_selection.Fitness);
        y = min(find(ga_selection.FDistance == min(ga_selection.FDistance)));        
end

end

