%% Particle Swarm Optimization Simulation
% Simulates the movements of a swarm to minimize the objective function
%
% $$ \left( x-15 \right) ^{2}+ \left( y-20 \right) ^{2} = 0$$
%
% The swarm matrix is
%
% swarm(index, [location, velocity, best position, best
% value], [x, y components or the value component])
%
% Author: Wesam ELSHAMY (wesamelshamy@yahoo.com)
% MSc Student, Electrical Enginering Dept., Faculty of Engineering Cairo University, Egypt
%%
x1 = 0:.1:30;
x2 = 0:.1:30;
par.x.size = size(x1);
for k = 1:par.x.size(2)
    for i = 1:par.x.size(2)
        y1(k,i) = DeJong2(15,15,x1(k),x2(i));
    end
end

surf(x1,x2,y1,'edgecolor','none'); axis tight;
view(0,90);
hold on;


%% Initialization
% Parameters
iterations = 50;
inertia = 1.0;
correction_factor1 = 1.0;
correction_factor2 = 4 - correction_factor1;
swarm_size = 49;

% ---- initial swarm position -----
index = 1;
for i = 1 : 7
    for j = 1 : 7
        swarm(index, 1, 1) = i;
        swarm(index, 1, 2) = j;
        index = index + 1;
    end
end

swarm(:, 4, 1) = 1000;          % best value so far
swarm(:, 2, :) = 0;             % initial velocity

%% Iterations
for iter = 1 : iterations
    
    %-- evaluating position & quality ---
    for i = 1 : swarm_size
        swarm(i, 1, 1) = swarm(i, 1, 1) + swarm(i, 2, 1)/1.3;     %update x position
        swarm(i, 1, 2) = swarm(i, 1, 2) + swarm(i, 2, 2)/1.3;     %update y position
        x = swarm(i, 1, 1);
        y = swarm(i, 1, 2);
        
        val = DeJong2(15,15,x,y);          % fitness evaluation (you may replace this objective function with any function having a global minima)
        
        if val < swarm(i, 4, 1)                 % if new position is better
            swarm(i, 3, 1) = swarm(i, 1, 1);    % update best x,
            swarm(i, 3, 2) = swarm(i, 1, 2);    % best y postions
            swarm(i, 4, 1) = val;               % and best value
        end
    end
    
    [temp, gbest] = min(swarm(:, 4, 1));        % global best position
    
    %--- updating velocity vectors
    for i = 1 : swarm_size
        swarm(i, 2, 1) = rand*inertia*swarm(i, 2, 1) + correction_factor1*rand*(swarm(i, 3, 1) - swarm(i, 1, 1)) + correction_factor2*rand*(swarm(gbest, 3, 1) - swarm(i, 1, 1));   %x velocity component
        swarm(i, 2, 2) = rand*inertia*swarm(i, 2, 2) + correction_factor1*rand*(swarm(i, 3, 2) - swarm(i, 1, 2)) + correction_factor2*rand*(swarm(gbest, 3, 2) - swarm(i, 1, 2));   %y velocity component
    end
    
    %% Plotting the swarm
    clf
    surf(x1,x2,y1,'edgecolor','none'); axis tight;
    view(17,57);
    hold on;
    plot3(swarm(:, 1, 1), swarm(:, 1, 2),swarm(:,4,1), 'x','color','red')   % drawing swarm movements
    display('------------------------------------------------------------');
    display(strcat(num2str(swarm(:, 1, 1)),'---', num2str(swarm(:, 1, 2)),'---', num2str(swarm(:,4,1))))
    display('------------------------------------------------------------');
    pause(.2)
end