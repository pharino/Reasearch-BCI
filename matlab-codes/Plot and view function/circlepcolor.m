function circlepcolor(X,Y,Z,type)
% This is experimental software released in public domain but without any
% warranty.
% I am not responsible for any use you can do with this sotware.
%
% Davide Reato, 2009
%
%
% "Circle Pcolor"
%
% syntax:
% circlepcolor(X,Y,Z,colormap)
% where X (length = m) and Y (length = n) are vectors, Z is a matrix (size = m x n) 
% and colormap can be: 'jet', 'hot', 'therminv'
%
% Simple function to convert a "pcolor" plot in a 2d plot
% with circles. The color of the circles is defined by its value.
% The program reproduce the same results than an pcolor but using
% circles instead of squares
%
% This very simple simple program is free and you can do whatever you want
% with it

close all;

disp(['This is experimental software released in public domain but without any warranty. ',...
        'I am not responsible for any use you can do with this software',...
        ' - Davide Reato, 2009 -']);

if type == 'jet'
    % Jet colormap definition
    % -----
    b = zeros(64,1);                % blue color
    g = zeros(64,1);                % green color
    r = zeros(64,1);                % red color

    b(1:8) = 0.5+1/16:1/16:1;
    b(9:24) = 1;
    b(24:39) = 1:-1/16:0+1/16;

    g(1:8) = 0;
    g(9:24) = 0+1/16:1/16:1;
    g(25:40) = 1;
    g(41:56) = 1-1/16:-1/16:0;

    r(1:24) = 0;
    r(25:40) = 0+1/16:1/16:1;
    r(41:56) = 1;
    r(57:64) = 1:-1/16:0.5+1/16;
    % -----
elseif type == 'hot'
    % Hot colormap definition
    % -----
    b = zeros(64,1);                % blue color
    g = zeros(64,1);                % green color
    r = zeros(64,1);                % red color

    r(1:24) = 1/24:1/24:1;
    r(24:64) = 1;

    g(25:48) = 1/24:1/24:1;
    g(49:64) = 1;

    b(49:64) = 1/16:1/16:1;
    % -----
elseif type == 'therminv'
    % Inverse thermal colormap definition
    % -----
    map = [0 0 0; 0.3 0 0; 1 0.2 0; 1 1 0; 1 1 1];
    rp = map(:,1);
    gp = map(:,2);
    bp = map(:,3);

    xi = 1:0.05:5;
    r = interp1(rp,xi);
    g = interp1(gp,xi);
    b = interp1(bp,xi);

    r = fliplr(r);
    g = fliplr(g);
    b = fliplr(b);
    % -----
end

figure(1);

% scaling of the values and re-mapping
Zplot = Z-min(min(Z));
step = max(max(Zplot))-min(min(Zplot));
Zplot = Zplot./(step);
Zplot = round(Zplot*length(r));
Zplot(find(Zplot == 0)) = 1;    % the first value must be 1, not zero

for i = 1:length(X)
    for j = 1:length(Y)
        plot(X(i),Y(j),'.','Color',[r(Zplot(j,i)) g(Zplot(j,i)) b(Zplot(j,i))],'MarkerSize',30);hold on;
    end
end
axis equal;
axis off;

% the following part simply set in the right way the scale of the
% corresponding colorbar
Zmax = max(max(Z));
Zmin = min(min(Z));
stepcol = (Zmax-Zmin)/7;
colormap([r g b]);
colorbar('Location','EastOutside','YTickLabel',...
    {num2str(Zmin),num2str(Zmin+stepcol),num2str(Zmin+2*stepcol),num2str(Zmin+3*stepcol),num2str(Zmin+4*stepcol),num2str(Zmin+5*stepcol),num2str(Zmin+6*stepcol),num2str(Zmax)})
caxis([0 35])