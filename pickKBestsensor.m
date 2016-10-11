
function [regionIdxs]=pickKBestsensor(expname, lrFoot, k)

cfg = expConfig();
% region image
imfile = makeProcFile('Mask', expname, lrFoot, 'out', '.png');
regionData = imread(imfile);
    
% aligned data
data = procStepAlign(expname, lrFoot);

%=== Compete actual and per-pos integral/peaks ===
intData = cell(numel(cfg.regions),1);
peakData = intData;
rposes = intData;

for stepIdx = 1:numel(data)
    stepd = data(stepIdx);

    %--- compute peak for all pos ---
    allPeaks = max(stepd.rfdata,[],3);

    %=== Iterate through regions ===
    for region=1:numel(cfg.regions)
        rpos = find(regionData==region);
        rposes{region} = rpos;

        %--- Find actual Peak ---
        thisPeak = max(allPeaks(rpos));

        %--- find sq error for each pos ---
        peakData{region} = [peakData{region}; thisPeak, allPeaks(rpos)'];
  
    end

end

for region = 1:numel(cfg.regions)

    [idxs] = pickKBest(peakData{region}, [data.train], k);
    
    regionIdxs(region, :) = rposes{region}(idxs);
end


        

function [idxs] = pickKBest(peakData, isTrain, k)
    
    %=== Pick best for peak ===
    peakErr = repmat(peakData(:,1), 1, size(peakData,2)-1) - peakData(:,2:end);
    peakErr = peakErr .* peakErr; % Get square error for each pos
    
    [m idxs] = sort(sum(peakErr(isTrain,:),1));
    idxs = idxs(1:k);
    
    idxs = idxs;
    
end

end