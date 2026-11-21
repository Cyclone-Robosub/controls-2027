classdef TimePlot
    %{
    Class used by plotTimePlot and setupPlots to create high quality plots
    with a large amount of code reuse.
    %}
    properties
        %set by constructor
        name %1x1 string
        fields %1xN string
        timeseries = {} %1xN timeseries corresponding with each field
        signals = [] %1xM array of data vectors from the M fields
        t = [] %1xM array of time vectors from the M fields
        layout %1x2 double specifing the layout of K subplots
        signal_map %a 1xK cell array where each cell contains the 1x(up to)M double of indices of the timeseries to be included
        subtitles %1xK string with an entry for each subtitle, "" for no subtitle
        supertitle %1x1 string supertitle, "" for no supertitle
        h_labels %either a 1x1 string or a 1xK string, specifying one h_label for all subplots or a different h_label for each subplot
        v_labels %1xK string of vertical axis labels for each subplot
        legends %a cell array of the same dimension as the signal_map containing a 1x(up to)M string of legend labels for each subplot
        is_plottable = true %boolean, true if the plot can be generated, false otherwise
    end

    methods
        function obj = TimePlot(name, fields, layout, signal_map, v_labels, h_labels, subtitles, supertitle, legends)
            %constructor assigns class members and validates input
            obj.name = name;
            obj.fields = fields;
            obj.layout = layout;
            obj.signal_map = signal_map;
            obj.v_labels = v_labels;
            obj.h_labels = h_labels;
            obj.subtitles = subtitles;
            obj.supertitle = supertitle;
            obj.legends = legends;
            %todo: Input validation
        end

        function obj = loadData(obj,results)
            %disp("loadData")
            %try
                counters = [0;0;0;0]; %1-missing field counter, 2-signal counter, 3-pattern count, 4-pattern prediction
                for k = 1:length(obj.fields) %unpack the timeseries from the results structure
                    if(ismember(obj.fields(k),results.who))
                        obj.timeseries{end+1} = results.(obj.fields(k));
                        %disp(obj.fields(k))
                        %disp(k)
                    else
                        warning("Field %s failed to load.", obj.fields(k))
                        %obj.timeseries{end+1} = "missing_field";
                        if(~exist("missed_field_index")&&~exist("cont_misf"))
                            missed_field_index=0;
                        end
                        counters(1) = counters(1) +1;
                        missed_field_index(counters(1)) = k;
                    end
                end
                
                for k = 1:length(obj.timeseries) %unpack the time and signals from the timeseries
                    signals_k = squeeze(obj.timeseries{k}.Data);
                    signals_k = enforceTallSkinny(signals_k);
                    t_k = obj.timeseries{k}.Time;
                    [~,cols] = size(signals_k);
                    for j = 1:cols 
                        counters(2) = counters(2) +1;
                        s_from_f(counters(2)) =  k;
                        obj.signals(:,end+1) = signals_k(:,j); 
                        obj.t(:,end+1) = t_k; %add t for each signal
                    end
                end
                %disp(s_from_f)

                if exist("missed_field_index")
                    signal_map_size = 0;
                    for i = 1:length(obj.signal_map)
                        signal_map_size = signal_map_size + length(obj.signal_map{i});
                        for j = 1:length(obj.signal_map{i}) - 1
                            counters(3) = counters(3) + 1;
                            pattern(counters(3)) = -obj.signal_map{i}(j)+obj.signal_map{i}(j+1);
                        end
                    end

                    for i = length(obj.signal_map)
                        signal_map_size = signal_map_size + length(obj.signal_map{i});
                        for j = 1:length(obj.signal_map{i})-1
                            pattern(i+j-1) = -obj.signal_map{i}(j)+obj.signal_map{i}(j+1);
                        end
                    end
                    %disp(pattern)
                    pattern = mode(pattern);
                    num_missing_signals = signal_map_size - length(obj.signals);
                    predicted_signal_map = zeros(signal_map_size,1);
                    for i = 1:length(obj.signal_map)
                        for j = i:length(obj.signal_map{i})+i-1
                            counters(4) = counters(4) +1;
                            predicted_signal_map(counters(4)) = i+(j-1)*pattern;
                        end
                    end
                    disp(pattern)
                    disp(length(obj.signal_map))
                    disp(predicted_signal_map)
                    for i = 1:num_missing_signals
                        %pattern will determine where we need to take
                        %incidies out of signal_map
                        %missing_field_index 
                        %find the number of signals the missing field was
                        %excected to have

                        obj.signal_map
                    end

                    % compare entry # signals to signal map
                    % find pattern in signal map X
                end
            %catch
                % warning("Plot named %s failed to load data. Some signals may be missing.\nDo they all have to-workspace blocks?",obj.name)
                % %stop plotting in any error occurs in data loading
                % obj.is_plottable = false;
            %end %try
        end %loadData
    
        function plot(obj, results)

            obj = obj.loadData(results); %start by loading in the data
            %{
            This function overloads the "plot" method to allow the
            plot(foo) function to input foo of type TimePlot.
            %}
            try
                n_rows = obj.layout(1);
                n_cols = obj.layout(2);
                K = n_rows*n_cols;
                if(obj.is_plottable)
                    %create the figure
                    figure('Name',obj.name,'NumberTitle','off')
                    %loop through each subplot
                    for k = 1:K
                        subplot(n_rows,n_cols,k)
                        hold on
                        %get the settings for this subplot
                        signal_idx_list = obj.signal_map{k};
                        v_labelk = obj.v_labels(k);
                        subtitlek = obj.subtitles(k);
                        legendk = obj.legends{k};
                        if(length(obj.h_labels)>1)
                            hlabelk = obj.h_labels(k);
                        else
                            hlabelk = obj.h_labels;
                        end
                        %plot each signal
                        for j = 1:length(signal_idx_list)
                            plot(obj.t(:,signal_idx_list(j)),obj.signals(:,signal_idx_list(j)))
                            xlabel(hlabelk, 'Interpreter', 'none')
                            ylabel(v_labelk, 'Interpreter', 'none')
                            if(~isequal(subtitlek,""))
                                title(subtitlek, 'Interpreter', 'none')
                            end
                        end
                        if(~isequal(legendk,""))
                            legend(legendk, 'Interpreter', 'none')
                        end
                    end
                    if(~isequal(obj.supertitle,""))
                        sgtitle(obj.supertitle, 'Interpreter', 'none')
                    end
                end
            catch
                close(gcf)
                warning("Plot named %s failed to plot fully. ..." + ...
                    "Some signals may be missing.\nDo they all have to-workspace blocks?",obj.name)
            end
        end %plot
    end %methods
end %TimePlot