%% =======================================================================
% MATLAB Project - Blackjack
% Ying Stock-Bordnick, Henry Mieczkowski, Lennard Buluran
% ------------------------------------------------------------------------
function [deck,cardName,cardValue] = dealCard(deck,handValue)

% Deal function deals a random card from the deck
%      Inputs: - deck = current deck of cards
%              - handValue = numerical value of the hand
%     Outputs: - deck = updated deck without dealt card
%              - cardName = dealt card's name as a string
%              - cardValue = dealt card's numerical value

pos = randi(length(deck)); % Picks a random position within the deck (position can range from 1 to the length of the deck)

cardName = assignName(deck,pos); % Function within a function to determine the card's string name
cardValue = assignValue(deck,pos,handValue); % Function within a function to determine the card's numerical value

deck(pos) = []; % Removes chosen card from deck since it has been used which reduces length of deck by 1.

end