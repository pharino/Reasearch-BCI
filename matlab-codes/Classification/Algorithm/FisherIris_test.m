%%  Load data
clear all;
load fisheriris;
example.class = unique(species);

for i = 1:length(species)
    if strcmp(species(i),example.class(1))
        Y(i) = 1;
    elseif strcmp(species(i),example.class(2))
        Y(i) = 2;
    else
        Y(i) = 3;
    end
end

%%  
X = meas([1:50,51:100],...
    1:2);
X = X';

Y = Y([1:50,51:100]);
Y = Y(:);

[W,S,E] = Perceptron(X,Y);

%%  Training graph
subplot(2,1,1);
plot(E.*100);
axis([0 length(E) 0 100]);
xlabel('Iteration');
ylabel('Mean square error');

%%  Create decision line
x = linspace(4,8,40);
y = -W(2)/W(3).*x - W(1)/W(3);

subplot(2,1,2);
scatter(X(1,1:50),X(2,1:50),'or');
hold on;
scatter(X(1,51:100),X(2,51:100),'*b');
plot(x,y,'--g')
hold off;
axis([4 8 1 5]);



