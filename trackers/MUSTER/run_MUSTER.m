function results=run_MUSTER(seq, res_path, bSaveImage)

addpath('./mexopencv');
addpath('./ICF');
% base_path = './';
% res_path = 'Results/';

% video_path = [base_path name '/'];

% [ source.img_files, pos, target_sz, ground_truth, source.video_path]...
%  = load_video_info(video_path);
source.img_files = seq.s_frames;
source.n_frames = numel(source.img_files);
rect_init = seq.init_rect;%[pos, target_sz];
source.video_path=[];

tic();
bboxes = MUSTer_tracking(source, rect_init,0); %0 for turn off the visualization
time = toc();

results.fps = seq.len / time;
results.type = 'rect';
results.res = bboxes;%each row is a rectangle
disp(['fps: ', num2str(results.fps)]);
end