function PSO_FeatureSelection(varargin)
%   IET 2012 conference: "Optimal EEG Feature Extraction based on R-square Coefficients for Motor Imagery BCI System"
%   Input:
%       BCI competition III, dataset IVa : aa, al, av, aw, ay
%       Path handle file: D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\2012\Journal\Electronic Letter\Simulation
%       -   File : Feature Extraction.tx
%   Output:
%       -   File : Feature Selection.txt

%%  Process handels control file
%       Dataset control file
Process.File.Path        = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization';
Process.File.Name{1}     = 'PSO Feature Extraction.txt';    % Input file
Process.File.Name{2}     = 'PSO Feature Selection.txt';     % Output file

%       Control file
for i = 1:length(Process.File.Name)
    Process.File.FullName{i} = fullfile(Process.File.Path, Process.File.Name{i});
end
%       Dataset file
for i = 1:length(Process.File.FullName)
    fid                         = fopen(Process.File.FullName{i});
    Process.File.Dataset{i}     = textscan(fid,'%s','delimiter','\n');
    fclose(fid);
end

%%  Feature Extraction Process
for File = 1:length(Process.File.Dataset{1,1}{1})
    
    %   -------------------------------------------------------------------
    %%  Load dataset
    display(strcat('Loading dataset <',num2str(File),'>'));
    Process.Data.Main                   = load(Process.File.Dataset{1,1}{1}{File});
    
    %   -------------------------------------------------------------------
    %%  Sort score order by descending value
    display('Sorting weight...');
    Process.Data.Temp.FisherScore.Score             = Process.Data.Main.Information.FisherScore;
    [Process.Data.Temp.FisherScore.ScoreSort,...
        Process.Data.Temp.FisherScore.IndexSort]    = sort(Process.Data.Temp.FisherScore.Score, 'descend');
    
    %%  -------------------------------------------------------------------
    %   Creating feature vector for classification
    display('Creating features vectors...');
    Process.Data.Main.Signal                    = Process.Data.Main.Signal(:,:);
    Process.Data.Main.Information.SignalSize    = size(Process.Data.Main.Signal);
    
    %%  Particle Swarm Optimization Process
    %   -------------------------------------------------------------------
    %   Initialization inputs
    display('Initialization swarm...');
    PSO.Parameters.ParticelSize      = 25;
    PSO.Parameters.SearchDimension   = 1;
    PSO.Parameters.MaximumIteration  = round(Process.Data.Main.Information.SignalSize(2)/PSO.Parameters.ParticelSize);
    
    PSO.Parameters.C1    = 1.0;
    PSO.Parameters.C2    = 1.0;
    PSO.Parameters.W     = 1.4;
    PSO.Parameters.H     = 3;
    PSO.Parameters.Alpha = 0.90;
    PSO.Parameters.Beta  = 0.90;
    PSO.Parameters.Gamma = 0.40;
    PSO.Parameters.Etta  = 1e-5;
    PSO.Parameters.Pcr   = 0.22;
    PSO.Parameters.S     = 5;
    PSO.Parameters.AxisLimit = [1 Process.Data.Main.Information.SignalSize(2)];
    
    for d = 1:PSO.Parameters.SearchDimension
        PSO.Parameters.Vmax(d,1)  = PSO.Parameters.Gamma*(PSO.Parameters.AxisLimit(d,2)-PSO.Parameters.AxisLimit(d,1));
    end
    
    %%  Initializaton for current swarm
    %   Particle history
%     PSO.Particle.History.Position       = zeros(PSO.Parameters.SearchDimension,PSO.Parameters.ParticelSize,PSO.Parameters.MaximumIteration);
%     PSO.Particle.History.Fitness        = zeros(PSO.Parameters.SearchDimension,PSO.Parameters.ParticelSize,PSO.Parameters.MaximumIteration);
%     PSO.Particle.History.ClassFitness   = zeros(PSO.Parameters.SearchDimension,PSO.Parameters.ParticelSize,PSO.Parameters.MaximumIteration,2);
    
    %       Posotions
    for d = 1:PSO.Parameters.SearchDimension
        PSO.Particle.Current.Position(d,:) = round(rand(1,PSO.Parameters.ParticelSize).*PSO.Parameters.AxisLimit(d,2) + repmat(PSO.Parameters.AxisLimit(d,1),1,PSO.Parameters.ParticelSize));
    end
    
    %       Velocity
    PSO.Particle.Current.Velocity = zeros(PSO.Parameters.SearchDimension,PSO.Parameters.ParticelSize);
    
    %       Fitness of individual
    progressbar;
    for p = 1:PSO.Parameters.ParticelSize
        
        [PSO.Particle.Current.Fitness(p), PSO.Particle.History.ClassFitness(:,p,1,:), junk]  = SelectAndEvaluation(...
            'Selection',...
            PSO.Particle.Current.Position(1,p),...
            Process.Data.Temp.FisherScore.IndexSort,...
            Process.Data.Temp.FisherScore.Score,...
            Process.Data.Main.Information.CrossValidation,...
            Process.Data.Main.Information.class_output,...
            Process.Data.Main.Signal);
        
        progressbar(p/PSO.Parameters.ParticelSize);
    end
    
    %   Initial Personal best information
    PSO.Particle.PersonalBest.Fitness   = PSO.Particle.Current.Fitness;
    PSO.Particle.PersonalBest.Position  = PSO.Particle.Current.Position;
    PSO.Particle.PersonalBest.Velocity  = PSO.Particle.Current.Velocity;
    
    %   Find the Global best information
    PSO.Particle.GlobalBest.Index       = find(PSO.Particle.PersonalBest.Fitness == min(PSO.Particle.PersonalBest.Fitness));
    PSO.Particle.GlobalBest.Fitness     = PSO.Particle.Current.Fitness(:,PSO.Particle.GlobalBest.Index);
    PSO.Particle.GlobalBest.Position    = PSO.Particle.Current.Position(:,PSO.Particle.GlobalBest.Index);
    PSO.Particle.GlobalBest.Velocity    = PSO.Particle.Current.Velocity(:,PSO.Particle.GlobalBest.Index);  
    
    
    %%  -------------------------------------------------------------------
    %             Process searching of particle swarm optimization
    %%  -------------------------------------------------------------------
    %   Start searching process
    for i = 1:PSO.Parameters.MaximumIteration
        display(strcat('Search iteration <',num2str(i),'>'));
        
        %   Step 2.a:   Evaluate the fitness value of the particle
        display('Calculating swarm fitness...');
        progressbar;
        for p = 1:PSO.Parameters.ParticelSize
            [PSO.Particle.Current.Fitness(p), PSO.Particle.History.ClassFitness(:,p,i,:),junk]  = SelectAndEvaluation(...
                'Selection',...
                PSO.Particle.Current.Position(1,p),...
                Process.Data.Temp.FisherScore.IndexSort,...
                Process.Data.Temp.FisherScore.Score,...
                Process.Data.Main.Information.CrossValidation,...
                Process.Data.Main.Information.class_output,...
                Process.Data.Main.Signal);           

            progressbar(p/PSO.Parameters.ParticelSize);
        end
        
        %   Record history of the swarm
        PSO.Particle.History.Position(:,:,i)    = PSO.Particle.Current.Position;
        PSO.Particle.History.Fitness(:,:,i)     = PSO.Particle.Current.Fitness;
        
        %   Visualization swarm activity
        clf;
        Swarm = gcf;
        set(Swarm,...
            'Color',[1 1 1],...
            'Position',[100 200 700 500]);
        plotswarm1(...
            PSO.Particle.History.Position(:,:,i),...
            PSO.Particle.History.Fitness(:,:,i),...
            PSO.Particle.History.ClassFitness(:,:,i,:));
        axis([0 PSO.Parameters.AxisLimit(2) 0 1]);
        title(strcat('Swarm history at iteration <',num2str(i),'>'));
        
        %   Step 2.b:   Record the best particle at iteration i(maximization problem)
        PSO.Particle.GlobalBest.Index           = find(PSO.Particle.Current.Fitness == max(PSO.Particle.Current.Fitness));
        PSO.Particle.GlobalBest.Index           = min(PSO.Particle.GlobalBest.Index);
        PSO.Particle.GlobalBest.Fitness(i)      = PSO.Particle.Current.Fitness(PSO.Particle.GlobalBest.Index);
        PSO.Particle.GlobalBest.Position(:,i)   = PSO.Particle.Current.Position(:,PSO.Particle.GlobalBest.Index);
        
        %   Step 2.c:   Exit if there is no improvement over the fitness value
        if (i > PSO.Parameters.S)
            if PSO.Particle.GlobalBest.Fitness(:,i) == 0
                break;
            elseif ((abs(PSO.Particle.GlobalBest.Fitness(:,i) - PSO.Particle.GlobalBest.Fitness(:,i - PSO.Parameters.S))/abs(PSO.Particle.GlobalBest.Fitness(:,i))) < PSO.Parameters.Etta)
                break;
            end
        end
        
        %   Step 2.d:   Re-assign the initia W and the Vmax
        if (i > PSO.Parameters.H)
            if PSO.Particle.GlobalBest.Fitness(i) > PSO.Particle.GlobalBest.Fitness(i-PSO.Parameters.H)
                PSO.Parameters.Vmax  = PSO.Parameters.Beta.*PSO.Parameters.Vmax;
                PSO.Parameters.W     = PSO.Parameters.Alpha.*PSO.Parameters.W;
            end
        end
        
        
        %   Step 2.d:   Update the personal best position and the best position
        %   ever, elite particle, elite velocity
        display('Update swarm properties...');
        for p = 1:PSO.Parameters.ParticelSize
            
            %   Update personal best of particle
            if PSO.Particle.Current.Fitness(p) > PSO.Particle.PersonalBest.Fitness(p)
                
                %   Update the personal best fitness
                PSO.Particle.PersonalBest.Fitness(p)   = PSO.Particle.Current.Fitness(p);
                
                %   Update the personal best position
                PSO.Particle.PersonalBest.Position(:,p)  = PSO.Particle.Current.Position(:,p);
            end
        end
        
        for p = 1:PSO.Parameters.ParticelSize
            %   Craziness implimentation
            if rand < PSO.Parameters.Pcr
                PSO.Particle.Current.Velocity(:,p) = rand(PSO.Parameters.SearchDimension,1).* PSO.Parameters.Vmax;
            else
                PSO.Particle.Current.Velocity(:,p) = rand(PSO.Parameters.SearchDimension,1).*repmat(PSO.Parameters.W,PSO.Parameters.SearchDimension,1) .* PSO.Particle.Current.Velocity(:,p) +...
                    repmat(PSO.Parameters.C1,PSO.Parameters.SearchDimension,1) .*rand(PSO.Parameters.SearchDimension,1) .*(PSO.Particle.PersonalBest.Position(:,p) - PSO.Particle.Current.Position(:,p)) +...
                    repmat(PSO.Parameters.C2,PSO.Parameters.SearchDimension,1) .*rand(PSO.Parameters.SearchDimension,1) .*(PSO.Particle.GlobalBest.Position(:,i) - PSO.Particle.Current.Position(:,p));
            end
        end
        
        %   Update the worst particle ever
        PSO.Particle.Worst.Index           = find(PSO.Particle.Current.Fitness == max(PSO.Particle.Current.Fitness));
        PSO.Particle.Current.Position(:,PSO.Particle.Worst.Index) = PSO.Particle.GlobalBest.Position(:,i);
        
        for p = 1:PSO.Parameters.ParticelSize
            
            %   Update current position
            PSO.Particle.Current.Position(:,p)  = PSO.Particle.Current.Position(:,p) + PSO.Particle.Current.Velocity(:,p);
            PSO.Particle.Current.Position(:,p)  = round(PSO.Particle.Current.Position(:,p));
            PSO.Particle.Current.Position(:,p)  = abs(PSO.Particle.Current.Position(:,p));
            
            if PSO.Particle.Current.Position(:,p) > PSO.Parameters.AxisLimit(2)
                PSO.Particle.Current.Position(:,p) = round(rand*PSO.Parameters.AxisLimit(2));
            end
            
        end
    end
    
    %%  -------------------------------------------------------------------
    %   Create EEG structure for saving data
    Result.FisherScore  = Process.Data.Temp.FisherScore;
    Result.PSO          = PSO;
    
    %   Save Data
    display(strcat('Saving dataset <',num2str(File),'>'));
    save(Process.File.Dataset{1,2}{1}{File},'-struct','Result','FisherScore','PSO');
    Process             = rmfield(Process,'Data');
end

% %%  Utilization function
%     function plotswarm1(PlotFigure,Position, Fitness, ClassFitness)
%
%         plot(PlotFigure,Position,Fitness,'.k');
%         hold on;
%         plot(PlotFigure,Position,ClassFitness(:,1),'*k');
%         plot(PlotFigure,Position,ClassFitness(:,2),'^k');


%     end
end

