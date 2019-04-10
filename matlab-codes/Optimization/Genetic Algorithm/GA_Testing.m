function [ output_args ] = GA_Testing( input_args )
%%  [ output_args ] = GA_Testing( input_args )
%   Use for testing genetic algorithm code
clear;
%%  -----------------------------------------------------------------------
%   Predisplay plot parameters
GA.View.X(1,:) = linspace(0,2,100);
GA.View.X(2,:) = linspace(0,2,100);
for i = 1:length(GA.View.X(1,:))
    for k = 1:length(GA.View.X(2,:))
        GA.View.XTemp = [GA.View.X(1,i), GA.View.X(2,k)];
        GA.View.Y(i,k) = Rastrigin2(GA.View.XTemp);
    end
end

%%  -----------------------------------------------------------------------
%   GA parameters
GA.Parameters.FF    = @Rastrigin2;
GA.Parameters.NPar  = 2;
GA.Parameters.MaxIt = 500;
GA.Parameters.PSize = 10;
GA.Parameters.MRate = 0.05;
GA.Parameters.SRate = 0.5;
GA.Parameters.PNBit = 8;
GA.Parameters.CHBit = GA.Parameters.NPar*GA.Parameters.PNBit;
GA.Parameters.NKeep = floor(GA.Parameters.SRate*GA.Parameters.PSize);
if mod(GA.Parameters.NKeep,2) == 1
    GA.Parameters.NKeep = GA.Parameters.NKeep + 1;
end

%   Create initial population
GA.Chromosome.Pop   = round(rand(GA.Parameters.PSize,GA.Parameters.CHBit));

%   Calculate fitness value of chromosome
for i = 1:GA.Parameters.PSize
    GA.Chromosome.CPop(i,:) = decodepop(0,2,GA.Parameters.PNBit,GA.Chromosome.Pop(i,:));
    GA.Chromosome.Fitness(i)= feval(GA.Parameters.FF,GA.Chromosome.CPop(i,:));
end

%   Sort population according to their fitness in descending order
[GA.Chromosome.Fitness, GA.Chromosome.Index] = sort(GA.Chromosome.Fitness,'descend');
GA.Chromosome.Pop       = GA.Chromosome.Pop(GA.Chromosome.Index,:);
GA.Chromosome.CPop      = GA.Chromosome.CPop(GA.Chromosome.Index,:);

%   Elitism
GA.Elit.Chromosome      = GA.Chromosome.Pop(1,:);
GA.Elit.Fitness         = GA.Chromosome.Fitness(1);
GA.Elit.C               = GA.Chromosome.CPop(1);

%   Record history of GA
GA.History.Fitness.Best(1)  = max(GA.Chromosome.Fitness);
GA.History.Fitness.Worst(1) = min(GA.Chromosome.Fitness);
GA.History.Fitness.Mean(1)  = mean(GA.Chromosome.Fitness);

%   GA process

for i = 1:GA.Parameters.MaxIt
    
    GA.Reproduction.OffSpring.RverseCount = GA.Parameters.PSize;
    
    for P = 1:GA.Reproduction.OffSpring.RverseCount/2
        
                %   Tournament selection
                GA.Reproduction.Parents.Index(1) = ga_selection('Method','Tournament',...
                    'Fitness',GA.Chromosome.Fitness,...
                    'Size',4);
                GA.Reproduction.Parents.Index(2) = ga_selection('Method','Tournament',...
                    'Fitness',GA.Chromosome.Fitness,...
                    'Size',4);
        
                while GA.Reproduction.Parents.Index(1) == GA.Reproduction.Parents.Index(2)
                     GA.Reproduction.Parents.Index(2) = ga_selection('Method','Tournament',...
                    'Fitness',GA.Chromosome.Fitness,...
                    'Size',4);
                end
        
%         %   Random selection
%         GA.Reproduction.Parents.Index(1) = ga_selection('Method','Random',...
%             'Fitness',GA.Chromosome.Fitness);
%         
%         GA.Reproduction.Parents.Index(2) = ga_selection('Method','Random',...
%             'Fitness',GA.Chromosome.Fitness);
%         
%         while GA.Reproduction.Parents.Index(1) == GA.Reproduction.Parents.Index(2)
%             GA.Reproduction.Parents.Index(2) = ga_selection('Method','Tournament',...
%                 'Fitness',GA.Chromosome.Fitness);
%         end
%         
        %   Get chromosome ready for mating
        
        GA.Reproduction.Parents.Index = GA.Reproduction.Parents.Index(:);
        GA.Reproduction.Parents.Chromosome  = GA.Chromosome.Pop(GA.Reproduction.Parents.Index,:);
        
        %   Cross-over processs
        GA.Reproduction.OffSpring.Chromosome((GA.Parameters.PSize - (P-1)*2):-1:(GA.Parameters.PSize - (P-1)*2-1),:) = ga_crossover(...
            'two points',GA.Reproduction.Parents.Chromosome);
        
    end
    
    %   Replace the bad population
    GA.Chromosome.Pop   = GA.Reproduction.OffSpring.Chromosome;
    %     GA.Chromosome.Pop = GA.Reproduction.OffSpring.Chromosome;
    
    %   Process mutation
    GA.Chromosome.Pop   = ga_mutation('binary',GA.Chromosome.Pop,[0 1; 0 1],GA.Parameters.MRate);
    
    %   Evaluation the fitness
    for k = 1:GA.Parameters.PSize
        GA.Chromosome.CPop(k,:)     = decodepop(0,2,GA.Parameters.PNBit,GA.Chromosome.Pop(k,:));
        GA.Chromosome.Fitness(k)    = feval(GA.Parameters.FF,GA.Chromosome.CPop(k,:));
    end
    
    %   Rank the population
    [GA.Chromosome.Fitness, GA.Chromosome.Index] = sort(GA.Chromosome.Fitness,'descend');
    GA.Chromosome.Pop       = GA.Chromosome.Pop(GA.Chromosome.Index,:);
    GA.Chromosome.CPop      = GA.Chromosome.CPop(GA.Chromosome.Index,:);
    
    %   Elitism
    if GA.Chromosome.Fitness(1) > GA.Elit.Fitness
        GA.Elit.Chromosome      = GA.Chromosome.Pop(1,:);
        GA.Elit.Fitness         = GA.Chromosome.Fitness(1);
        GA.Elit.C               = GA.Chromosome.CPop(1);
    else
        GA.Chromosome.Pop(1,:)  = GA.Elit.Chromosome;
        GA.Chromosome.Fitness(1)= GA.Elit.Fitness;
        GA.Chromosome.CPop(1)   = GA.Elit.C;
    end
    
    %   Record performance of GA
    GA.History.Fitness.Best(i)  = max(GA.Chromosome.Fitness);
    GA.History.Fitness.Worst(i) = min(GA.Chromosome.Fitness);
    GA.History.Fitness.Mean(i)  = mean(GA.Chromosome.Fitness);
    
    %   Stopping criteria
    
    %%  -------------------------------------------------------------------
    %   Display
    gcf;
    cla;
    set(gcf,'Position',[1650 50 1050 620]);
    
    subplot(2,2,1)  % Visual population chromosome
    colormap(gray);
    surf(1:GA.Parameters.CHBit,...
        1:GA.Parameters.PSize,...
        GA.Chromosome.Pop);
    view(0,90);
    axis([1 GA.Parameters.CHBit, 1 GA.Parameters.PSize]);
    xlabel('Chomosome');
    ylabel('Population');
    title('Chromosome');
    
    
    subplot(2,2,3)  % Visual population fitness
    bar(GA.Chromosome.Fitness);
    axis([0 GA.Parameters.PSize, 0 100]);
    xlabel('Individual');
    ylabel('Fitness value');
    title('Individual fitness');
    
    
    subplot(2,2,2) % Visual the searching space
    surf(GA.View.X(1,:), GA.View.X(2,:), GA.View.Y);
    caxis([0 60]);
    view(0,90);
    hold on;       
    plot3(GA.Chromosome.CPop(:,1),GA.Chromosome.CPop(:,2),GA.Chromosome.Fitness,'*y');
    plot3(GA.Chromosome.CPop(1,1),GA.Chromosome.CPop(1,2),GA.Chromosome.Fitness,'^r'); 
    axis([0 2 0 2]);
    xlabel('X position');
    ylabel('Y position');
    title(strcat('Iteration <',num2str(i),'>'));
    hold off;
    
    subplot(2,2,4) % Visual the population fitness
    plot(1:length(GA.History.Fitness.Best),GA.History.Fitness.Best,'-k');
    hold on;
    plot(1:length(GA.History.Fitness.Mean),GA.History.Fitness.Mean,'-b');
    plot(1:length(GA.History.Fitness.Worst),GA.History.Fitness.Worst,'-r');
    axis([0 GA.Parameters.MaxIt+50 0 100]);
    xlabel('Iteration');
    ylabel('Fitness value(maximun problem)');
    title('GA fintess history');
    legend('Best',...
        'Mean',...
        'Worst');
    hold off;
    
    %   Pause for animation
    pause(0.1);
end



end

