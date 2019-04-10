function [ y] = erd_ers(x,r,k,label,plot_option)
%%  Function
%   [ y] = erd(x,k,label,plot_option)
%   erd_ers: compute the event-related desynchronization(
%   decreasing potential) event-related synchronization(increasing
%   potential) of bio-signal of different label patterns.
%%  Input:
%   -   x : signal matrix where column is time sample, row is trial of
%   signal.
%   -   r : starting reference sample
%   -   k : number of sample in the referene time after the reference
%   sample r. The rerefence  sample start from [r, r+k]. Usally it is 1s
%   second before the external stimuli was givent to subject.
%   -   label : vector of label pattern of signal. Its must have the same
%   dimension as row of x.
%   plot_option : logical variable for plotting graphic. If it is true,
%   then a figure of signal in different  classes pattern will be plot
%   after function return. Else there is no graphical output.
%%  Output:
%   -   y : matrix of ERD/ERS vectors. Column is time sample  with
%   dimension as x. Row is class pattern with dimension as different
%   labels.


%%  Code
erd_ers.dimension = size(x);
if length(label) ~= erd_ers.dimension(1);
    error('Data input and class label dimension missed match');
end

% Find number of class pattern
erd_ers.class = unique(label);

% With different class pattern, calculate
for i = 1:length(erd_ers.class)
    
    % find class index in label vector
    temp    = label == erd_ers.class(i);
    % number trial with the same class pattern
    N       = sum(temp);
    % Averaging class sample
    erd_ers.xbar = mean(x(temp,:),1);
    % Time sample variance
    erd_ers.y = (x(temp,:) - repmat(erd_ers.xbar,N,1)).^2;
    % Average time sample varaince over the same trails pattern
    erd_ers.A = sum(erd_ers.y,1)./(1-N);
    % Find the reference average power;
    erd_ers.R = sum(erd_ers.A(r:r+k))./k;
    
    % The final ERD/ERS potential
    erd_ers.p = ((erd_ers.A - repmat(erd_ers.R,size(erd_ers.A)))./(erd_ers.R)).*100;
    
    % Output ERD/ERS to matrix output y
    y(i,:)    = erd_ers.p;
    name{i} = strcat('Class <',num2str(i),'>' );
end
if plot_option    
    plot(y');
    axis([1,length(y), min(min(y)), max(max(y))]);
    legend(name);
end

end

