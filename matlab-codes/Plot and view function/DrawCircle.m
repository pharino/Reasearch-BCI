function [ output_args ] = DrawCircle(x,y,r,varargin)
%%  Description
%   DrawCircle(x,y,r,linestyle): draw a circle at coordonate (x,y) with
%   radius r

DrawCircle.Circle.Alpha  = 0:.01:2*pi;
DrawCircle.Circle.R      = r; 
DrawCircle.Circle.X = x + DrawCircle.Circle.R*cos(DrawCircle.Circle.Alpha);
DrawCircle.Circle.Y = y + DrawCircle.Circle.R*sin(DrawCircle.Circle.Alpha);
%   Drawing circle
gca;
switch length(varargin)
    case 1
        plot(DrawCircle.Circle.X,DrawCircle.Circle.Y,varargin{1});
    case 2
        plot(DrawCircle.Circle.X,DrawCircle.Circle.Y,varargin{1},varargin{2});
    case 3
        plot(DrawCircle.Circle.X,DrawCircle.Circle.Y,varargin{1},varargin{2},varargin{3});
end


end

