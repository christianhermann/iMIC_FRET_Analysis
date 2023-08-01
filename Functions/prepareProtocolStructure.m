function [protocolStructure] = prepareProtocolStructure(protocolStructure, protocolStartTimeAC, protocolName)


switch protocolName
    case 'PIP2'
protocolStructure.TimeAC = protocolStructure.Time + protocolStartTimeAC;
protocolStructure.TimeBef = protocolStructure.TimeAC - 5;
protocolStructure.TimeAft1 = protocolStructure.TimeAC + 5;
protocolStructure.TimeAft2 = protocolStructure.TimeAC + 60;
protocolStructure.TimeAft3 = protocolStructure.TimeAC + 120;
protocolStructure.TimeAft4 = protocolStructure.TimeAC + 180;
protocolStructure.TimeAft5 = protocolStructure.TimeAC + 240;
protocolStructure.TimeAft5 = protocolStructure.TimeAC + 300;
protocolStructure(1,:) = [];
    case 'Protokol1'
protocolStructure.TimeAC = protocolStructure.Time + protocolStartTimeAC;
protocolStructure.TimeBef = protocolStructure.TimeAC - 5;
protocolStructure.TimeAft1 = protocolStructure.TimeAC + 5;
protocolStructure.TimeAft2 = protocolStructure.TimeAC + 55;
protocolStructure(1,:) = [];
    case 'Protokol2'
protocolStructure.TimeAC = protocolStructure.Time + protocolStartTimeAC;
protocolStructure.TimeBef = protocolStructure.TimeAC - 5;
protocolStructure.TimeAft1 = protocolStructure.TimeAC + 5;
protocolStructure.TimeAft2 = protocolStructure.TimeAC + 60;
protocolStructure.TimeAft3 = protocolStructure.TimeAC + 120;
protocolStructure.TimeAft4 = protocolStructure.TimeAC + 145;
protocolStructure(1,:) = [];
    case 'ProtokolCCh'
protocolStructure.TimeAC = protocolStructure.Time + protocolStartTimeAC;
protocolStructure.TimeBef = protocolStructure.TimeAC - 5;
protocolStructure.TimeAft1 = protocolStructure.TimeAC + 5;
protocolStructure.TimeAft2 = protocolStructure.TimeAC + 55;
protocolStructure.TimeAft3 = protocolStructure.TimeAC + 110;
protocolStructure.TimeAft4 = protocolStructure.TimeAC + 165;
    case 'ProtokolPIP'
protocolStructure.TimeAC = protocolStructure.Time + protocolStartTimeAC;
protocolStructure.TimeBef = protocolStructure.TimeAC - 5;
protocolStructure.TimeAft1 = protocolStructure.TimeAC + 5;
protocolStructure.TimeAft2 = protocolStructure.TimeAC + 55;
protocolStructure.TimeAft3 = protocolStructure.TimeAC + 110;
protocolStructure.TimeAft4 = protocolStructure.TimeAC + 165;
end
