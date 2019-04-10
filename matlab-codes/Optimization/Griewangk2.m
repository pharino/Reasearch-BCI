function [ z ] = Griewangk2( x,y )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
z = (x^2+y^2)/400 - cos(x)*cos(y/2) + 1;

end

