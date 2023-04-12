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
save("BleedThrough/btCF500AkzeptorFRET.mat", 'btCF500AkzeptorFRET');

