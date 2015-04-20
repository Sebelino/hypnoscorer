% Generate data + labels
quantity = 10;
rands1 = [rand(quantity,1),2*pi*rand(quantity,1)];
rands2 = [rand(quantity,1),2*pi*rand(quantity,1)];
polarands1 = [rands1(:,1),rands1(:,1)].*[cos(rands1(:,2)),sin(rands1(:,2))];
polarands2 = [rands2(:,1),rands2(:,1)].*[cos(rands2(:,2)),sin(rands2(:,2))];
X = [ones(quantity,2)+polarands1;2.5*ones(quantity,2)+polarands2];
y = [repmat({'A'},quantity,1);repmat({'B'},quantity,1)];

% Make SVM
m = fitcsvm(X,y);
sv = m.SupportVectors;
cv = crossval(m);
classloss = kfoldLoss(cv);

% Plot figure
figure
whitebg(1,'k')
gscatter(X(:,1),X(:,2),y,[],[],6*[1,1])
hold on
plot(sv(:,1),sv(:,2),'yo','MarkerSize',3)

% Plot SVM line
w = sum(repmat(m.Alpha,1,2).*sv);
xlimits = xlim;
linex = linspace((3*xlimits(1)+xlimits(2))/4,(xlimits(1)+3*xlimits(2))/4);
liney = -w(1)*linex/w(2)-m.Bias;
plot(linex,liney)


