function [ eeg_matrix_output ] = spf_laplacian(type,number_neighbor, clab_matrix,eeg_matrix_input)
%%  spf_laplacian(eeg_matrix,eeg_info,k)
%
%   Input: varargin
%       'Type',     value: 'Large'/ 'Small'
%       'Neighbor', value: Integer,typically 4 or 8
%       'Clab',     value: Matrix of cartestain coordonate of electrodes
%       position
%       'EEG',      value: Matrix of EEG signal   
    %   Layer level of Laplacian filter
    if strcmp(type,'Small')
        ly = 0;
    elseif strcmp(type,'Large')
        ly = 1;
    end    
    %   Find the nearest index and distance matrix
    [euclidean_distance index_nearest] = find_nearest(clab_matrix);
    %  Laplace filter
    for id = 1:length(index_nearest)
        %   Center electrode EEG signal
        eeg_center      = eeg_matrix_input(id,:);
        %   Index of its neighbor electrode
        index_neighbor  = index_nearest((2*ly*number_neighbor+2):(number_neighbor*(2*ly+1)+1),id);
        %   Extract neighbor EEG signals and distance
        for k = 1:number_neighbor
            eeg_neighbor(k,:)       = eeg_matrix_input(index_neighbor(k),:);
            distance_neighbor(k)    = euclidean_distance(index_neighbor(k),id);
        end
        %   Caculate weight
        weight_neighbor = (1./distance_neighbor)/(sum((1./distance_neighbor)));
        %   Multiply neighbors with it weight
        for k = 1:number_neighbor
            eeg_neighbor(k,:)       = weight_neighbor(k).*eeg_neighbor(k,:);
        end
        %   substract center EEG signal with sum of it neighbors
        eeg_matrix_output(id,:)      =   eeg_center - sum(eeg_neighbor,1);
    end
%   -----------------------------------------------------------------------
%%                              Utility functions
%   -----------------------------------------------------------------------
%%  Find the nearest electrode according to euclidian distance
    function [euclidean_distance index_nearest] = find_nearest(clab_matrix )
        %   eeg_electrode_distance(clab_matrix )
        %   Input:  clab_matrix [n X 3] matrix, 1 clab name, 2 x-postion, 3 y-position
        %   Output: matrix_distance[n X n], column is center electrodes
        
        clab_size = size(clab_matrix);
        %   Clab matrix is in row form, convert to column from
        if find(clab_size == min(clab_size)) == 1
            clab_matrix     = clab_matrix';
        end
        %   Reset clab matrix dimension
        clab_size = size(clab_matrix);
        %   Clab matrix: Channel,X,Y
        if min(clab_size) == 3
            %  Coordonate  matrix of clab
            for i = 2:clab_size(1)
                xyz(i-1,1) = clab_matrix{i,2};
                xyz(i-1,2) = clab_matrix{i,3};
            end
            %   Clab matrix: Channel,X,Y,Z
        elseif min(clab_size) == 4
            %  Coordonate  matrix of clab
            for i = 2:clab_size(1)
                xyz(i-1,1) = clab_matrix{i,2};
                xyz(i-1,2) = clab_matrix{i,3};
                xyz(i-1,3) = clab_matrix{i,4};
            end
        end
        
        %  Calculate the distance matrix
        n   = length(xyz);
        for i = 1:n
            %   Current handels electrode
            electrode_center = xyz(i,:);
            for j = 1:n
                %   Current near by handles electrode
                electrode_next  = xyz(j,:);
                %   Euclidean distance
                euclidean_distance(j,i) = distance(electrode_center,electrode_next);
            end
            %   Sort each column increasing
            [distance_nearest(:,i) index_nearest(:,i)] = sortrows(euclidean_distance(:,i));
        end
    end
%   -----------------------------------------------------------------------
end
