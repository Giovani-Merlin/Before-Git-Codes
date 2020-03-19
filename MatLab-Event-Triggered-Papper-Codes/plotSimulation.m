figure;

%
h=subplot(3,1, 1);
j1=plot(0:kfin, xs','Color',[0 0.5 0.8]); hold on;
j2=plot(0:kfin, xp','Color',[0.85,0.325,0.098],'LineStyle','--');

ylabel('State');
xlabel('k')
legend([j1(1), j2(1)],'PETC','PU','Location', 'northeast');
 ylim([-25 20])
xlim([0 kfin])
%
h = subplot(3,1, 2);
j=stairs(controlVec');
ylabel('Control')
xlabel('k')
legend([j(1), j(2)],'PETC','PU','Location', 'northeast');
ylim([-5 5])
xlim([0 kfin])
%
h = subplot(3,1, 3); 

vecs = find(samplingVec')-1;
SamplingDeltas = SamplingDeltas-1;
SamplingDeltas = [0 SamplingDeltas(1:end)'];
stem(vecs,SamplingDeltas, 'r' );

ylabel('Inter-Event Time')
xlabel('k')
xlim([0 kfin])

hold off; 