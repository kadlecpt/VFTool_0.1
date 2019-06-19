function model = runVectorFitting(s, fVals, order, nIters, isPeaks, ...
   poleDistribution)

model.poles = [];
model.residues = [];
model.d = [];
model.e = [];
if nargin < 6
   % check if curve in fVals is peaky
   % todo: meybe gradient-based selection
   poleDistribution = 'logarithmic';
   if nargin < 5
      isPeaks = true;
      if nargin < 4
         nIters = 1;
      end
   end
end
% take only even number of poles
order = floor(order/2)*2;
[nS, c] = size(s);
if nS == 1
   s = s.';
   nS = c;
end

nF = size(fVals, 1);
if nF == 1
   fVals = fVals.';
end


%% poles
% get initial poles
[realPoles, complexPoles] = createPoles(s, order, isPeaks, poleDistribution);
for iIter = 1:nIters
   
   if isempty(realPoles)
      realRatios = [];
   else
      realRatios = 1./(s - realPoles);
   end
   
   oddComplexPoles = complexPoles(1:2:end);
   temp1 = [...
      1./(s - oddComplexPoles) + 1./(s - (oddComplexPoles').'), ...
      1j./(s - oddComplexPoles) - 1j./(s - (oddComplexPoles').')];
   complexRatios = temp1;
   complexRatios(:, 1:2:end) = temp1(:, 1:end/2);
   complexRatios(:, 2:2:end) = temp1(:, end/2+1:end);
   
   if isempty(realPoles)
      A = [complexRatios, ...
         ones(nS,1), ...
         s, ...
         -repmat(fVals, 1, size(complexRatios, 2)).*complexRatios];
   else
      A = [realRatios, ...
         complexRatios, ...
         ones(nS,1), ...
         s, ...
         -repmat(fVals, 1, size(realRatios, 2)).*realRatios, ...
         -repmat(fVals, 1, size(complexRatios, 2)).*complexRatios];
   end
   
   %% solve least squares problem
   scale = norm(fVals);
   scale = scale/nS;
   lastRowA = [zeros(1, order+2), real(scale*sum(A(:, 1:order)))];
   A = [real(A), -real(fVals); imag(A), -imag(fVals); lastRowA, scale*nS];
   [Q, R] = qr(A,0);
   b = Q(end, order + 3:end)*nS*scale;
   Rpart = R(order + 3:end, order + 3:end);
   nR = size(Rpart, 2);
   eScale = zeros(1, nR);
   for iC = 1:nR
      eScale(iC) = 1/norm(Rpart(:,iC));
   end
   Rpart = Rpart.*repmat(eScale, order + 1, 1);
   x = Rpart\b';
   x = x.*eScale';
   
   C = x(1:end-1);
   d = x(end);
   
   % make C complex again
   nR = size(realPoles, 2);
   nC = size(complexPoles,2);
   cReal = C(nR+1:2:end).';
   cImag = C(nR+2:2:end).';
   C = [C(1:nR); reshape([cReal + 1j*cImag; cReal - 1j*cImag], [], 1)];
   %% zeros
   A = diag(realPoles);
   for iC = 1:nC/2
      curP = complexPoles((iC-1)*2+1);
      curC = C(nR + (iC - 1)*2 + 1);
      A = blkdiag(A, [real(curP), imag(curP); ...
         -imag(curP), real(curP)]);
      C(nR + (iC-1)*2 + 1) = real(curC);
      C(nR + (iC-1)*2 + 2) = imag(curC);
   end
   b = [ones(nR, 1); repmat([2; 0], nC/2, 1)];
   
   if abs(d) < 1e-8  % check for sovability
      d = 1e-8*d/abs(d);
   end
   vals = eig(A - b*C.'/d);
   % make all zeros stable
   notStable = real(vals) > 0;
   vals(notStable) = vals(notStable) - 2*real(vals(notStable));
   % sort so that real come first
   vals = sort(vals);
   isReal = abs(imag(vals)) <= 1e-14;
   realPoles = real(vals(isReal))';
   complexPoles = vals(~isReal).';
   complexPoles = complexPoles - 1i*2*imag(complexPoles);
   vals = [realPoles, complexPoles].';
   
   %% save results
   model.poles = vals;

   if iIter == nIters
      % sort poles so that [-a - 1j*b, -a + 1j*b]
      nR = numel(realPoles);
      nC = order - nR;
      isReal = false(1, order);
      isReal(1:nR) = true;
      realRatios = 1./(s - realPoles);
      if nC > 0
         % complex pole found
         oddComplexPoles = complexPoles(1:2:end);
         temp1 = [...
            1./(s - oddComplexPoles) + 1./(s - (oddComplexPoles').'), ...
            1j./(s - oddComplexPoles) - 1j./(s - (oddComplexPoles').')];
         complexRatios = temp1;
         complexRatios(:, 1:2:end) = temp1(:, 1:end/2);
         complexRatios(:, 2:2:end) = temp1(:, end/2+1:end);
         
         A = [realRatios, ...
            complexRatios, ...
            ones(nS,1), ...
            s];
      else
         % no complex poles
         A = [realRatios, ...
            ones(nS,1), ...
            s];
      end
      
      A = [real(A); imag(A)];
      b = [real(fVals); imag(fVals)];
      
      nA = size(A, 2);
      eScale = zeros(1, nA);
      for iC = 1:nA
         eScale(iC) = norm(A(:,iC));
      end
      A = A./repmat(eScale, 2*nS, 1);
      x = (A\b)./eScale';
      
      cOut = x(1:order);
      % make complex again
      complexC = cOut(~isReal);
      cReal = complexC(1:2:end).';
      cImag = complexC(2:2:end).';
      model.residues = [cOut(isReal); ...
         reshape([cReal + 1j*cImag; cReal - 1j*cImag], [], 1)];
      
      model.d = x(order + 1);
      model.e = x(order + 2);
   end
end

end

