function [ information ] = getEEG_info( eeg_mrk,eeg_nfo,eeg_source)
%%  Function description
%   function [ eeg_info ] = acguisition_info( mrk,nfo,dataset_source)UNTITLED Summary of this function goes here
%   Input:
%       - eeg_mrk:  Structure of marker of EEG dataset
%       - eeg_nfo:  Structure of information of EEG dataset
%       - eeg_source:   String identidy dataset source

if strcmp(eeg_source,'BCI3')||strcmp(eeg_source,'BCI4')
    %%  Update clab xpos and ypos --> [3 X #clab], 1-clab name, 2-xpos, 3-ypos
    %       Find max value, if greater than 0.5, we normalized distance to[-0.5 0.5]
    value_max = max(eeg_nfo.xpos);
    if value_max > 0.5
        ratio = 0.5;
    else
        ratio = 1;
    end
    for i = 1:length(eeg_nfo.clab)
        information.active_channels(i,:) = i;
    end
    for i = 1:length(eeg_nfo.clab)+1
        if i == 1
            information.clab{i,1}   = {'Channel'};
            information.clab{i,2}   = {'X'};    % Update x vector position
            information.clab{i,3}   = {'Y'};    % Update y vector position
        else
            information.clab{i,1}   = eeg_nfo.clab{i-1};
            information.clab{i,2}   = ratio*eeg_nfo.xpos(i-1);  % Update x vector position
            information.clab{i,3}   = ratio*eeg_nfo.ypos(i-1);  % Update y vector position
        end
    end
    %% Output class information
    information.fs              = eeg_nfo.fs;           % Sampling frequency
    information.marker_sample   = eeg_mrk.pos';
    information.class_output    = eeg_mrk.y';
    if strcmp(eeg_source,'BCI3')                % BCI competition 3
        if isfield(eeg_mrk, 'className')
            information.class  = eeg_mrk.className;
        else
            information.class   = [];
        end
    else                                            % BCI competition 4
        information.class       = eeg_nfo.classes;
    end
    class_label                 = unique(eeg_mrk.y,'sorted');
    for i = 1:length(class_label)
        class_found_number      = 0;
        for k = 1:length(eeg_mrk.y)
            if eeg_mrk.y(k) == class_label(i)
                class_found_number = class_found_number + 1;
                information.class_trial{class_found_number,i} = k;
            end
        end
        information.class{2,i}  = class_found_number;
    end
elseif strcmp(eeg_source,'URIS')                    % URIS dataset
    value_max = max(eeg_nfo.xpos);
    if value_max > 0.5
        ratio = 0.5;
    else
        ratio = 1;
    end
    for i = 1:length(eeg_nfo.clab)
        if i == 1
            information.clab{i,1}   = {'Channel'};
            information.clab{i,2}   = {'X'};  % Update x vector position
            information.clab{i,3}   = {'Y'};  % Update y vector position
        else
            information.clab{i,1}   = eeg_nfo.clab{i-1};
            information.clab{i,2}   = ratio*eeg_nfo.xpos(i-1);  % Update x vector position
            information.clab{i,3}   = ratio*eeg_nfo.ypos(i-1);  % Update y vector position
        end
    end
    %% Output class information
    information.fs              = eeg_nfo.fs;           % Sampling frequency
    information.marker_sample   = eeg_mrk.pos;
    information.class_output    = eeg_mrk.y;
    information.class           = eeg_nfo.classes;
    class_label                 = unique(eeg_mrk.y,'sorted');
    for i = 1:length(class_label)
        class_found_number      = 0;
        for k = 1:length(eeg_mrk.y)
            if eeg_mrk.y(k) == class_label(i)
                class_found_number = class_found_number + 1;
                information.class_trial{class_found_number,i} = k;
            end
        end
        information.class{2,i}  = class_found_number;
    end
end

end

