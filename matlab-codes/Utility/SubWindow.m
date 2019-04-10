function [ SignalSegment ] = SubWindow(Time, WindowLength, WindowDelay,Signal)

if nargin ~= 4
    error('myApp:argChk', 'Wrong number of input arguments');
end

SubWindow.Length        = max(Time) - min(Time);
SubWindow.SegmentNumber = floor((SubWindow.Length - WindowLength)/WindowDelay) + 1;
SubWindow.Step(1)       = floor(WindowDelay/(Time(2) - Time(1)));
SubWindow.Step(2)       = floor(WindowLength/(Time(2) - Time(1)));

for N = 1:SubWindow.SegmentNumber
    
    %   Find lower and upper index for each segment
    SubWindow.LowerIndex    = 1 + (N-1)*SubWindow.Step(1);
    SubWindow.UpperIndex    = SubWindow.LowerIndex + SubWindow.Step(2);
    
    %   Cut the signal
    if isvector(Signal)
        
        SignalSegment(N,:)      = Signal(SubWindow.LowerIndex:SubWindow.UpperIndex);  
        
    elseif ismatrix(Signal)
        
        SignalSegment(:,N,:)    = Signal(:,SubWindow.LowerIndex:SubWindow.UpperIndex);
        
    end
end
end

