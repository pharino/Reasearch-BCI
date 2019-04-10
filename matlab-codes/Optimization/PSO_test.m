function [ output_args ] = PSO_test( input_args )

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
figure
surf(x1,x2,y1,'edgecolor','none'); axis tight;
view(0,90);
hold on;
%%  Particle Swarm Optimization Process
%   -----------------------------------------------------------------------
%   Initialization inputs

PSO.Paramters.ParticelSize      = 30;
PSO.Paramters.SearchDimension   = 2;
PSO.Paramters.MaximumIteration  = 50;
PSO.Paramters.Cognition         = 3;
PSO.Paramters.Social            = 2;
PSO.Paramters.InitiaFactor      = linspace(1.4,0.8,PSO.Paramters.MaximumIteration);

%   Initializing Swarm posotions and velocities
%   Initial position [0 1] space
PSO.Particle.Current.Position = rand(PSO.Paramters.ParticelSize,...
    PSO.Paramters.SearchDimension) -  rand(PSO.Paramters.ParticelSize,...
    PSO.Paramters.SearchDimension);
%   Initial velocity [0 1]
PSO.Particle.Current.Velocity = zeros(PSO.Paramters.ParticelSize,...
    PSO.Paramters.SearchDimension);
%   Initial best fitness of individual
for p = 1:PSO.Paramters.ParticelSize
    PSO.Particle.Current.Fitness(p,1) = DeJong2(0,0,...
        PSO.Particle.Current.Position(p,1),...
        PSO.Particle.Current.Position(p,2));
end
%   Initial Personal best information
PSO.Particle.PersonalBest.Position  = PSO.Particle.Current.Position;
PSO.Particle.PersonalBest.Fitness   = PSO.Particle.Current.Fitness;
%   Find the Global best information
PSO.Particle.GlobalBest.Index       = find(PSO.Particle.PersonalBest.Fitness == min(PSO.Particle.PersonalBest.Fitness));
PSO.Particle.GlobalBest.Fitness     = PSO.Particle.Current.Fitness(PSO.Particle.GlobalBest.Index);
PSO.Particle.GlobalBest.Position    = PSO.Particle.Current.Position(PSO.Particle.GlobalBest.Index,:);

%   Iniltial
for i = 1:PSO.Paramters.MaximumIteration
    
    for p = 1:PSO.Paramters.ParticelSize
        
        %   Evaluate particle fitness value
        PSO.Particle.Current.Fitness(p) = Rastrigin2(...
            PSO.Particle.Current.Position(p,1),...
            PSO.Particle.Current.Position(p,2));
        if PSO.Particle.Current.Fitness(p) > PSO.Particle.PersonalBest.Fitness(p)
            
            %   Update the personal best fitness
            PSO.Particle.PersonalBest.Fitness   = PSO.Particle.Current.Fitness;
            
            %   Update the personal best position
            PSO.Particle.PersonalBest.Position  = PSO.Particle.Current.Position;
            
        end
    end
    %   Update global particle best information(All particles in the swarm)
    PSO.Particle.GlobalBest.Index       = find(PSO.Particle.Current.Fitness == min(PSO.Particle.Current.Fitness));
    PSO.Particle.GlobalBest.Fitness     = PSO.Particle.Current.Fitness(PSO.Particle.GlobalBest.Index);
    PSO.Particle.GlobalBest.Position    = PSO.Particle.Current.Position(PSO.Particle.GlobalBest.Index,:);
    
    %   Evaluate particles velocity
    for p = 1:PSO.Paramters.ParticelSize
        
    end
    %   For every particle
    for p = 1:PSO.Paramters.ParticelSize
        %   Update Velocity
        PSO.Particle.Current.Velocity(p,:)    = UpdateVelocity(i,...
            PSO.Particle.Current.Velocity(p,:),...
            PSO.Particle.Current.Position(p,:),...
            PSO.Particle.PersonalBest.Position(p,:),...
            PSO.Particle.GlobalBest.Position,...
            PSO.Paramters.Cognition,...
            PSO.Paramters.Social,...
            PSO.Paramters.InitiaFactor);
        %   Update current position
        PSO.Particle.Current.Position(p,:)    = UpdatePosition(PSO.Particle.Current.Position(p,:),...
            PSO.Particle.Current.Velocity(p,:));
    end
    
    %% Plotting the swarm
    clf
    surf(x1,x2,y1,'edgecolor','none'); axis tight;
    view(100,75);
    hold on;
    plot3(PSO.Particle.Current.Position(:,1),...
        PSO.Particle.Current.Position(:,2),...
        PSO.Particle.PersonalBest.Fitness,...
        'x','color','white')   % drawing swarm movements
    axis([-1 1 -1 1]);
    display(' ');
    display('------------------------------------------');
    display(' X position    Y position   Fitness value')
    display('------------------------------------------');
    display(strcat(num2str(PSO.Particle.Current.Position(:,1)),'---',...
        num2str(PSO.Particle.Current.Position(:,1)),'---',...
        num2str(PSO.Particle.Current.Velocity(:,1)),'---',...
        num2str(PSO.Particle.Current.Velocity(:,2)),'---',...
        num2str(PSO.Particle.Current.Fitness)))
    display('------------------------------------------');
    pause(.1)
    i
end

    function Velocity = UpdateVelocity(Iteration,Currentvelocity,CurrentPosition,PersonalbestPosition,GlobalBestPosition,Cognition,Social,InitiaFactor)
        
        for k = 1:length(CurrentPosition)
            Velocity(k,1) = rand*InitiaFactor(Iteration)*Currentvelocity(k) + Cognition*rand()*(PersonalbestPosition(k) - CurrentPosition(k)) + Social*rand()*(GlobalBestPosition(k) - CurrentPosition(k));
        end
        
    end
    function Position = UpdatePosition(CurrentPosition,Currentvelocity)
        
        for k = 1:length(CurrentPosition)
            Position(k,1) = CurrentPosition(k) + Currentvelocity(k);
        end
        
    end


end

