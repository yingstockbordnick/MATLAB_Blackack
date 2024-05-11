%% =======================================================================
% MATLAB Project - Blackjack
% Ying Stock-Bordnick, Henry Mieczkowski, Lennard Buluran
% ------------------------------------------------------------------------
function [count] = countCard(count,cardName)

% Counts cards for blackjack (Hi-Lo Method) by updating the current count
%      Inputs: count = current count
%              cardName = name of the card as a string
%     Outputs: count = updated count

% Aces, Kings, Queens, Jacks, and Tens have a count of -1
if cardName == 'A' || cardName == 'K' || cardName == 'Q' || cardName == 'J' || cardName == 'T'
    count = count - 1; % Subtracts 1 from the count if the card is an A, K, Q, J, or T

% 2's 3's, 4's, 5's, and 6's have a count of +1
elseif cardName == '2' || cardName == '3' || cardName == '4' || cardName == '5' || cardName == '6'
    count = count + 1; % Adds 1 to the count if the card is a 2, 3, 4, 5, or 6

% 7's, 8's, and 9's have a count of 0 (they're neutral cards that don't affect the count)
     
end