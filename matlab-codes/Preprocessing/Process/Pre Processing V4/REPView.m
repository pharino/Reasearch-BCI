%% ERP
class = unique(Information.class_output);

for c = 1:length(class)
    class_logic = Information.class_output == class(c);
    class_logic = class_logic(:);
    average(:,:,:,c) = mean(Signal(:,:,:,class_logic),4);
    
end

time = linspace(-1,4,Information.SignalSize(1));

% C3
display('Channel C3');
for i= 1:4
    figure(i)
    for c = 1:length(class)
        colormap(gray);
        subplot(3,1,c);
        plot(time,average(:,26,i,c),'k');
        title(Information.class_label{c});
    end
end

% Cz
display('Channel Cz');
for i= 1:4
    figure(i + 4)
    for c = 1:length(class)
        colormap(gray);
        subplot(3,1,c);
        plot(time,average(:,28,i,c),'k');
        title(Information.class_label{c});
    end
end

% C4
display('Channel C4');
for i= 1:4
    figure(i+8)
    for c = 1:length(class)
        colormap(gray);
        subplot(3,1,c);
        plot(time,average(:,30,i,c),'k');
        title(Information.class_label{c});
    end
end


%%
close all;
for c = 1:length(class)
    class_logic = Information.class_output == class(c);
    class_logic = class_logic(:);
    temp = Signal(:,:,:,class_logic);
    d = size(temp);
    for b = 1:4
        for i = 1:d(4)
            temp2(:,:,i) = temp(:,:,b,i)'*temp(:,:,b,i);
        end
        covariance(:,:,b,c) = mean(temp2,3);
        clear temp2;
    end
    clear temp;
end

for c = 1:3
    figure(c);
    for i = 1:4
        colormap(gray)
        subplot(2,2,i);
        surf(covariance(:,:,i,c)); 
        axis([1,62,1,62]);
        view(0,90);        
    end
end

