addpath(genpath('C:\Users\Christian\OneDrive\Dokumente\FRET\Utilitys'));
addpath(genpath('C:\Users\Christian\OneDrive\Dokumente\FRET\Scripts'));

%BALData = readtable('U:\Projekte an Analysis1\Christian\mTRPC5 Projekt\Auswertungen\FRET\AnalysisBAL.xlsx');

BALData = readtable('C:\Users\Christian\OneDrive\Dokumente\FRET\AnalysisBAL.xlsx');
BALData = BALData(BALData.quality == 1,:);
filler = repelem('+', numel(BALData.midi));
newMidi = [num2str(BALData.midi) filler' num2str(BALData.midiCo)];
newMidi = categorical(strtrim(strrep(string(newMidi), "+NaN","")));
BALData.midi = categorical(BALData.midi);
BALData.midiCo = categorical(BALData.midiCo);
BALData.newMidi = newMidi;


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.btCorrectedData_Rel);
g.set_title("btCorrectedData_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();



fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.btPbCorrectedData_Rel);
g.set_title("btPbCorrectedData_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.normFRET_Rel);
g.set_title("normFRET_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.normRatio_Rel);
g.set_title("normRatio_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.NFRET_Rel);
g.set_title("NFRET_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();


fig = figure();
g = gramm('x',BALData.newMidi,'y',BALData.EFRET_Rel);
g.set_title("EFRET_Rel")

%g.stat_violin('fill','transparent','normalization','width');
%g.no_legend();
g.stat_boxplot('width',0.15);
g.set_names('x','Midi','y','FRET Change');
g.draw();
g.update();
g.geom_jitter('dodge',0.7);
g.set_text_options("font",'Arial', 'base_size', 14, 'legend_scaling', 0.8,'legend_title_scaling', 0.8 );
g.draw();