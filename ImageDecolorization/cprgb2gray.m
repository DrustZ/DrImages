function [gIm, origIm] = cprgb2gray(im)
	% input 'im' is a color image
	% output gIm is the resulting grayscale image
    [h, w, c] = size(im);
	% DO: Convert the input to LAB space
    lab = rgb2lab(im);
	% DO: Construct delta_xy for each neighboring pixels
    l = lab(:,:,1); a = lab(:,:,2); b = lab(:,:,3);
    delta_x = cal_delta([1,-1], l, a, b); delta_x = delta_x(1:end,1:end-1); delta_x = delta_x.';
    delta_y = cal_delta([1;-1], l, a, b); delta_y = delta_y(1:end-1,1:end); delta_y = delta_y.';
	% DO: Constructing A and Delta
    Delta = cat(1,delta_x(:),delta_y(:));
    % the upper part of the matrix
    A1 = speye(h*w);
    A = A1;
    A(1:end-1,2:end) = A(1:end-1,2:end) - speye(h*w-1);
    B = [w:w:h*w];
    %remove the last cols' coresspondence rows for they don't have right neighbors 
    A(B,:) = [];
    % now the lower part
    A1(1:end-w, w+1:end) = A1(1:end-w, w+1:end) - speye(h*w-w);
    A1 = A1(1:end-w,:);
    A = sparse(cat(1, A, A1));
	% TODO: Solve the objective function to get G
    tic
    G = A\Delta;
    toc
    origIm = reshape(G,w,h).';
	% Normalization and output gIm
	gIm = (origIm - min(origIm(:)))/ (max(origIm(:)) - min(origIm(:)));

end

function delta = cal_delta(filter, l, a, b)
    l = imfilter(l, filter, 'replicate'); 
    a = imfilter(a, filter, 'replicate');
    b = imfilter(b, filter, 'replicate');
    delta = arrayfun(@(x,y,z) sign(x)*norm([x y z]), l, a, b);
end