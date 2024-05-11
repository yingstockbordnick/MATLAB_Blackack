% ========================================================================
% MATLAB Project - Blackjack
% ------------------------------------------------------------------------
% This is a blackjack stimulator where Blackjack pays 3-2, no insurance. 
% The only actions are hit, stay, or double (no split). The dealer stands
% on soft 17 and the suites of the cards are ignored. The game is played
% with one deck of cards and the count of the cards is displayed as the
% game progresses for the player to consider when making their bets/moves.
% Follow the prompts to play some blackjack!
% ========================================================================
clc; clear; format compact; close all;

fprintf('Welcome to the blackjack table! \n'); % Welcoming introduction

% Read in data for deck of cards (ignoring suites)
deck = xlsread('BlackjackDeck.xlsx'); % 13 types of cards * 4 of each type = 52 cards in one deck

balance = input('\nHow much money are you starting with? $'); % Ask player for starting balance
while balance <= 0 % Check if balance is greater than zero
    fprintf('\nStarting amount must be greater than zero.\n'); % If balance <= 0, asks player for another input
    balance = input('\nHow much money are you starting with? $');
end
balance = round(balance,2); % Balance is rounded to 2 decimal places

% Initialize vectors for storage
rounds = [];
counts = [];
hits = [];
net_gain_loss = [];

count = 0; % Initialize count for counting cards
R = 1; % Initialize round # counter (start with 1st round)
balances(R) = balance; % Initialize vector to store player's balances as each round passes (to graph after game ends)

while balance > 0 % Game continues as long as balance is above zero

    clc; % Clears command window before each round (to avoid crowded command window)
    if length(deck) < 15 % Check if there are lss than 15 cards left in the deck
        deck = xlsread('BlackjackDeck.xlsx'); % Resets deck if there are less than 15 cards left
        fprintf('<strong>The deck has been reshuffled!</strong>\n\n'); % Let's the player know deck has been reshuffled
        count = 0; % Resets count after deck is reset
    end
    
    fprintf('<strong>Round %.0f:</strong>\n\n',R); % Prints round number so player can keep track of how many hands they've played

    fprintf('Balance: <strong>$%.2f</strong>\t\tCount: <strong>%.0f</strong>\n',balance,count) % Prints player's current balance and the count

    bet = input('\nWhat''s your bet? $'); % Asks player for their bet at beginning of each round
    while bet <= 0 || bet > balance % Checks if bet is a valid input
        if bet <= 0 % Asks player to enter bet again if it is not greater than zero
            fprintf('\nBet must be greater than 0.\n')
            bet = input('\nWhat''s your bet? $');
        elseif bet > balance % Ask player to enter bet again if bet exceeds avaliable funds
            fprintf('\nBet must be less than or equal to your balance.\n')
            bet = input('\nWhat''s your bet? $');
        end
    end
    bet = round(bet,2); % Bet is rounded to 2 decimal places

    dCardNames = []; % Initialize vector to store string names of dealer's cards
    dCardValues = []; % Initialize vector to store numerical values of dealer's cards
    dHandValue = 0; % Initialize value of dealer's hand (value = 0 because no cards have been dealt yet).
    
    pCardNames = []; % Initialize vector to store string names of player's cards
    pCardValues = []; % Initialize vector to store numerical values of player's cards
    pHandValue = 0; % Initialize value of player's hand (value = 0 because no cards have been dealt yet).

    for i = 1:2 % Deal inital 4 cards in same order as casino would (player card 1 > dealer card 1 > player card 2 > dealer card 2)
     
        [deck,pCardNames(i),pCardValues(i)] = dealCard(deck,pHandValue); % Uses deal function to deal random card to player
        pHandValue = sum(pCardValues); % Calculates value of the player's hand after each card is dealt

        [deck,dCardNames(i),dCardValues(i)] = dealCard(deck,dHandValue); % Uses deal function to deal random card to dealer
        dHandValue = sum(dCardValues); % Calculates value of the dealer's hand after each card is dealt

    end

    count = countCard(count,pCardNames(1)); % Card counter function counts player's 1st card and updates count
    count = countCard(count,pCardNames(2)); % Card counter function counts player's 2nd card and updates count
    count = countCard(count,dCardNames(1)); % Card counter function counts dealer's 1st card and updates count, but ignores second card since it's 'hidden'
  
    fprintf('\n\tDealer has: %s.\n',dCardNames(1)); % Prints dealer's 1st card, keeping other card hidden
    fprintf('\tYou have: %s + %s = <strong>%.0f</strong>.\t\tCount: <strong>%.0f</strong>\n',pCardNames(1),pCardNames(2),pHandValue,count); % Prints player's cards, total value of player's hand, and the current count

    % Checks if there are any immediate blackjacks which would end the round
    if pHandValue == 21 && dHandValue == 21 % If player and dealer both have blackjacks, dealer reveals their cards and push (tie) is announced
        count = countCard(count,dCardNames(2)); % Counts dealer's 2nd card and updates count
        fprintf('\n\tDealer reveals: %s + %s = <strong>%.0f</strong>.\t\tCount: <strong>%.0f</strong>\n',dCardNames(1),dCardNames(2),dHandValue,count); % Dealer reveals their cards, their hand value, and the current count       
        fprintf('\nPush! You and the dealer both have <strong>blackjacks</strong>!   <strong>+$0</strong>\n'); % Result statement is printed
        move = ''; % Jumps to next round since no move is set

    elseif pHandValue == 21 && dHandValue < 21 % If player has a blackjack and the dealer does not, the player automatically wins and round is ended
        count = countCard(count,dCardNames(2)); % Counts dealer's 2nd card and updates count 
        fprintf('\n\tDealer reveals: %s + %s = <strong>%.0f</strong>.\t\tCount: <strong>%.0f</strong>\n',dCardNames(1),dCardNames(2),dHandValue,count); % Dealer reveals their cards, their hand value, and the current count
        fprintf('\nYou beat the dealer with a <strong>blackjack</strong>!   <strong>+$%.2f</strong>\n',(3/2)*bet); % Result statement is printed and shows the amount that is added to player's balance
        balance = balance + (3/2)*bet; % Blackjack pays 3/2, so 3/2 of the bet is added to player's balance
        balance = round(balance,2); % Balance is rounded to 2 decimal places
        move = ''; % Jumps to next round since no move is set
     
    elseif dHandValue == 21 && pHandValue < 21 % If dealer has blackjack and player doesn't, player loses and round is ended
        count = countCard(count,dCardNames(2)); % Counts dealer's 2nd card and updates count
        fprintf('\n\tDealer reveals: %s + %s = <strong>%d</strong>.\t\tCount: <strong>%.0f</strong>\n',dCardNames(1),dCardNames(2),dHandValue,count); % Dealer reveals their cards, their hand value, and the current count
        fprintf('\nThe house beat you with a <strong>blackjack</strong> :(   <strong>-$%.2f</strong>\n',bet); % Result statement is printed and shows the amount that is subtracted from player's balance
        balance = balance - bet; % Player loses, so bet is subtracted from balance
        balance = round(balance,2); % Balance is rounded to 2 decimal places
        move = ''; % Jumps to next round since no move is set

    else % If no one has a blackjack and player's hand is less than 21, asks for player's next move (options are: 'hit', 'stay', or 'double)
        move = input('\nDo you want to hit, stay, or double? ','s'); % Ask player for their next move (the option to double is only given for the player's first move)
        while ~(strcmpi(move,'hit') || strcmpi(move,'stay') || strcmpi(move,'double')) % Checks input for typos
            move = input('\nERROR: Please type ''hit'',''stay'', or ''double'': ','s'); % Asks again if there are typos
        end

        % If player choses to double, if statement is executed
        if strcmpi(move,'double') && ((balance - 2*bet) >= 0) % Checks if player has sufficient funds to double before executing if statement

            bet = bet*2; % Player's bet is doubled           
            fprintf('\nYou doubled your bet for 1 more card! Your bet is now <strong>$%.2f</strong>.\n',bet) % Prints player's new bet amount and explains what is happening

            [deck,cardName,cardVal] = dealCard(deck,pHandValue); % Deal function deals one more random card to player
            pCardNames = [cardName,pCardNames]; % Assigns card name of new card as the first value in the vector
            pCardValues = [cardVal,pCardValues]; % Assigns numerical value of new card as the first value in the vector
            pHandValue = sum(pCardValues); % Calculate value of player's updated hand
            
            count = countCard(count,pCardNames(1)); % Counts card that player is dealt
            fprintf('\n\tYou draw: %s.\t\tCount: <strong>%.0f</strong>\n',pCardNames(1),count); % Prints card that player draws and the updated count
            fprintf('\tYour total = <strong>%.0f</strong>.\n',pHandValue); % Prints total value of player's hand
          
            move = 'stay'; % Ends player's turn after they recieve 1 card and switches to dealer's turn by overriding player's move

        elseif strcmpi(move,'double') && ((balance - 2*bet) < 0) % Executes if player has insufficient funds to double
            fprintf('\nLooks like you don''t have enough money to double.\n')
            move = input('\nWould you like to hit or stay? ','s'); % Ask player for their next move
            while ~(strcmpi(move,'hit') || strcmpi(move,'stay')) % Checks input for typos
                move = input('\nERROR: Please type ''hit'' or''stay'': ','s'); % Asks again if there are typos
            end

        end
    end

    % Hit Loop
    while strcmpi(move,'hit') % While the player choses hit, this loop is executed (if player continues to hit, hit loop keeps repeating)

        [deck,cardName,cardVal] = dealCard(deck,pHandValue); % Deal function deals another random card to player
        pCardNames = [cardName,pCardNames]; % Assigns card name of new card as the first value in vector
        pCardValues = [cardVal,pCardValues]; % Assigns numerical value of new card as the first value in vector
        pHandValue = sum(pCardValues); % Calculate value of player's updated hand
        
        count = countCard(count,pCardNames(1)); % Counts card that player is dealt
        fprintf('\n\tYou draw: %s.\t\tCount: <strong>%.0f</strong>\n',pCardNames(1),count); % Prints card that player draws along with the updated count
        fprintf('\tYour total = <strong>%.0f</strong>.\n',pHandValue); % Prints total value of player's hand

        if pHandValue > 21 % If player's hand is above 21, they busted and the round ends
            fprintf('\nYou busted with <strong>%.0f</strong> :(   <strong>-$%.2f</strong>\n',pHandValue,bet); % Result statement is printed and shows amount that is subtracted from player's balance
            balance = balance - bet; % Player loses bet so bet gets subtracted from balance
            balance = round(balance,2); % Balance is rounded to 2 decimal places
            break % Breaks out of the hit loop and round ends 
        
        elseif pHandValue == 21 && dHandValue >= 17 && dHandValue < 21 % If player gets 21 and has a better hand than dealer, player wins and round ends
            count = countCard(count,dCardNames(2)); % Counts dealer's 2nd card and updates count
            fprintf('\n\tDealer reveals: %s + %s = <strong>%.0f</strong>.\t\tCount: <strong>%.0f</strong>\n',dCardNames(1),dCardNames(2),dHandValue,count); % Dealer reveals their cards, value of their hand, and updated count
            fprintf('\nYou beat the house with <strong>%.0f</strong>!   <strong>+$%.2f</strong>\n',pHandValue,bet); % Result statement is printed and shows amount that is added to player's balance
            balance = balance + bet; % Player wins bet so bet gets added to balance
            balance = round(balance,2); % Balance is rounded to 2 decimal places
            break % Breaks out of the hit loop and round ends  
        
        elseif pHandValue == 21 && dHandValue < 17 % If player gets 21 and dealer's hand is < 17, 'stay' loop is executed so dealer can start their turn drawing cards
            move = 'stay'; % Automatically moves to stay loop to begin dealer's turn without giving player a choice (they already have 21 so their hand can't get any better)
        
        else % If player's hand is < 21, asks for next move
            move = input('\nDo you want to hit or stay? ','s'); % Ask player for move
            while ~(strcmpi(move,'hit') || strcmpi(move,'stay')) % Give choice to hit or stay (cannot double after first move)
                move = input('\nERROR: Please type ''hit'' or ''stay'': ','s'); % Ask again if typo is entered
            end    
        end
    end

    % Stay Loop
    if strcmpi(move,'stay') % If player choses 'stay', their turn is ended and dealer begins their turn (player can only chose to stay once per round, so for loop is used)

        count = countCard(count,dCardNames(2)); % Counts dealer's 2nd card and updates count
        fprintf('\n\tDealer reveals: %s + %s = <strong>%.0f</strong>.\t\tCount: <strong>%.0f</strong>\n',dCardNames(1),dCardNames(2),dHandValue,count); % Dealer reveals hidden card, total value of hand, and updated count
        
        % In casinos, dealer usually hits on soft 17, but for simplicity of this code, dealer stands on soft 17
        while dHandValue < 17 % Dealer must hit if hand is less than 17 (Dealer can only stop when hand is >= 17)
            [deck,cardName,cardVal] = dealCard(deck,dHandValue); % Deal function deals another random card to dealer
            dCardNames = [cardName,dCardNames]; % Assigns card name of new card as the first value in vector
            dCardValues = [cardVal,dCardValues]; % Assigns numerical value of new card as the first value in vector
            dHandValue = sum(dCardValues); % Calculate value of dealer's updated hand
            
            count = countCard(count,dCardNames(1)); % Counts card that dealer is dealt
            fprintf('\tDealer draws: %s.\t\tCount: <strong>%.0f</strong>\n',dCardNames(1),count); % Prints card that dealer draws along with the count
            fprintf('\tDealer total = <strong>%.0f</strong>.\n',dHandValue); % Prints dealer's new total
        end

        % Leaves while loop once dealer's hand is >= 17, then determines who wins
        if dHandValue > 21 % If dealer draws greater than 21, dealer busts and player wins
            fprintf('\nHouse busts. You win!   <strong>+$%.2f</strong>\n',bet) % Result statement is printed and shows amount that is added to player's balance
            balance = balance + bet; % Bet is added to player's balance
            balance = round(balance,2); % Balance is rounded to 2 decimal places

        elseif dHandValue <= 21 % If dealer draws better than 17, 3 situations are possible

            if pHandValue == dHandValue % If dealer and player have equal hands, its a push
                fprintf('\nPush! You both got <strong>%.0f</strong>.   <strong>+$0</strong>\n',pHandValue); % Result statement is printed and nothing is added to player's balance

            elseif pHandValue > dHandValue % If player has a better hand than dealer, player wins
                fprintf('\nYou beat the house with <strong>%.0f</strong>!   <strong>+$%.2f</strong>\n',pHandValue,bet) % Result statement is printed and shows amount that is added to player's balance
                balance = balance + bet; % Bet is added to player's balance
                balance = round(balance,2); % Balance is rounded to 2 decimal places
                
            else % If player's hand is less than dealer's hand, player loses
                fprintf('\nThe house beat you with <strong>%.0f</strong> :(   <strong>-$%.2f</strong>\n',dHandValue,bet) % Result statement is printed and shows amount that is subtracted from player's balance
                balance = balance - bet; % Bet is subtracted from player's balance
                balance = round(balance,2); % Balance is rounded to 2 decimal places
                
            end
        end
    end

    balances(R+1) = balance; % Add updated balance to the vector of balances (for graphing at the end)

    R = R + 1; % Adds 1 to round counter in advance of next round

    fprintf('\nBalance: <strong>$%.2f</strong>\n',balance) % Prints player's updated balance

    if balance <= 0 % If player runs out of money, gives option to add money and continue playing
        rebuy = input('\nYou''re out of money :( Do you want to add more to continue playing? ','s'); % Ask user if they want to add more funds to their balance
        while ~(strcmpi(rebuy,'yes') || strcmpi(rebuy,'no')) % Check for typos
            rebuy = input('\nERROR: Please type ''yes'' if you want to rebuy or ''no'' if you''re done playing.\n','s'); % Ask again if there is typo    
        end
        if strcmpi(rebuy,'yes') || strcmpi(rebuy,'no')
            if strcmpi(rebuy,'yes') % If player choses to rebuy, asks for buy in amount
                balance = input('\nHow much do you want to add? $'); % Resets balance, game continues
            elseif strcmpi(rebuy,'no') % If player choses to end game, prints goodbye statement
                fprintf('\nThank''s for playing! Better luck next time.\n\n'); % Game ends since balance is <= 0
            end
        end
    end

    % Store values for each round
    rounds = [rounds, R-1]; % Stores round number
    counts = [counts, count]; % Stores count for each round
    hits = [hits, length(pCardValues)-2]; % Stores number of hits in each round
    net_gain_loss = [net_gain_loss, balances(R) - balances(R-1)]; % Stores net gain/loss in each round
    
    if balance > 0 % If player has funds to keep playing, pauses to allow player to read the result statement before next round starts and command window is cleared
        pause = input('\nType ''go'' to begin the next round or ''stop'' to quit playing: ','s'); % Ask user to confirm that they are ready for the next round
        while ~(strcmpi(pause,'go') || strcmpi(pause,'stop')) % Check for typos
            pause = input('\nERROR: Please type ''go'' to begin the next round or ''stop'' to quit playing: ','s'); % Asks again if there is typo
        end
        if strcmpi(pause,'stop') % If player choses to stop playing, prints goodbye statement 
            fprintf('\nThank''s for playing! Hope to see you again soon!\n\n');
            break % Breaks loop and game ends
        elseif strcmpi(pause,'go') % Once player types 'go', loop continues to next round
            pause = ''; % Resets input
        end
    end   
end

header = {'Round #' 'Ending Count' '# of Hits' '$ Net Gain/Loss'}; % Headers for the table
Stats_Summary = table(rounds', counts', hits', net_gain_loss', 'VariableNames', header) % Prints summary table after the game ends

% Prints graph of your balance throughout the game after the game ends
plot(0:length(rounds),balances,'ko-','MarkerFace','r','MarkerEdgeColor','r','MarkerSize',5,'Linewidth',2);
title('Your Blackjack Journey');
xlabel('Round #');
ylabel('Balance ($)');
grid on;