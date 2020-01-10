lmax = 4;
N = [10^2,10^3,10^6,10^9,10^12];
B = 4;
Bp = 0.8;
p = 0.3;
q = 0.8;
ql = 1:10;

plength = geopdf(0:B-1,Bp)';
plength = plength/sum(plength);
Eb = sum(plength.*(1:B)');
pvals = zeros(2^lmax,size(N,2));
Vars = cell(size(N,2),1);
avgZ = zeros(2^lmax,size(N,2));
for i=1:size(N,2)
    Vars{i} = modelRLEcode_v2(lmax,N(i),p,q,ql,B,Bp);
    pvals(:,i) = Vars{i}{5};
    avgZ(:,i) = Vars{i}{6};
%     figure;
%     plot(Vars{i}{8});
end

Ebarr = Eb*ones(2^lmax-1,size(N,2)).*(avgZ(2:end,:)+1);
figure;
hold on
plot(pvals(2:end,:),'LineWidth',2);
plot(Ebarr,'--','LineWidth',2);
xlim([1,2^lmax-1]);
ylim([0,1.5]);
axis('square')
set(gca,'FontSize',14);
Fontsize = 14;
xl = get(gca,'XLabel');
xlFontSize = get(xl,'FontSize');
xAX = get(gca,'XAxis');
set(xAX,'FontSize', Fontsize)
set(xl, 'FontSize', xlFontSize);
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];


% figure;
% plot(Vars{1}{8});
 
% minM = zeros(2^lmax,size(p,2));
% for i=1:size(p,2)
%     minM(:,i) =  Vars{i}{8};
% end
% 
% g = [];
% for i=1:2^lmax
%     row = minM(i,:);
%     row = row(row>0);
%     g = [g;min(row(row>0))];
% end
% figure;
% plot(g);


