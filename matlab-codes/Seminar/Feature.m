%% -------------------------------------------------------------------------
clear;
load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Preprocessing data\Preprocessing V2\BCICIV_Dataset_I_a.mat');
Signal = Signal.^2; 

for i = 1:4
    X   = Signal(:,:,:,(1+100*(i-1)):(100*i));
    B(:,:,:,i)   = mean(X,4);
end

C   = B(:,:,:,2);

A   = C(:,[27 29 31],:);
A1  = A(:,:,1);
A2  = A(:,:,2);
A3  = A(:,:,3);

%%  Alpha band
figure;
N1 = 0;
N2 = 0;
for i = 1:length(Information.class_output)
    if Information.class_output(i)==1
        N1 = N1 + 1;
        C1(N1+1,:) = A1(i,:);      
    else
        N2 = N2 + 1;
        C2(N2+1,:) = A1(i,:); 
    end
end
scatter3(C1(:,1),C1(:,2),C1(:,3),'+k')
hold on;
scatter3(C2(:,1),C2(:,2),C2(:,3),'*r')
hold off;

title('\alpha band power');
xlabel('C{_3} band power');
ylabel('C{_z} band power');
zlabel('C{-4} band power');


%%  Beta band
figure;
N1 = 0;
N2 = 0;
for i = 1:length(Information.class_output)
    if Information.class_output(i)==1
        N1 = N1 + 1;
        C1(N1+1,:) = A2(i,:);      
    else
        N2 = N2 + 1;
        C2(N2+1,:) = A2(i,:); 
    end
end
scatter3(C1(:,1),C1(:,2),C1(:,3),'+k')
hold on;
scatter3(C2(:,1),C2(:,2),C2(:,3),'*r')
hold off;

title('\beta band power');
xlabel('C{_3} band power');
ylabel('C{_z} band power');
zlabel('C{-4} band power');

%%  Broad band
figure;
N1 = 0;
N2 = 0;
for i = 1:length(Information.class_output)
    if Information.class_output(i)==1
        N1 = N1 + 1;
        C1(N1+1,:) = A2(i,:);      
    else
        N2 = N2 + 1;
        C2(N2+1,:) = A2(i,:); 
    end
end
scatter3(C1(:,1),C1(:,2),C1(:,3),'+k')
hold on;
scatter3(C2(:,1),C2(:,2),C2(:,3),'*r')
hold off;

title('Broad band power');
xlabel('C{_3} band power');
ylabel('C{_z} band power');
zlabel('C{-4} band power');


%%
figure;
for i = 1:length(Information.class_output)
    hold on;
    if Information.class_output(i)==1
        plot3(A1(i),A2(i),A3(i),'+k');        
    else
        plot3(A1(i),A2(i),A3(i),'*r');
    end
    hold off;
end
view([-30, 30])
xlabel('\alpha band power')
ylabel('\beta band power')
zlabel('broad band')
