%%%mTq2%%%
folder = 'C:\Users\Christian\Documents\FRET\BleedThrough\mTq2';
bleedthroughmTq2 = bleedthroughFunction(folder);
btmTq2DonorFRET = mean([bleedthroughmTq2.SexSemSexLem]);
save("btmTq2DonorFRET.mat", 'btmTq2DonorFRET');

%%%cpmTq2%%%
folder = 'C:\Users\Christian\Documents\FRET\BleedThrough\cpmTq2';
bleedthroughcpmTq2 = bleedthroughFunction(folder);
btcpmTq2DonorFRET = mean([bleedthroughcpmTq2.SexSemSexLem]);
save("btcpmTq2DonorFRET.mat", 'btcpmTq2DonorFRET');


%%%FlAsH%%%
folder = 'C:\Users\Christian\Documents\FRET\BleedThrough\FlAsH';
bleedthroughFlAsH = bleedthroughFunction(folder);
%Vernachlässigbar Gering%



%%%Atto425MeTet%%%
folder = 'C:\Users\Christian\Documents\FRET\BleedThrough\Atto425MeTet';
bleedthroughAtto425 = bleedthroughFunction(folder);
btAtto425DonorFRET = mean([bleedthroughAtto425.SexSemSexLem]);
save("btAtto425DonorFRET.mat", 'btAtto425DonorFRET');


%%%CF500MeTet%%%
folder = 'C:\Users\Christian\Documents\FRET\BleedThrough\CF500MeTet';
bleedthroughCF500 = bleedthroughFunction(folder);
btCF500AkzeptorFRET = mean([bleedthroughCF500.LexLemSexLem]);
save("btCF500AkzeptorFRET.mat", 'btCF500AkzeptorFRET');

%%
%%%Pairs%%%
%%mTq2-FlAsH%%
btmTq2FlAsH.DF = btmTq2DonorFRET;
btmTq2FlAsH.AF = 0;
btmTq2FlAsH.AD = 0;
btmTq2FlAsH.DA = 0;
save("btmTq2FlAsH.mat", 'btmTq2FlAsH');


%%mTq2-CF500MeTet%%
btmTq2CF500.DF = btmTq2DonorFRET;
btmTq2CF500.AF = btCF500AkzeptorFRET;
btmTq2CF500.AD = 0;
btmTq2CF500.DA = 0;
save("btmTq2CF500.mat", 'btmTq2CF500');


%%cpmTq2-FlAsH%%
btcpmTq2FlAsH.DF = btcpmTq2DonorFRET;
btcpmTq2FlAsH.AF = 0;
btcpmTq2FlAsH.AD = 0;
btcpmTq2FlAsH.DA = 0;
save("btcpmTq2FlAsH.mat", 'btcpmTq2FlAsH');


%%cpmTq2-CF500MeTet%%
btcpmTq2CF500.DF = btcpmTq2DonorFRET;
btcpmTq2CF500.AF = btCF500AkzeptorFRET;
btcpmTq2CF500.AD = 0;
btcpmTq2CF500.DA = 0;
save("btcpmTq2CF500.mat", 'btcpmTq2CF500');


%%Atto425-FlAsH%%
Att425FlAsH.DF = btAtto425DonorFRET;
Att425FlAsH.AF = btCF500AkzeptorFRET;
Att425FlAsH.AD = 0;
Att425FlAsH.DA = 0;
save("Att425FlAsH.mat", 'Att425FlAsH');
%%

