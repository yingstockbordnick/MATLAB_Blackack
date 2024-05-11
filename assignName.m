%% =======================================================================
% MATLAB Project - Blackjack
% Ying Stock-Bordnick, Henry Mieczkowski, Lennard Buluran
% ------------------------------------------------------------------------
function [cardName] = assignName(deck,pos)

% Assigns a card name (as a string) based on the card in that position of the deck
%      Inputs: deck = current deck of cards
%              pos = random position within the deck (ranges from 1 to the length of the deck)
%     Outputs: cardName = card's name as a string

% There are 13 types of cards that the could be pulled from the deck (cases)
% Switch assigns card name based on what card is pulled from the deck

switch deck(pos) 
    case 1
        cardName = 'A'; % Ace
    case 2
        cardName = '2';
    case 3
        cardName = '3';
    case 4
        cardName = '4';
    case 5
        cardName = '5';
    case 6
        cardName = '6';
    case 7
        cardName = '7';
    case 8
        cardName = '8';
    case 9
        cardName = '9';
    case 10
        cardName = 'T'; % 10
    case 11
        cardName = 'J'; % Jack
    case 12
        cardName = 'Q'; % Queen
    case 13
        cardName = 'K'; % King
    otherwise 
        cardName = ''; % Default
end