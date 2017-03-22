%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run_MEEM.m
%% This is the wrapper for the MEEM tracker to run with the Benchmark Kit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function results=run_MEEM(seq, res_path, bSaveImage)

close all;
tic
%results = MEEMTrack(seq.path, seq.ext, false, seq.init_rect, seq.startFrame,seq.endFrame);
results = MEEMTrack(seq.path, seq.ext, false, seq.init_rect, seq.s_frames);
duration=toc;
results.fps=seq.len/duration;
disp(['fps: ' num2str(results.fps)])

end