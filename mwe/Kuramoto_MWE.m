%% Kuramoto model of weakly synchronized oscillators
close all
clear all

% Number of oscillator for simulation
x    = 6;
y    = 6;
nrow = x;
ncol = y;
N    = x^2;

%% Initial conditions
%  Initial phase of each oscillator is uniform random:
theta0 = 2*pi*rand(nrow,ncol);
%figure,
%subplot 121
%imagesc(theta0); axis square
%subplot 122
%hist(theta0(:)); axis square

% Uniform driving frequencies:
omega1 = 2*pi*ones(nrow,ncol)*10; % 2*pi rad/sec = 1 cycle/sec, here x 10: 10 Hz
omega2 = abs(normrnd(1,0.01,N,1));
%figure,
%subplot 121
%hist(omega1(:)); axis square
%subplot 122
%hist(omega2); axis square


% Fixed parameters of the simulation:
% Everything is in seconds!
T     = 500; % total length
dt    = 0.05; % should reduce the dt for high-frequency oscillators!
tspan = 0:dt:T;
tds   = 0:20*dt:T; % downsampling
Tmax  = length(tds);
Tspan = length(tspan);
w     = 2*pi*omega2;
% Global coupling is deifned in steps:
gs    = 0:0.0005:0.02;
noise = 0.4; % (2*pi*0.65 ~= noise)
numGs = length(gs)
Ts = (Tmax-1)*dt*2; %% define time of interval
KOPs     = zeros(Tmax-1,numGs); %kuramoto order parameter
meanR    = zeros(1,numGs); % mean kuramoto order parameter
varR     = zeros(1,numGs); % variance of kuramoto order parameter
y        = zeros(N,Tmax);
%phi      = 2*pi*rand(N,1);
phi      = theta0(:);

% Initial synchronization is random and determined as a matrix of
% differences between the pair phase lags, not units. Hence N = x^2.
C          = 2*pi*rand(N,N)
C(C <= 2*pi*0.65) = 0; % Threshold weak synchronization (because noise)
%C(C > 2*pi*0.6) = 0; % Threshold strong synchronization
W = C;

%% Kuramoto simulation
tic

kk = 0; % Sampling counter
ph = cell(Tmax,1);
for g = gs
    display(g)
    G = g;
    tt = 0;
    for t = 1:Tspan
        r = repmat(phi,1,N);
        ynew = phi + dt*(w + G*sum(W.*sin(r'-r),2)) +  noise*sqrt(dt)*randn(N,1);
        phi = mod(ynew,2*pi);
        if mod(t,20) == 0
            tt = tt+1;
            y(:,tt) = phi;
        end
    end
    
    kk = kk+1; % Increase sampling count
    
    % Kuramoto order parameter (computed for links)
    kop = abs( sum( exp(1i*y) ) )/N;
    KOPs(:,kk) = kop(1:end-1);
    meanR(kk) = mean(kop(1:end-1));
    varR(kk) = std(kop(1:end-1)); 
    
    phases{kk} = y;
end
toc

%% Kuramoto bifurcation
figure,
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) 300, 200]); % Set plot size
plot(gs,meanR,'linewidth',2);
hold on
plot(gs,varR,'linewidth',2,'color', 'k');
%text(gs(find(max(varR)==varR)),max(varR), {num2str(max(varR))},'Fontsize', 16)
%text(gs(find(max(varR)==varR)),max(varR), 'std(R)','Fontsize', 16,'color', 'k')
xlabel('Global coupling','FontSize',18,'FontWeight','Bold');
%title('Synchronization dynamics','FontSize',22,'FontWeight','Bold');
leg = legend('K','std(K)')
set(leg , 'FontSize' , 18 , 'location' , 'east','box' , 'off' )
set(gca, 'FontSize', 18,'FontWeight','Bold', 'LineWidth', 2); % Set plot font size and linewidth
ylabel(['{\Delta}' '{\phi}' ' coherence (K)'],'FontSize',18);
set(gcf, 'color', 'w');
set(gca, 'box', 'off');

%% Spatiotemporal phase difference distribution of the Kuramoto model
y = cell2mat(phases(find(max(varR)==varR)))';
% figure,
% for t=1:size(y,1)
%     theta1D = y(t,:);
%     theta2D = reshape(theta1D,nrow,ncol,[]);
%     imagesc(theta2D);
%     pause(0.1);
% end
% Compute phase differences from the model
ph_diff = cell(size(y,1));
tic
for t = 1:size(y,1) % loop over time
    diff = bsxfun(@minus,y(t,:),y(t,:)');
    ph_diff{t} = diff;
end
phDiff = cat(3,ph_diff{:});


%% Phase diferences timeflow histogram settings
%--------------------------------------------------------------------------
time = size(phDiff,3); % Time span
binEdges = -pi:pi/25:pi; % Phase bin edges
D = zeros(size(size(phDiff,1),1)*(size(size(phDiff,1),1)-1)/2,1); % Allocate memory for phase diferences at each time t
linkOrder = zeros(time,1); % Allocate memory
kOrder = zeros(time,1); % Allocate memory for population mean phase coherence
P = zeros(size(binEdges,2)-1,time);
for t=1:time-1 % Time flow
    deltaPh = phDiff(:,:,t);
    D = deltaPh(find(tril(ones(size(deltaPh)),-1)));
    %find(D==0);
    %D = nonzeros(D); % Phase diferences at each time t
    D = wrapToPi(D);
    kOrder(t) = abs( sum( exp(1i*y(t,:)) ) )/size(phDiff,1);
    %kOrder(t) = real(abs(mean(exp(1i*y(t,:))))); % Kuramoto order parameter
    linkOrder(t) = real(abs(mean(exp(1i*D)))); % Link order parameter
    [N,binEdges] = histcounts(D,binEdges); % Compute timestep phase diferences distribution
    P(:,t) = N; % Save timestep phase diferences distribution
end

%% Plot spatiotemporal phase differences distribution
figure,
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1)+300 pos(2) 400, 200]); % Set plot size
set(gcf, 'color', 'w'); % Set figure background
pcolor(P); shading flat; colormap jet;
% caxis([0 max(max(P))]); % Plot phase diferences time flow histogram
hold on
% plot(linkOrder*numel(binEdges)+1,'-g','Linewidth',2); % Plot mean phase coherence
plot(kOrder*numel(binEdges)+1,'-w','Linewidth',2); % Plot mean phase coherence
% title(['G: ' num2str(gs(find(PLVfit==max(PLVfit))))],'FontSize',22);
%title(['G: ' num2str(gs(1))],'FontSize',22);
xlabel('Time point (p.d.u.)','FontSize',18,'FontWeight','Bold');
set(gca, 'FontSize', 18,'FontWeight','Bold', 'LineWidth', 2); % Set plot font size and linewidth
%set(gca,'XTickLabel',num2str((75:75:300)'));
set(gca,'YTickLabel',[1/5 2/5 3/5 4/5 1]);
text(size(P,2)+2,0,'-\pi','FontSize',28,'FontWeight','Bold');
text(size(P,2)+2,25,'0','FontSize',18);
text(size(P,2)+2,50,'\pi','FontSize',28,'FontWeight','Bold');
ylabel(['{\Delta}' '{\phi}' ' coherence (K)'],'FontSize',18);
set(gcf, 'color', 'w');
set(gca, 'box', 'off');
%set(gca,'XLim',[1 200]);