function meanBackground = getBackground(filename)
    if nargin < 1
        filename = 'C:\Users\Christian\OneDrive\Dokumente\FRET\Background\background.mat';  % Pre-filled string
    end
    
    files = load(filename);
    meanBackground = files.meanBackground;
end