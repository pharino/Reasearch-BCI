function [ output_args ] = DrawElectrode(clab,ElectrodeSelect,color)

DrawElectrode.clabSize  = size(clab);
for i = 2:DrawElectrode.clabSize(1)
    DrawElectrode.X(i-1) = clab{i,2};
    DrawElectrode.Y(i-1) = clab{i,3};
end

%   Making circle for head shape
set(gcf,'Position',[1750 -50 900 850],...
    'Color',[1 1 1]);

DrawElectrode.Circle.R      = 0.5;
DrawCircle(0,0,DrawElectrode.Circle.R,'k','LineWidth',2.0);
hold on;
axis([-0.6 0.6 -0.6 0.6]);

plot(DrawElectrode.X,DrawElectrode.Y,'.k');
xlabel('X axes position ');
ylabel('Y axes position');

%   Draw only electrode position 
if nargin == 1
    plot(DrawElectrode.X(i-1),...
        DrawElectrode.Y(i-1),...
        '.k',...
        'MarkerSize',10);
    
%   Draw Electrode and selected electrode
else
    ElectrodeSelect         = ElectrodeSelect +1;
    for i = 2:DrawElectrode.clabSize(1)
        %   It is not selected electrodes
        if isempty(find(ElectrodeSelect == i))
            plot(DrawElectrode.X(i-1),...
                DrawElectrode.Y(i-1),...
                'ok',...
                'MarkerSize',20);
            
        %   Marker color for selected electrodes 
        else
            plot(DrawElectrode.X(i-1),...
                DrawElectrode.Y(i-1),...
                'ok',...
                'MarkerSize',20,...
                'MarkerFaceColor',color);
        end
        
        %   Draw point marker
        plot(DrawElectrode.X(i-1),...
            DrawElectrode.Y(i-1),...
            '.k',...
            'MarkerSize',10);
    end
end

%   Draw electrode label
for i = 2:DrawElectrode.clabSize(1)
    DrawElectrode.Channel = clab{i,1};
    text(DrawElectrode.X(i-1),...
        DrawElectrode.Y(i-1)+0.01,...
        DrawElectrode.Channel,...
        'FontSize',8);
    text(DrawElectrode.X(i-1),...
        DrawElectrode.Y(i-1)-0.01,...
        num2str(i-1),...
        'FontSize',8);
end

%   Create text at front position
text(0,0.55,'Front','FontSize',12);

end

