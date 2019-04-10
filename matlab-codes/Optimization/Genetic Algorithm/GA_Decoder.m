function [Feature,K] = GA_Decoder(Chromosome,Signal,varargin)

%%  Description
%   [Feature,K] = GA_Decoder(Chromosome,Signal,varargin)

%%  -----------------------------------------------------------------------
GA_Decoder.Type     = varargin{find(strcmp(varargin,'Type'))+1};
GA_Decoder.Method   = varargin{find(strcmp(varargin,'Method'))+1};

if strcmp(GA_Decoder.Type, 'Binary')
    
    GA_Decoder.ChromosomeSize = varargin{find(strcmp(varargin,'Size'))+1};
    switch GA_Decoder.Method
        case 0 % Pure binary code covert banry value of chromosome to integer value
        case 1 % Chromosome is binary concenation of [electrode, frequency-band, time]. 1 specify a parameter is selected, 0 not selected
            
            %   Divide chromosome into block of electrode, frequency, time
            for i = 1:length(GA_Decoder.ChromosomeSize)
                GA_Decoder.Up   = sum(GA_Decoder.ChromosomeSize(1:i));
                GA_Decoder.Low  = 1 + GA_Decoder.Up - GA_Decoder.ChromosomeSize(i);
                GA_Decoder.BinBlock{i}      = Chromosome(GA_Decoder.Low:GA_Decoder.Up);
                GA_Decoder.IndexBlock{i}    = find(GA_Decoder.BinBlock{i});
                K(i)                        = length(GA_Decoder.IndexBlock{i}); 
            end
            switch length(GA_Decoder.ChromosomeSize)
                case 1
                    Feature     = Signal(:,GA_Decoder.IndexBlock{1});
                case 2
                    Feature     = Signal(:,GA_Decoder.IndexBlock{1},GA_Decoder.IndexBlock{2});
                case 3
                    Feature     = Signal(:,GA_Decoder.IndexBlock{1},GA_Decoder.IndexBlock{2},GA_Decoder.IndexBlock{3});
            end
            
            
        case 2 %
    end
    
elseif strcmp(GA_Decoder.Type, 'Custom')
    %   Reduce the repeating gene
    Feature = [];
    Chromosome = unique(Chromosome);
    K = length(Chromosome);
    
    switch GA_Decoder.Method
        case 0
            Feature = Signal(:,Chromosome);
            
        case 1
            %   Create feature matrix
            for i = 1:length(Chromosome);
                Feature = [Feature, Signal{Chromosome(i)}];
            end
            
        case 2
            
    end
    
end





end

