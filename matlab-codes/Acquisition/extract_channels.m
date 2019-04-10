function [eeg_out_matrix,information]= extract_channels( eeg_matrix,mrk,nfo,dataset_source )
%%  function 'chextract( dataset,data_source )'
%   ch_nameannel_extract( data,data_source )
%       input:
%           - eeg_matrix: [m X n], m is number of sample, n is number of
%           electrode
%           - data_source: string select type of data source('BCI3'/'BCI4'/'URIS')
%       Output:

if strcmp(dataset_source,'BCI3')||strcmp(dataset_source,'BCI4')
    %%  Update clab xpos and ypos --> [3 X #clab], 1-clab name, 2-xpos, 3-ypos
    %       Find max value, if greater than 0.5, we normalized distance to[-0.5 0.5]
    value_max = max(nfo.xpos);
    if value_max > 0.5
        ratio = 0.5;
    else
        ratio = 1;
    end
    for i = 1:length(nfo.clab)
        information.clab{1,i}   = nfo.clab{i};
        information.clab{2,i}   = ratio*nfo.xpos(i);  % Update x vector position
        information.clab{3,i}   = ratio*nfo.ypos(i);  % Update y vector position
    end
    %% Output class information
    information.fs              = nfo.fs;           % Sampling frequency
    information.marker_sample   = mrk.pos;
    information.class_output    = mrk.y;
    if strcmp(dataset_source,'BCI3')                % BCI competition 3
        information.class       = mrk.className;
    else                                            % BCI competition 4
        information.class       = nfo.classes;
    end
    class_label                 = unique(mrk.y,'sorted');
    for i = 1:length(class_label)
        class_found_number      = 0;
        for k = 1:length(mrk.y)
            if mrk.y(k) == class_label(i)
                class_found_number = class_found_number + 1;
                information.class_trial{class_found_number,i} = k;
            end
        end
        information.class{2,i}  = class_found_number;
    end
    eeg_out_matrix              = 0.1*double(eeg_matrix);
elseif strcmp(dataset_source,'URIS')                    % URIS dataset
    value_max = max(nfo.xpos);
    if value_max > 0.5
        ratio = 0.5;
    else
        ratio = 1;
    end
    for i = 1:length(nfo.clab)
        information.clab{1,i}   = nfo.clab{i};
        information.clab{2,i}   = ratio*nfo.xpos(i);  % Update x vector position
        information.clab{3,i}   = ratio*nfo.ypos(i);  % Update y vector position
    end
    %% Output class information
    information.fs              = nfo.fs;           % Sampling frequency
    information.marker_sample   = mrk.pos;
    information.class_output    = mrk.y;
    information.class       = nfo.classes;    
    class_label                 = unique(mrk.y,'sorted');
    for i = 1:length(class_label)
        class_found_number      = 0;
        for k = 1:length(mrk.y)
            if mrk.y(k) == class_label(i)
                class_found_number = class_found_number + 1;
                information.class_trial{class_found_number,i} = k;
            end
        end
        information.class{2,i}  = class_found_number;
    end
    eeg_out_matrix              = eeg_matrix;
end
end


