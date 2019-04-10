function [output_args] = spatial_filtering( varargin )
%%  Spatial filter function
%   Input: varargin
%   For Commmon Spatial Filter
%   For Common Average Filter
%       Input:
%           - ['Filter','CAR','EEG',value1]
%               - value 1: EEG matrix
%   For Laplacian Filter
%       Input:
%           - ['Filter','Laplacian','Type',value1,'Neighbor',value2,'Clab',value3,'EEG',value3]
%               - value 1: 'Large' or 'Small', if not specify 'Large' is
%               deafault
%               - value 2: Integer usually 4or 8, if not specify 'Large' is
%               4 is deafault
%               - value 3: Matrix contain cartestain coordonate of electrodes position
%               - value 4: EEG matrix
%%   Catch errors
if isempty(strcmp(varargin,'Filter'))
    error('myApp:argChk', 'Filter type is not specified(CSP,CAR,Laplacian)');
elseif isempty(strcmp(varargin,'EEG'))
    error('myApp:argChk', 'EEG matrix does not import');
else
    mode    = varargin{find(strcmp(varargin,'Filter')) + 1 };
    if strcmp(mode,'CSP')
        
    elseif strcmp(mode,'CAR')
        matrix_output    = spf_car(varargin{find(strcmp(varargin,'EEG')) + 1});
    elseif strcmp(mode,'Laplacian')
        %%   Catch inputs
        if isempty(strcmp(varargin,'Clab')) || isempty(strcmp(varargin,'EEG'))
            error('myApp:argChk', 'There is no input field "Clab" or "EEG"');
        else
            %%  Create deafault inputs paramters
            %       Define type of Laplacian filter
            if isempty(strcmp(varargin,'Type'))
                type                = 'Large';
            else
                type                = varargin{find(strcmp(varargin,'Type')) + 1};
            end
            %       Define number of surrounded neighbor electrode
            if isempty(strcmp(varargin,'Neighbor'))
                number_neighbor     = 4;
            else
                number_neighbor     = varargin{find(strcmp(varargin,'Neighbor')) + 1};
            end
            %       EEG matrix
            eeg_matrix_input        = varargin{find(strcmp(varargin,'EEG')) + 1};
            %       Clab matrix
            clab_matrix             = varargin{find(strcmp(varargin,'Clab')) + 1};
            matrix_output           = spf_laplacian(type,number_neighbor, clab_matrix,eeg_matrix_input);
        end
    end
    %   Copy content of input argument
    varargin{find(strcmp(varargin,'EEG')) + 1} = [];
    output_args = varargin;
    output_args{find(strcmp(output_args,'EEG')) + 1} = matrix_output;
end
end

