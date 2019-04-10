function [ output_args ] = PSO_test3( input_args )

%   Clear memory
clear;

%%  Create test bench
x1 = -1:.01:1;
x2 = -1:.01:1;
par.x.size = size(x1);
for m = 1:par.x.size(2)
    for i = 1:par.x.size(2)
        y1(m,i) = Rastrigin2(x1(m),x2(i));
    end
end

%%  Particle Swarm Optimization Process
%   -----------------------------------------------------------------------
%   Initialization inputs

PSO.Paramters.ParticelSize      = 30;
PSO.Paramters.SearchDimension   = 2;
PSO.Paramters.MaximumIteration  = 500;

PSO.Paramters.C1    = 0.50;
PSO.Paramters.C2    = 1.50;
PSO.Paramters.W    = 1.4;
PSO.Paramters.H     = 3;
PSO.Paramters.Alpha = 0.95;
PSO.Paramters.Beta  = 0.90;
PSO.Paramters.Gamma = 0.40;
PSO.Paramters.Etta  = 1e-3;
PSO.Paramters.Pcr   = 0.22;
PSO.Paramters.S     = 10;
PSO.Paramters.AxisLimit = [-2 2; -1 1];
for d = 1:PSO.Paramters.SearchDimension
    PSO.Paramters.Vmax(d,1)  = PSO.Paramters.Gamma*(PSO.Paramters.AxisLimit(d,2)-PSO.Paramters.AxisLimit(d,1));
end


%   Initializing Swarm posotions and velocities
for d = 1:PSO.Paramters.SearchDimension
    PSO.Particle.Current.Position(d,:) = rand(1,PSO.Paramters.ParticelSize).*PSO.Paramters.AxisLimit(d,2) + repmat(PSO.Paramters.AxisLimit(d,1),1,PSO.Paramters.ParticelSize);
end

%   Initial velocity
PSO.Particle.Current.Velocity = zeros(PSO.Paramters.SearchDimension,PSO.Paramters.ParticelSize);

%   Initial fitness of individual
for p = 1:PSO.Paramters.ParticelSize
    PSO.Particle.Current.Fitness(1,p) = DeJong2(0,0,...
        PSO.Particle.Current.Position(1,p),...
        PSO.Particle.Current.Position(2,p));
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


%   Iniltial
for i = 1:PSO.Paramters.MaximumIteration
    
    %   Step 2.a:   Evaluate the fitness value of the particle
    for p = 1:PSO.Paramters.ParticelSize
        
        %   Evaluate particle fitness value
        PSO.Particle.Current.Fitness(p) = Rastrigin2(...
            PSO.Particle.Current.Position(1,p),...
            PSO.Particle.Current.Position(2,p));
    end
    
    %   Step 2.a:   Record the best particle at iteration i
    PSO.Particle.GlobalBest.Index           = find(PSO.Particle.Current.Fitness == min(PSO.Particle.Current.Fitness));
    PSO.Particle.GlobalBest.Index           = max(PSO.Particle.GlobalBest.Index);
    PSO.Particle.GlobalBest.Fitness(i)      = PSO.Particle.Current.Fitness(PSO.Particle.GlobalBest.Index);
    PSO.Particle.GlobalBest.Position(:,i)   = PSO.Particle.Current.Position(:,PSO.Particle.GlobalBest.Index);
    
    %   Step 2.b:   Exit if there is no improvement over the fitness value
    if (i > PSO.Paramters.S)
        if ((abs(PSO.Particle.GlobalBest.Fitness(:,i) - PSO.Particle.GlobalBest.Fitness(:,i - PSO.Paramters.S))/abs(PSO.Particle.GlobalBest.Fitness(:,i))) < PSO.Paramters.Etta)
            break;
        end
    end
    
    %   Step 2.c:   Re-assign the initia W and the Vmax
    if (i > PSO.Paramters.H)
        if PSO.Particle.GlobalBest.Fitness(i) < PSO.Particle.GlobalBest.Fitness(i-PSO.Paramters.H)
            PSO.Paramters.Vmax  = PSO.Paramters.Beta.*PSO.Paramters.Vmax;
            PSO.Paramters.W     = PSO.Paramters.Alpha.*PSO.Paramters.W;
        end
    end
    
    
    %   Step 2.d:   Update the personal best position and the best position
    %   ever, elite particle, elite velocity
    for p = 1:PSO.Paramters.ParticelSize
        
        %   Update personal best of particle
        if PSO.Particle.Current.Fitness(p) < PSO.Particle.PersonalBest.Fitness(p)
            
            %   Update the personal best fitness
            PSO.Particle.PersonalBest.Fitness(p)   = PSO.Particle.Current.Fitness(p);
            
            %   Update the personal best position
            PSO.Particle.PersonalBest.Position(:,p)  = PSO.Particle.Current.Position(:,p);
        end
    end
    
    for p = 1:PSO.Paramters.ParticelSize
        %   Craziness implimentation
        if rand < PSO.Paramters.Pcr
            PSO.Particle.Current.Velocity(:,p) = rand(PSO.Paramters.SearchDimension,1).* PSO.Paramters.Vmax;
        else
            PSO.Particle.Current.Velocity(:,p) = repmat(PSO.Paramters.W,PSO.Paramters.SearchDimension,1) .* PSO.Particle.Current.Velocity(:,p) +...
                repmat(PSO.Paramters.C1,PSO.Paramters.SearchDimension,1) .*rand(PSO.Paramters.SearchDimension,1) .*(PSO.Particle.PersonalBest.Position(:,p) - PSO.Particle.Current.Position(:,p)) +...
                repmat(PSO.Paramters.C2,PSO.Paramters.SearchDimension,1) .*rand(PSO.Paramters.SearchDimension,1) .*(PSO.Particle.GlobalBest.Position(:,i) - PSO.Particle.Current.Position(:,p));
        end
    end
    
    %   Update the worst particle ever
    PSO.Particle.Worst.Index           = find(PSO.Particle.Current.Fitness == max(PSO.Particle.Current.Fitness));
    PSO.Particle.Current.Position(:,PSO.Particle.Worst.Index) = PSO.Particle.GlobalBest.Position(:,i);
    
    for p = 1:PSO.Paramters.ParticelSize
        
        %   Update current position
        PSO.Particle.Current.Position(:,p)    = PSO.Particle.Current.Position(:,p) + PSO.Particle.Current.Velocity(:,p);
        %         PSO.Particle.Current.Position(:,p)    = PSO.Particle.Elite.Position + PSO.Paramters.C3 .*rand(PSO.Paramters.SearchDimension,1) .* PSO.Particle.Current.Velocity(:,PSO.Particle.GlobalBest.Index);
        
    end
    %% Plotting the swarm
    clf
%     surf(x1,x2,y1,'edgecolor','none'); axis tight;    
%     hold on;
    plot3(PSO.Particle.Current.Position(1,:),...
        PSO.Particle.Current.Position(2,:),...
        PSO.Particle.PersonalBest.Fitness,...
        '*','color','k')   % drawing swarm movements
    axis([-2 2 -1 1]);
    view(0,90);
    grid on;
    
    display(' ');
    display('------------------------------------------');
    display(' X position    Y position   Fitness value')
    display('------------------------------------------');
    display(strcat(...
        num2str(PSO.Particle.Current.Position(1,:)'),'---',...
        num2str(PSO.Particle.Current.Position(2,:)'),'---',...
        num2str(PSO.Particle.Current.Fitness(1,:)')));
    display(strcat('Iteration:-',num2str(i)))
    pause(.1)
end


%%  -----------------------------------------------------------------------
%                               Uitility functions
%%  -----------------------------------------------------------------------


end

