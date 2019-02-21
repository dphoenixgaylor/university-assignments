% Handwritten Digit Recognition
% Damon Gaylor

%%%%% 1a
load('USPS.mat') % loads the USPS.mat file, which contains test and training data and labels (actual values)


%%%%% 1b
% creates trp16, which gives builds the first 16 images of the digits in train_patterns in matrix form
train1 = train_patterns(1:256, 1); % organizing the first column of train_patterns into a separate array
train1 = transpose(reshape(train1,[16,16])); % reshaping the array above to be 16x16 and transposing it

trp16 = train1; % storing newly created array into a different array, tp16

for k=2:16
    trp16(:,:,k) = transpose(reshape(train_patterns(1:256, k), [16,16])); % adds the next 15 arrays similar to test1
end
   
% creates a series of plots that show the first 16 images of the training set
figure;
for k=1:16
    subplot(4,4,k); % places the plot of an array in the k-th position on a 4x4 grid
    imagesc(trp16(:,:,k)); % plots the array with color
end


%%%%% 2
% creates train_aves, which shows the average position for each digit 0-9: this will be used later to predict labels of training data
avg_0 = mean(train_patterns(:, train_labels(1,:)==1),2); % creates a matrix that only includes patterns that correspond to the number 0; the rows (representing a certain pixel position) are then averaged
avg_0 = transpose(reshape(avg_0,[16,16])); % reshaping the array above to be 16x16 and transposing it

train_aves = avg_0; % storing newly created array into a different array, train_aves

for k=2:10
    train_aves(:,:,k) = transpose(reshape(mean(train_patterns(:, train_labels(k,:)==1),2),[16,16])); % adds the next 9 arrays similar to avg_0
end

% creates a series of plots that show the average pixel position for each digit
figure;
for k=1:10
    subplot(2,5,k); % places the plot of an array in the k-th position on a 4x4 grid
    imagesc(train_aves(:,:,k)); % plots the array with color
end


%%%%% 3a
% creates train_aves_nt, which is similar to train_aves above, only without reshaping and transposing

train_aves_nt = mean(train_patterns(:, train_labels(1,:)==1),2); % initializes train_aves_[no transpose] by computing avg_0 as before, without reshaping and transposing
 
for k=2:10
    train_aves_nt(:,k) = mean(train_patterns(:, train_labels(k,:)==1),2); % adds the next 9 arrays similar to the one above
end


% creates test_classif, which gives the sum of the euclidian distances between each average point and actual point for each image 
test0 = sum((test_patterns - repmat(train_aves_nt(:,1),[1 4649])).^2); % creates first row of test_classif described above
test_classif = test0; % puts that newly created first row into test_classif

for k=2:10
    test_classif(k,:) = sum((test_patterns - repmat(train_aves_nt(:,k),[1 4649])).^2); % creates the next 9 rows
end


%%%%% 3b
% creates test_classif_res, which stores the index with the lowest test_classif sum for each image
test_classif_res = zeros(1, 4649); % initializes test_classif_res with zeros

for k=1:4649
[tmp, ind] = min(test_classif(:,k)); % finds lowest value and its index for each k columns in test_classif
test_classif_res(:,k) = ind; % stores that index in the k-th column in test_classif_res
end


%%%%% 3c
% creates tmp, the confusion matrix
tmp = [0,0]; % intializes tmp
for k=1:10
    for l=1:10
        tmp(k,l) = sum(l == test_classif_res(test_labels(k,:)==1)); % sums the number of times digit a matched digit k (in test_labels)
    end
end

disp(tmp) % displays tmp


%%%%% 4a
% creates matrix train_u, which computes rank 17 svd of each set of images 
[train_u(:,:,1),tmp,tmp2] = svds(train_patterns(:,train_labels(1,:)==1),17); % computes the rank 17 svd and stores the left singular values U into a newly initialized train_u
for k=2:10
    [train_u(:,:,k),tmp,tmp2] = svds(train_patterns(:,train_labels(k,:)==1),17); % does same as above for k=2 to 10
end


%%%%% 4b
% creates matrix test_svd17, which computes expansion coefficients for test digits
test_svd17(:,:,1) = (train_u(:,:,1))' * test_patterns; % multiplies train_u by test_patterns and initializes test_svd17

for k=2:10
    test_svd17(:,:,k) = (train_u(:,:,k))' * test_patterns; % does the same as above for k=2 to 10
end


%%%%% 4c
% creates svd_approx, the matrix that gives the rank 17 svd approximation for each digit
svd_approx1 = train_u(:,:,1)*test_svd17(:,:,1); % creates an svd approximation by multiplying train_u by test_svd17
svd_approx = svd_approx1; % initializes svd_approx with svd_approx1

for k=2:10
    svd_approx(:,:,k) = train_u(:,:,k)*test_svd17(:,:,k); % repeats the same as with svd_approx1 above
end

% creates test_svd17_res, the matrix that gives the errors for the svd approximations
test_svd17_res1 = sum((test_patterns - svd_approx(:,:,1)).^2); % sums the errors between test_patterns and svd_approx for k=1
test_svd17_res = test_svd17_res1; % initializes test_svd17 with test_svd17_1

for k=2:10
    test_svd17_res(k,:) = sum((test_patterns - svd_approx(:,:,k)).^2); % repeats the same as above for test_svd17_1
end


%%%%% 4d
% creates svd_res, the matrix of indices representing the smallest error
svd_res = zeros(1, 4649); % initializes svd_res with zeros

for k=1:4649
[tmp, ind] = min(test_svd17_res(:,k)); % finds lowest value and its index for each k columns in test_svd17
svd_res(:,k) = ind; % stores that index in the k-th column in svd_res
end

% creates test_svd17_confusion, the confusion matrix
test_svd17_confusion = [0,0]; % intializes test_svd17_confusion
for k=1:10
    for l=1:10
         test_svd17_confusion(k, l) = sum(l == svd_res(test_labels(k,:)==1)); % sums the number of times digit a matched digit k (in test_labels)
    end
end

disp(test_svd17_confusion); % displays test_svd17_confusion