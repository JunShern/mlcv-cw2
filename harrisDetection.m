function[points] = harrisDetection(im, thresh)

    dx = [-1 0 1]; % Derivative masks
    dy = dx';

    % Blurring function to be tested (from 2017 cw)
    blur = [0.03 0.105 0.222 0.286 0.222 0.105 0.03];

    % Image derivatives
    Ix = conv2(im, dx, 'same');   
    Iy = conv2(im, dy, 'same'); 

    % Smoothed squared image derivatives
    Ix2 = conv2(Ix.^2, blur, 'same'); 
    Iy2 = conv2(Iy.^2, blur, 'same');
    Ixy = conv2(Ix.*Iy, blur, 'same');

    % Harris corner measure
    harris = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps); 

    % Compare to a threshold
    N = sum(sum(harris > thresh));
    points = zeros(2, N);

    n = 1;
    for row = 1:size(harris, 1)
        for col=1:size(harris, 2)
            if harris(row, col) > thresh
                points(1, n) = col;
                points(2, n) = row;
                n = n + 1;
            end
        end
    end

end