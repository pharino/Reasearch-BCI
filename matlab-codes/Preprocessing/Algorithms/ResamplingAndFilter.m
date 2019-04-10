function [ output_args ] = ResamplingAndFilter( varargin )
%%  ResamplingAndFilter( varargin ): Resampling the input signal and

%   Output: ['WindowFunction',value1,'WindowParameters',value2,'SamplingFrequency', value3,
%       'RatioOrder',value4,'PassBand',value5,'FIR1', value6,'P',value7,'Q',value8,'DataOutput',value9]
%       - value1: string name of window function
%       - value2: window function parameter beside the Length of window(optinal)
%       - value3: 1 by 2 vector: (1) current sampling frequency, (2)
%       desired sampling frequency
%       - value4: integer ration between window sample and P value
%       - value5: 1 by 2 vector of bandpass frequency in Hz
%       - value6: coefficeint for FIR filter, to use it, apply convolution
%       to the input signal
%       - value7: integer for upsampling frequency
%       - value8: integer for downsampling frequency
%       - value9: output data


%   Input: ['WindowFunction',value1,'WindowParameters',value2,'SamplingFrequency', value3,
%       'RatioOrder',value4,'PassBand',value5,'DataInput',value6]
%       - value1: string name of window function
%       - value2: window function parameter beside the Length of window(optinal)
%       - value3: 1 by 2 vector: (1) current sampling frequency, (2)
%       desired sampling frequency
%       - value4: integer ration between window sample and P value
%       - value5: 1 by 2 vector of bandpass frequency in Hz
%       - value6: input data for resampling and filter, the input is a vector

%% --------------------------------------------------------------------- %%
%                               Find filter coefficients
%   Send error message if the inputs is insuffcient
if nargin < 10 || (isempty(find(strcmp(varargin,'WindowFunction')))) || isempty(find(strcmp(varargin,'SamplingFrequency'))) || ...
        isempty(find(strcmp(varargin,'RatioOrder'))) || isempty(find(strcmp(varargin,'PassBand')))|| isempty(find(strcmp(varargin,'DataInput')))
    error('myApp:argChk', 'Input arguments are not enough.');
else
    wfh     = str2func(varargin{find(strcmp(varargin,'WindowFunction')) +1 });
    spfreq  = varargin{find(strcmp(varargin,'SamplingFrequency')) +1 };
    r       = varargin{find(strcmp(varargin,'RatioOrder')) +1 };
    fp      = varargin{find(strcmp(varargin,'PassBand')) +1 };
    %   Least common multiplier of sampling frequency
    m       = lcm(spfreq(1),spfreq(2));
    %   Ratio between Least common multiplier of sampling frequency and current sampling frequency
    p       = m/spfreq(1);
    %   Ratio between Least common multiplier of sampling frequency and current sampling frequency
    q       = m/spfreq(2);
    %   Window length
    L       = p*r;
    %   Normalized passband
    wp      = fp/(m/2);
    %   Create window coefficients
    if isempty(find(strcmp(varargin,'WindowParameters')))
        wfc = window(wfh,L);
    else
        wfpar   = str2func(varargin{find(strcmp(varargin,'WindowParameters')) +1 });
        i   = length(wfpar);
        switch i
            case 1
                wfc     = window(wfh,L,wfpar(1));
            case 2
                wfc     = window(wfh,L,wfpar(1),wfpar(2));
        end
    end
    %   Filter coefficients
    h       = fir1(L-1,wp,wfc);
    %% --------------------------------------------------------------------- %%
    %   Find data need to processing
    index   = find(strcmp(varargin,'DataInput'));
    data_input = varargin{ index +1 };
    %   Empty clear input arguments before find the coefficient for
    %   filtering
    varargin{index +1 } = [];
    
    
    %   Create plot view
    [mag freq]     = freqz(h,1,10*(L-1),m); % insert input length of 10 time of window
    [phi freq]     = phasez(h,1,10*(L-1),m);
    hdB     = 20*log(abs(mag));
    %   Plot magnitude response of filter
    fig_filter     = figure;
    subplot(2,1,1);
    plot(freq,hdB,'LineWidth',1.5);
    xlim([ 0,100]);
    grid on;
    xlabel('Frequency(0-100Hz)');
    ylabel('Amplitude(dB)');
    title('Amplitude response of bandpass filter');
    %   Plot phase response of filter
    subplot(2,1,2);
    plot(freq,phi,'LineWidth',1.5);
    xlim([0 100]);
    ylim([-180 180]);
    grid on;
    xlabel('Frequency(0-100Hz)');
    ylabel('Phase(degree)');
    title('Phase response of bandpass filter');
    
    %----------------------------------------------------------------------
    %   Create output
    output_args = varargin;
    output_args{length(output_args) +1} = 'P';
    output_args{length(output_args) +1} = p;
    output_args{length(output_args) +1} = 'Q';
    output_args{length(output_args) +1} = q;
    output_args{length(output_args) +1} = 'FIR1';
    output_args{length(output_args) +1} = h;
    
end
end

