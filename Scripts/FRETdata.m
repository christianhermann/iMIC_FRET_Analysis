classdef FRETdata
    % FRETdata - A class for processing fluorescence resonance energy transfer (FRET) data.
    %
    %   The FRETdata class provides methods to correct FRET data for
    %   photobleaching, calculate FRET ratios, and normalize FRET ratios to one. The class
    %   also contains properties for storing the raw FRET data, the FRET data corrected for
    %   background fluorescence, the FRET data corrected for background fluorescence and
    %   photobleaching, the FRET ratio, the normalized FRET ratio, and the E-FRET value.
    %
    %   Example usage:
    %       data = load('myFRETdata.mat');
    %       myFRET = FRETdata(rawData, btData, Gfactor)
    %       myFRET.correctIntensities(data);
    %       myFRET.correctBleaching(data, bandwidth);
    %       myFRET.calculateRatio(data);
    %       myFRET.calculateNFRET(data);
    %       myFRET.calculateEFRET(data);
    %       myFRET.normFRETtoOne(data, setto1meanstart, setto1meanlength);
    %       myFRET.createFRETPlot();
    %       myFRET.createXlsxTable();
    %
    % Properties:
    %   fileName          - The file name.
    %   filePath          - The file path.
    %   rawData           - The raw FRET data.
    %   btData            - Bleedthrough values
    %   origTime          - The original time values
    %   corTime           - The corrected time values after cutting the measurement.
    %   cutData           - The FRET data with set start and end timepoints.
    %   btCorrectedData   - The FRET data corrected for background fluorescence.
    %   btPbCorrectedData - The FRET data corrected for background fluorescence and photobleaching.
    %   Ratio             - The FRET ratio calculated from the btPbCorrectedData.
    %   NFRET             - The normalized FRET ratio (Xia et. al).
    %   EFRET             - The E-FRET value (Zal et. al).
    %   normFRET          - The FRET ratio normalized to one.
    %
    % Methods:
    %   cutMeasurement     - Cuts the measurement.
    %   correctIntensities - Corrects the intensities in the rawData property using the
    %                        background and direct acceptor/donor fluorescence measurements.
    %   correctBleaching   - Corrects for photobleaching in the btCorrectedData property.
    %   calculateRatio     - Calculates the FRET ratio from the btCorrectedData property.
    %   calculateNFRET     - Calculates the normalized FRET ratio from the Ratio property.
    %   calculateEFRET     - Calculates the E-FRET value from the NFRET property.
    %   normFRETtoOne      - Normalizes the normFRET property to one.
    %   createFRETPlot     - Creates a plot of the FRET data.
    %   createRawDataPlot  - Creates a plot of the Raw data.
    %   createXlsxTable     - Creates a xlsx table containing the data.
    %
    % See also:
    %   FRETdata/correctIntensities, FRETdata/correctBleaching, FRETdata/calculateRatio,
    %   FRETdata/calculateNFRET, FRETdata/calculateEFRET, FRETdata/normFRETtoOne,
    %   FRETdata/createFRETPlot, FRETdata/cutMeasurement


    properties
        fileName
        filePath
        rawData
        btData
        Gfactor
        origTime
        cutTime
        cutData
        btCorrectedData
        btPbCorrectedData
        normFRET
        Ratio
        NFRET
        EFRET
    end

    methods
        % Constructor
        function obj = FRETdata(rawData, btData, Gfactor, fileName, filePath)
            % FRETdata Constructor creates an instance of the FRETdata class
            % with the rawData, btData, and Gfactor properties initialized
            % with the provided input values.
            %
            % Syntax:
            %   fret = FRETdata(rawData, btData, Gfactor)
            %
            % Inputs:
            %   rawData     -original FRET data
            %   btData      -bleedthrough FRET data
            %   Gfactor     -G-factor used for background correction
            %   fileName    -the filename
            %   filePath    -the filepath

            obj.rawData = rawData;
            obj.btData = btData;
            obj.Gfactor = Gfactor;
            obj.fileName = fileName;
            obj.filePath = filePath;
            obj.origTime = rawData.('time (s)');
        end

        function obj = cutMeasurement(obj, data)
            % Corrects the intensities in the input data
            % using the background and direct acceptor/donor
            % fluorescence measurements (btDF, btDA, btAD, btAF)
            tableData = obj.(data);
            fig = figure;
            plot(tableData.('time (s)'), tableData.Donor,  '-o');
            grid on
            grid minor
            fig.WindowState = 'maximized';


            shg
            dcm_obj = datacursormode(1);
            set(dcm_obj,'DisplayStyle','window',...
                'SnapToDataVertex','off','Enable','on')
            waitforbuttonpress
            c_info_start = getCursorInfo(dcm_obj);
            dataIndex_start = c_info_start.DataIndex;
            close;

            newTable = table();
            newTable = tableData(dataIndex_start(1):size(tableData,1),2:5);
            cutTime = obj.origTime(dataIndex_start(1):size(obj.origTime));
            cutTime = cutTime - cutTime(1);
            obj.cutTime = cutTime;
            obj.cutData = newTable;
        end

        function obj = correctIntensities(obj, data)
            % Corrects the intensities in the input data
            % using the background and direct acceptor/donor
            % fluorescence measurements (btDF, btDA, btAD, btAF)
            tableData = obj.(data);
            DonorCor = (tableData.Donor - obj.btData.btAD * tableData.Acceptor) / (1 - obj.btData.btDA * obj.btData.btAD);
            AcceptorCor = (tableData.Acceptor - obj.btData.btDA * tableData.Donor) / (1 - obj.btData.btDA * obj.btData.btAD);
            FRETCor = tableData.FRET - obj.btData.btDF * DonorCor - obj.btData.btAF * AcceptorCor;
            newTable = table();
            newTable.Donor = DonorCor;
            newTable.Acceptor = AcceptorCor;
            newTable.FRET = FRETCor;
            obj.btCorrectedData = newTable;
        end

        function obj = correctBleaching(obj, data, bandwith)
            % Corrects for photobleaching in the input data
            tableData = obj.(data);
            fig = figure;
            plot( tableData.Acceptor,  '-o');
            grid on
            grid minor
            fig.WindowState = 'maximized';

            for j = 1:2
                shg
                dcm_obj = datacursormode(1);
                set(dcm_obj,'DisplayStyle','window',...
                    'SnapToDataVertex','off','Enable','on')
                waitforbuttonpress
                c_info{j} = getCursorInfo(dcm_obj);
                dataIndex(j) = c_info{j}.DataIndex;
            end
            grid off;
            close;

            if(dataIndex(1)) < bandwith
                dif = bandwith - dataIndex(1);
                dataIndex(1) = bandwith + 1;
                dataIndex(2) = dataIndex(2)+dif;
            end

            newTable = table();

            dIwB1 = indexWBandwith(dataIndex(1), bandwith);
            dIwB2 = indexWBandwith(dataIndex(2), bandwith);
            Acceptor = tableData.Acceptor;
            Donor = tableData.Donor;
            FRET = tableData.FRET;
            DonorCorNormBleachCor = Donor - obj.cutTime *...
                (mean(Donor(dIwB1))-mean(Donor(dIwB2))) / ...
                (obj.cutTime(dataIndex(2)) - obj.cutTime(dataIndex(1)));
            newTable.Donor = DonorCorNormBleachCor;

            FRETCorNormBleachCor = FRETCorNorm - obj.cutTime *...
                (mean(FRET((dataIndex(2) - bandwith):(dataIndex(2) + bandwith)))...
                -mean(FRET((dataIndex(1) - bandwith):(dataIndex(1) + bandwith))))...
                / (obj.cutTime(dataIndex(2)) - obj.cutTime(dataIndex(1)));
            newTable.FRET = FRETCorNormBleachCor;

            AcceptorCorNormBleachCor = AcceptorCor - obj.cutTime *...
                (mean(Acceptor((dataIndex(2) - bandwith):(dataIndex(2) + bandwith)))...
                -mean(Acceptor((dataIndex(1) - bandwith):(dataIndex(1) + bandwith))))...
                / (obj.cutTime(dataIndex(2)) - obj.cutTime(dataIndex(1)));
            newTable.Acceptor = AcceptorCorNormBleachCor;

            obj.btPbCorrectedData = newTable;

        end

        function obj = normFRETtoOne(obj, data, setto1meanstart, setto1meanlength)
            % Normalizes the normFRET property to one
            tableData = obj.(data);
            range = setto1meanstart:setto1meanlength;
            newTable = table();
            DonorCorNorm = tableData.DonorCor ./ mean(tableData.DonorCor(range));
            newTable.Donor = DonorCorNorm;

            FRETCorNorm = tableData.FRETCor ./ mean(tableData.FRETCor(range));
            newTable.FRET = FRETCorNorm;

            AcceptorCorNorm = tableData.AcceptorCor ./ mean(tableData.AcceptorCor(range));
            newTable.Acceptor = AcceptorCorNorm;
            obj.normFRET = newTable;

        end

        function obj = calculateRatio(obj, data)
            % Calculates the FRET ratio from the input data
            tableData = obj.(data);
            RatioFRET = tableData.FRET ./ tableData.Donor;
            newTable.FRET = RatioFRET;
            newTable.Donor = tableData.Donor;
            newTable.Acceptor   = tableData.Acceptor;
            obj.NFRET = newTable;
        end

        function obj = calculateNFRET(obj, data)
            % Calculates the normalized FRET (Xia et al) ratio from the
            % corrected FRET data
            tableData = obj.(data);
            newTable = table();
            FRETXia = FRET ./ sqrt(tableData.Donor .* tableData.Acceptor);
            newTable.FRET = FRETXia;
            newTable.Donor = tableData.Donor;
            newTable.Acceptor   = tableData.Acceptor;
            obj.NFRET = newTable;
        end

        function obj = calculateEFRET(obj, data)
            % Calculates the E-FRET value from the raw data

            tableData = obj.(data);
            btData = obj.btData;
            a = btData.AF;
            b = btData.AD;
            c = btData.DA;
            d = btData.DF;
            G = obj.Gfactor;
            newTable = table();
            numerator = tableData.FRET - (a - b*d) * tableData.Acceptor - (d - a*c) * tableData.Donor;
            denominator = tableData.FRET - (a - b*d) * tableData.Acceptor - (d - a*c - G) * tableData.Donor;
            Eapp = numerator ./denominator;
            Ecorr = Eapp * ((tableData.Acceptor(1) - c * tableData.Donor(1)) ./ (tableData.Acceptor - c * tableData.Donor));

            newTable.FRET = Ecorr;
            newTable.Donor = tableData.Donor;
            newTable.Acceptor   = tableData.Acceptor;
        end

        function fig = createRawDataPlot(obj, varargin)
            % Creates a plot of the Raw data

            % Create input parser
            p = inputParser;

            % Define optional inputs and their default values
            addOptional(p, 'colors', ['b','b','g','g']);
            addOptional(p, 'OuterPosition', [0.25 0.25 10 10]);
            addOptional(p, 'Units', 'centimeters');
            addOptional(p, 'Xaxis', repelem("time (s)", 4));
            addOptional(p, 'Yaxis',  ["Donor" "Empty" "FRET" "Acceptor" ]);
            addOptional(p, 'textTitle',  ["Donor" "Empty" "FRET" "Akzeptor"]);
            addOptional(p, 'xlab', repelem("t (s)", 4));
            addOptional(p, 'ylab', ["Intensität (µA)" "Intensität (µA)" "Intensität (mV)" "Intensität (mV)"]);

            % Parse inputs
            parse(p,  varargin{:});
            % Retrieve input arguments
            OuterPosition = p.Results.OuterPosition;
            Units = p.Results.Units;
            colors = p.Results.colors;
            Xaxis = p.Results.Xaxis;
            YAxis = p.Results.Yaxis;
            textTitle = p.Results.textTitle;
            xlab = p.Results.xlab;
            ylab = p.Results.ylab;

            fig = figure();
            fig.Units = Units;
            fig.OuterPosition = OuterPosition;
            tableData = obj.rawData;
            tableData.Donor = tableData.Donor*10^6;
            tableData.Empty = tableData.Empty*10^6;
            tableData.FRET =  tableData.FRET*10^3;
            tableData.Acceptor =  tableData.Acceptor*10^3;
            for i = 1:numel(Xaxis)
                nexttile
                plot(tableData.(Xaxis(i)), tableData.(YAxis(i)),colors(i))
                title(textTitle(i))
                xlabel(xlab(i))
                ylabel(ylab(i))
                box off
            end
            sgtitle(sprintf(obj.fileName, '\n Raw'),'Interpreter', 'none', 'FontSize', 9)
        end

        function fig = createFRETPlot(obj, data, varargin)
            %createFRETPlot - Creates a plot of the FRET data.
            %
            % Syntax:
            %   fig = createFRETPlot(obj, data, varargin)
            %
            % Inputs:
            %   obj - An instance of the FRETdata class.
            %   data - The name of the data to be plotted.
            %
            % Optional Name-Value Pair Arguments:
            %   colors - A 1x3 character array containing the colors to use for each
            %            trace. Default is ['b','g','g'].
            %   OuterPosition - A 1x4 vector defining the outer position of the figure
            %                   in cm. Default is [0.25 0.25 10 10].
            %   Units - A string defining the units of the figure. Default is
            %           'centimeters'.
            %   Xaxis - A 1x3 cell array of character vectors defining the names of the
            %           columns to use for the x-axis of each subplot. Default is
            %           repelem("cutTime", 3).
            %   Yaxis - A 1x3 cell array of character vectors defining the names of the
            %           columns to use for the y-axis of each subplot. Default is
            %           ["Donor" "Acceptor" "FRET"].
            %   textTitle - A 1x3 cell array of character vectors defining the titles
            %               for each subplot. Default is ["Donor" "Akzeptor" "FRET"].
            %   xlab - A 1x3 cell array of character vectors defining the x-axis labels
            %          for each subplot. Default is repelem("t (s)", 3).
            %   ylab - A 1x3 cell array of character vectors defining the y-axis labels
            %          for each subplot. Default is ["Intensität (µA)" "Intensität (mV)" "Intensität (mV)"].
            %   changeUnitFRET - A scalar factor to change the units of the FRET column.
            %                    Default is 1.
            %   changeUnitAcceptor - A scalar factor to change the units of the Acceptor
            %                        column. Default is 1.
            %   changeUnitDonor - A scalar factor to change the units of the Donor
            %                     column. Default is 1.
            %
            % Outputs:
            %   fig - A MATLAB figure object containing the plot.

            % Create input parser
            p = inputParser;

            % Define optional inputs and their default values
            addOptional(p, 'colors', ['b','g','g']);
            addOptional(p, 'OuterPosition', [0.25 0.25 10 10]);
            addOptional(p, 'Units', 'centimeters');
            addOptional(p, 'Xaxis', repelem("cutTime", 3));
            addOptional(p, 'Yaxis',  ["Donor" "Acceptor" "FRET" ]);
            addOptional(p, 'textTitle',  ["Donor" "Akzeptor" "FRET"]);
            addOptional(p, 'xlab', repelem("t (s)", 3));
            addOptional(p, 'ylab', ["Intensität (A)" "Intensität (V)" "Intensität (V)"]);
            addOptional(p, 'changeUnitFRET', 1);
            addOptional(p, 'changeUnitAcceptor', 1);
            addOptional(p, 'changeUnitDonor', 1);

            % Parse inputs
            parse(p,  varargin{:});
            % Retrieve input arguments
            OuterPosition = p.Results.OuterPosition;
            Units = p.Results.Units;
            colors = p.Results.colors;
            Xaxis = p.Results.Xaxis;
            YAxis = p.Results.Yaxis;
            textTitle = p.Results.textTitle;
            xlab = p.Results.xlab;
            ylab = p.Results.ylab;
            changeUnitFRET = p.Results.changeUnitFRET;
            changeUnitDonor = p.Results.changeUnitDonor;
            changeUnitAcceptor = p.Results.changeUnitAcceptor;


            fig = figure();
            fig.Units = Units;
            fig.OuterPosition = OuterPosition;
            tableData = obj.(data);
            tableData.Donor =    tableData.Donor * changeUnitDonor;
            tableData.FRET =     tableData.FRET * changeUnitFRET;
            tableData.Acceptor = tableData.Acceptor * changeUnitAcceptor;

            for i = 1:numel(Xaxis)
                nexttile
                plot(obj.(Xaxis(i)), tableData.(YAxis(i)),colors(i))
                title(textTitle(i))
                xlabel(xlab(i))
                ylabel(ylab(i))
                box off
            end
            sgtitle(sprintf(obj.fileName, '\n' , data),'Interpreter', 'none', 'FontSize', 9)
        end

        function saveXlsxTable(obj)
            % Creates a Xlsx table containing the FRET data

            mkdir(fullfile(obj.filePath));
            fullsafeName = fullfile(obj.filePath, obj.fileName);
            compSaveName = append(fullsafeName,'.xlsx');
            writetable(obj.rawData, compSaveName, 'Sheet', 'Raw');
            writematrix(obj.origTime, compSaveName, 'Sheet', 'origTime(s)');
            writematrix(obj.cutTime, compSaveName, 'Sheet', 'cutTime(s)');
            writetable(obj.cutData, compSaveName, 'Sheet', 'cutData');
            writetable(obj.btCorrectedData, compSaveName, 'Sheet', 'btCorrectedData');
            writetable(obj.btPbCorrectedData, compSaveName, 'Sheet', 'btPbCorrectedData');
            writetable(obj.normFRET, compSaveName, 'Sheet', 'normFRET');
            writetable(obj.Ratio, compSaveName, 'Sheet', 'Ratio');
            writetable(obj.NFRET, compSaveName, 'Sheet', 'NFRET');
            writetable(obj.EFRET, compSaveName, 'Sheet', 'EFRET');
        end
    end
end