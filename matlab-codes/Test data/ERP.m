%%
clear;
load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Preprocessing data\Preprocessing V2\BCICIV_Dataset_I_g.mat');

%%
N1  = 0;
N2  = 0;
for i = 1:length(Information.class_output)
    if Information.class_output(i) == 1
        N1 = N1 + 1;
        CTrial(N1,1) = i;
    else
        N2 = N2 + 1;
        CTrial(N2,2) = i;
    end
end

%%

C1 = Signal(CTrial(:,1),...
    [27,29,31],:,:);
C11{1} = C1;
C11{1} = C11{1}./(max(max(max(max(C11{1})))) - min(min(min(min(C11{1})))));
C11{2} = C1.^2;
C11{2} = C11{2}./(max(max(max(max(C11{2})))) - min(min(min(min(C11{2})))));
C11{3} = C1.^3;
C11{1} = C11{1}./(max(max(max(max(C11{3})))) - min(min(min(min(C11{3})))));
C11{4} = C1.^4;
C11{1} = C11{1}./(max(max(max(max(C11{4})))) - min(min(min(min(C11{4})))));
C11{5} = C1.^5;
C11{1} = C11{1}./(max(max(max(max(C11{5})))) - min(min(min(min(C11{5})))));
C111   = C11{1} + C11{2} + C11{3} + C11{4} + C11{5};
C111   = mean(C111,1);


C2 = Signal(CTrial(:,2),...
    [27,29,31],:,:);
C21{1} = abs(C2);
C21{1} = C21{1}./(max(max(max(max(C21{1})))) - min(min(min(min(C21{1})))));
C21{2} = abs(C2.^2);
C21{2} = C21{2}./(max(max(max(max(C21{2})))) - min(min(min(min(C21{2})))));
C21{3} = abs(C2.^3);
C21{1} = C21{1}./(max(max(max(max(C21{3})))) - min(min(min(min(C21{3})))));
C21{4} = abs(C2.^4);
C21{1} = C21{1}./(max(max(max(max(C21{4})))) - min(min(min(min(C21{4})))));
C21{5} = abs(C2.^5);
C21{1} = C21{1}./(max(max(max(max(C21{5})))) - min(min(min(min(C21{5})))));
C211   = C21{1} + C21{2} + C21{3} + C21{4} + C21{5};
C211   = mean(C211,1);


%%
figure;
for i = 1:3
    %   Class 1
    X  = C111(:,1,i,:);
    X = X(:);
    
    subplot(2,3,i);
    plot(Information.TimeSample.Sample,X);
    xlabel('Time[s]');
    ylabel('Signal amplitute');
    
    % Class 2
    X  = C211(:,1,i ,:);
    X = X(:);
    
    subplot(2,3,3+i);
    plot(Information.TimeSample.Sample,X);
    xlabel('Time[s]');
    ylabel('Signal amplitute');
    
end

