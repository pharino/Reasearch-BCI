function plotswarm1(Position, Fitness, ClassFitness)
gcf;


ClassFitness = ClassFitness(:,:,:);
ClassFitness = ClassFitness(:);
ClassFitness = vec2mat(ClassFitness,length(Position));
ClassFitness = ClassFitness';

%   Display plot of swarm
plot(Position,Fitness,'.k');
hold on;
plot(Position,ClassFitness(:,1),'*k');
plot(Position,ClassFitness(:,2),'ok');
xlabel('Particle position(x_{id})');
ylabel('FT/ E1,E2');
legend('FT',...
    'E1',...
    'E1');

end