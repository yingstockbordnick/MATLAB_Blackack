%% =======================================================================
% MATLAB Project - Blackjack
% Ying Stock-Bordnick, Henry Mieczkowski, Lennard Buluran
% ------------------------------------------------------------------------
function [cardValue] = assignValue(deck,pos,handValue)

% Assigns a numerical value to a card based on its position in the deck
%      Inputs: deck = current deck of cards
%              pos = random position within the deck (ranges from 1 to the length of the deck)
%              handValue = numerical value of player or dealer's hand
%     Outputs: cardValue = dealt card's numerical value

% Position can be anything from 1 to the length of the deck (length = 52 for a full deck, deck = [1:13 1:13 1:13 1:13]) 
% This function finds the card (represented by a number from 1 to 13) that is in that specific position of the deck

% Special case for Ace:
if deck(pos) == 1 % If the card in the random position is a 1, assigns Ace characteristics
    % Determines if Ace should have a value of 11 or 1
    check = handValue + 11; % Calculates value of the hand if Ace value is 11
    if check > 21 % If the the hand's value + 11 exceeds 21, the Ace value is set to 1
        cardValue = 1;
    else % If hands's value + 11 doesn't exceed 21, Ace's value is set to 11
        cardValue = 11;
    end
    % In real blackjack at a casino, the value of the Ace can change from
    % 11 to 1 if the player previously treated the value as 11, but overdrew
    % later in the hand and decided to treat it as a 1 to avoid busting. For 
    % simplicity in this code, once the value of the Ace is set, it cannot
    % be changed. So, if you draw an Ace and it's value is set to 11 giving
    % you a higher hand value that is less than or equal to 21, it cannot be
    % changed later if you overdraw. The Ace will still hold its value at 11.

elseif deck(pos) >= 2 && deck(pos) <= 10 % For 2 through 10, the position matches what the card value should be, so value is set to be equal to the position
    cardValue = deck(pos);  

else % If deck(pos) ranges from 11 to 13, the value of the card is equal to 10 since all face cards (J, Q, K) have a value of 10
    cardValue = 10; % Set card's value to be equal to 10
end 