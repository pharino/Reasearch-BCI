p1 = round(rand(1,300));
p2 = round(rand(1,300));

Parents = [p1;p2];

GeneSize = size(Parents);

x = 1:GeneSize(2);
y = 1:GeneSize(1);

Option = 'single point';

[ OffSpring ] = cross_over(Option,Parents);

figureW;

%%  Parents 1
subplot(2,1,1)
z = Parents;
colormap(gray);
surf(x,y,z);
view(0,90);
axis([1 GeneSize(2) 1 GeneSize(1)]);
ylabel('Gene');
xlabel('Gene code');
title('Parents 1');


%%  Offspring 1
subplot(2,1,2)
z =  OffSpring;
colormap(gray);
surf(x,y,z);
view(0,90);
axis([1 GeneSize(2) 1 GeneSize(1)]);
ylabel('Gene');
xlabel('Gene code');
title('Offspring 1');

%%  mutation
option  = 'binary';
mrate   = 0.20;
pop     = round(rand(50,100));
gene_structure(:,1) = 1:118;
gene_structure(1:41,2) = 1:41;
gene_structure(1:15,3) = 1:15;

[ mpop] = ga_mutation(option,pop,gene_structure,mrate);

popSize = size(pop);
x = 1:popSize(2);
y = 1:popSize(1);
colormap(gray);

subplot(2,1,1)
surf(x,y,pop);
view(0,90);
axis([1 length(x) 1 length(y)]);

subplot(2,1,2)
surf(x,y,mpop);
view(0,90);
axis([1 length(x) 1 length(y)]);


