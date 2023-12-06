clear
clc
while(true)
    %Display the menu.
  menu = simpleGameEngine('title.png',500,500, 2);
    drawScene(menu, 1)
    
    
    
    
    
    menuInput = getKeyboardInput(menu);
   
    if(menuInput == 'r')
       % Display rules
       close;
       rules = simpleGameEngine('rulesText.png', 1000, 1000, 1);
       drawScene(rules, 1)
       %Get any input to end the if statement and return to the start of the loop, 
       %returning to the menu.
       getKeyboardInput(rules);
       close;
    end
    if(menuInput == 'q')
        %Close the current figure, and break out of the while loop.
        close;
        break;
    end
    % Single player game
    if(menuInput == '1')
        %Display the "Choose Size" screen
        close;
        chooseSize = simpleGameEngine('chooseSize.png',1000,1000,1);
        drawScene(chooseSize, 1);
        board_size = getKeyboardInput(chooseSize);
        %Make sure that if the user types a number using the numpad, the
        %word 'numpad' is removed from the variable.
        if(length(board_size) >= 6 && strcmp('numpad',board_size(1:6)))
            board_size = board_size(7);
        end
        while(~(board_size == '4' || board_size == '5' || board_size == '6' || board_size == '7' || board_size == '8' || board_size == '9'))
            board_size = getKeyboardInput(chooseSize);
            if(length(board_size) >= 6 && strcmp('numpad',board_size(1:6)))
            board_size = board_size(7);
            end
            %Continue receiving input until a valid size is entered. Then
            %use that value for board_size
        end
        board_size = str2double(board_size);
        close;
        %Declare the board as an array of ones(empty spaces), then declare the corner
        %squares to be blue and red splats
        scene = simpleGameEngine('SplataxxSpritesFinal1.png', 79, 84, 2);
        empty_square = 1;
        red_splat = 2;
        blue_splat = 3;
        board = ones(board_size, board_size) * empty_square;
        board(1,1) = red_splat;
        board(1, board_size) = blue_splat;
        board(board_size, 1) = blue_splat;
        board(board_size, board_size) = red_splat;
        drawScene(scene, board)

        while(~isequal(board == empty_square, zeros(board_size,board_size)) && ~isequal(board == red_splat, zeros(board_size,board_size)) && ~isequal(board == blue_splat, zeros(board_size,board_size)))
              if(hasValidMove(board,board_size,2))
                  %If player 1 has a valid move(using hasValidMove), start their turn.
                  title("Red: choose the splat you wish to split or jump.")
                  [firstClickRow, firstClickCol] = getMouseInput(scene);
                  firstClickIsValid = checkIfCanMove(firstClickRow,firstClickCol, board_size, board) && board(firstClickRow, firstClickCol) == red_splat;
                  while(firstClickIsValid == false)
                      [firstClickRow, firstClickCol] = getMouseInput(scene);
                      firstClickIsValid = checkIfCanMove(firstClickRow,firstClickCol, board_size, board) && board(firstClickRow, firstClickCol) == red_splat;
                      %Keep receiving clicks until a splat with a valid
                      %move is clicked, using checkIfCanMove to determine
                      %if a splat can move.
                  end
                  
                   title("Red: choose where to move your chosen splat.")
                  [secondClickRow, secondClickCol] = getMouseInput(scene);
                  secondClickIsValid = false;
                  if(board(secondClickRow, secondClickCol) == 1 && abs(secondClickRow - firstClickRow) <= 2 && abs(secondClickCol - firstClickCol) <= 2)
                      secondClickIsValid = true;
                  end
                  while(secondClickIsValid == false)
                      [secondClickRow, secondClickCol] = getMouseInput(scene);
                      if(board(secondClickRow, secondClickCol) == 1 && abs(secondClickRow - firstClickRow) <= 2 && abs(secondClickCol - firstClickCol) <= 2)
                          secondClickIsValid = true;
                      end
                      %Keep receiving input until the second click is
                      %valid, meaning it is an empty square within 2 squares of the
                      %original space.
                  end
                  %Click is valid: If it is within 1 space of the original
                  %square, just create a new splat there, if it is 2 away,
                  %create a new splat there and remove the original splat.
                  if(abs(secondClickRow - firstClickRow) <= 1 && abs(secondClickCol - firstClickCol) <= 1)
                      board(secondClickRow, secondClickCol) = red_splat;
                  else
                      board(secondClickRow, secondClickCol) = red_splat;
                      board(firstClickRow, firstClickCol) = empty_square;
                  end
                  %Check all squares one space away from the created splat,
                  %using rowOff and colOff as indexes. If the space
                  %contains an enemy splat(blue in this case), change it to
                  %red.
                  for rowOff = -1:1
                    for colOff = -1:1
                         curRow = secondClickRow + rowOff;
                         curCol = secondClickCol + colOff;
                         if(curRow <= board_size && curRow >= 1 && curCol <= board_size && curCol >= 1)
                             if(board(curRow,curCol) == blue_splat)
                                  board(curRow,curCol) = red_splat;
                             end
                        end
                     end
                  end
                  drawScene(scene,board)
              end
              if(hasValidMove(board,board_size,3))
                  %If the AI has a valid move, begin its turn after pausing
                  %for a fraction of a second to give the player time to
                  %process what the board looks like.
                  title("The CPU is thinking of a move")
                  pause(0.7)
                  %Gets the first and second clicks of the AI using the
                  %getAIClicks method.
                  [firstClickRow, firstClickCol, secondClickRow, secondClickCol] = getAIClicks(board, board_size);
       
                  %If the second click is within 1 space of the first click,
                  % just create a new splat there, if it is 2 away,
                  %create a new splat there and remove the original splat.
                  if(abs(secondClickRow - firstClickRow) <= 1 && abs(secondClickCol - firstClickCol) <= 1)
                      board(secondClickRow, secondClickCol) = blue_splat;
                  else
                      board(secondClickRow, secondClickCol) = blue_splat;
                      board(firstClickRow, firstClickCol) = empty_square;
                  end
                    %Check all squares one space away from the created splat,
                  %using rowOff and colOff as indexes. If the space
                  %contains an enemy splat(red in this case), change it to
                  %blue.
                  for rowOff = -1:1
                    for colOff = -1:1
                         curRow = secondClickRow + rowOff;
                         curCol = secondClickCol + colOff;
                         if(curRow <= board_size && curRow >= 1 && curCol <= board_size && curCol >= 1)
                             if(board(curRow,curCol) == red_splat)
                                  board(curRow,curCol) = blue_splat;
                             end
                        end
                     end
                  end
                  drawScene(scene,board)
              end




        end
        %Game is over: count the number of splats of each color, and
        %declare the color with more splats to be the winner.
        numRed = nnz(board == red_splat);
        numBlue = nnz(board == blue_splat);
        if(numRed > numBlue)
            title("Red Wins! Press any key to return to the menu.")
        elseif(numBlue > numRed)
            title("Blue Wins! Press any key to return to the menu.")
        else
            title("It's a draw! Press any key to return to the menu.")
        end
        getKeyboardInput(scene);
        close;
    
    end
    % Two player game: getting the size of the board and initializing the
    %scene is identical of that of a one player game.
    if(menuInput == '2')
        close;
        chooseSize = simpleGameEngine('chooseSize.png',1000,1000,1);
        drawScene(chooseSize, 1);
        board_size = getKeyboardInput(chooseSize);
        if(length(board_size) >= 6 && strcmp('numpad',board_size(1:6)))
            board_size = board_size(7);
        end
        while(~(board_size == '4' || board_size == '5' || board_size == '6' || board_size == '7' || board_size == '8' || board_size == '9'))
            board_size = getKeyboardInput(chooseSize);
            if(length(board_size) >= 6 && strcmp('numpad',board_size(1:6)))
            board_size = board_size(7);
            end
        end
        board_size = str2double(board_size);
        close;
        scene = simpleGameEngine('SplataxxSpritesFinal1.png', 79, 84, 2);
        empty_square = 1;
        red_splat = 2;
        blue_splat = 3;
        board = ones(board_size, board_size) * empty_square;
        board(1,1) = red_splat;
        board(1, board_size) = blue_splat;
        board(board_size, 1) = blue_splat;
        board(board_size, board_size) = red_splat;
        drawScene(scene, board)

        while(~isequal(board == 1, zeros(board_size,board_size)) && ~isequal(board == 2, zeros(board_size,board_size)) && ~isequal(board == 3, zeros(board_size,board_size)))
              if(hasValidMove(board,board_size,2))
                  % Player 1's turn is exactly the same as player 1's turn
                  % in a single player game, so it is not commented again.
                  title("Red: choose the splat you wish to split or jump.")
                  [firstClickRow, firstClickCol] = getMouseInput(scene);
                  firstClickIsValid = checkIfCanMove(firstClickRow,firstClickCol, board_size, board) && board(firstClickRow, firstClickCol) == 2;
                  while(firstClickIsValid == false)
                      [firstClickRow, firstClickCol] = getMouseInput(scene);
                      firstClickIsValid = checkIfCanMove(firstClickRow,firstClickCol, board_size, board) && board(firstClickRow, firstClickCol) == 2;
                  end
                   title("Red: choose where to move your chosen splat.")
                  [secondClickRow, secondClickCol] = getMouseInput(scene);
                  secondClickIsValid = false;
                  if(board(secondClickRow, secondClickCol) == 1 && abs(secondClickRow - firstClickRow) <= 2 && abs(secondClickCol - firstClickCol) <= 2)
                      secondClickIsValid = true;
                  end
                  while(secondClickIsValid == false)
                      [secondClickRow, secondClickCol] = getMouseInput(scene);
                      if(board(secondClickRow, secondClickCol) == 1 && abs(secondClickRow - firstClickRow) <= 2 && abs(secondClickCol - firstClickCol) <= 2)
                          secondClickIsValid = true;
                      end
                  end
                  %Click is valid
                  if(abs(secondClickRow - firstClickRow) <= 1 && abs(secondClickCol - firstClickCol) <= 1)
                      board(secondClickRow, secondClickCol) = red_splat;
                  else
                      board(secondClickRow, secondClickCol) = red_splat;
                      board(firstClickRow, firstClickCol) = empty_square;
                  end
                  for rowOff = -1:1
                    for colOff = -1:1
                         curRow = secondClickRow + rowOff;
                         curCol = secondClickCol + colOff;
                         if(curRow <= board_size && curRow >= 1 && curCol <= board_size && curCol >= 1)
                             if(board(curRow,curCol) == 3)
                                  board(curRow,curCol) = 2;
                             end
                        end
                     end
                  end
                  drawScene(scene,board)
              end
              if(hasValidMove(board,board_size,3))
                  %Player 2's turn is the exact same as player 1's turn,
                  %except red_splat and blue_splat are swapped
                  title("Blue: choose the splat you wish to split or jump.")
                  [firstClickRow, firstClickCol] = getMouseInput(scene);
                  firstClickIsValid = checkIfCanMove(firstClickRow,firstClickCol, board_size, board) && board(firstClickRow, firstClickCol) == blue_splat;
                  while(firstClickIsValid == false)
                      [firstClickRow, firstClickCol] = getMouseInput(scene);
                      firstClickIsValid = checkIfCanMove(firstClickRow,firstClickCol, board_size, board) && board(firstClickRow, firstClickCol) == blue_splat;
                  end
                  title("Blue: choose where to move your chosen splat.")
                  [secondClickRow, secondClickCol] = getMouseInput(scene);
                  secondClickIsValid = false;
                  if(board(secondClickRow, secondClickCol) == 1 && abs(secondClickRow - firstClickRow) <= 2 && abs(secondClickCol - firstClickCol) <= 2)
                      secondClickIsValid = true;
                  end
                  while(secondClickIsValid == false)
                      [secondClickRow, secondClickCol] = getMouseInput(scene);
                      if(board(secondClickRow, secondClickCol) == 1 && abs(secondClickRow - firstClickRow) <= 2 && abs(secondClickCol - firstClickCol) <= 2)
                          secondClickIsValid = true;
                      end
                  end
                  %Click is valid
                  if(abs(secondClickRow - firstClickRow) <= 1 && abs(secondClickCol - firstClickCol) <= 1)
                      board(secondClickRow, secondClickCol) = blue_splat;
                  else
                      board(secondClickRow, secondClickCol) = blue_splat;
                      board(firstClickRow, firstClickCol) = empty_square;
                  end
                  for rowOff = -1:1
                    for colOff = -1:1
                         curRow = secondClickRow + rowOff;
                         curCol = secondClickCol + colOff;
                         if(curRow <= board_size && curRow >= 1 && curCol <= board_size && curCol >= 1)
                             if(board(curRow,curCol) == 2)
                                  board(curRow,curCol) = 3;
                             end
                        end
                     end
                  end
                  drawScene(scene,board)
              end




        end
        %Game is over
        numRed = nnz(board == red_splat);
        numBlue = nnz(board == blue_splat);
        if(numRed > numBlue)
            title("Red Wins! Press any key to return to the menu.")
        elseif(numBlue > numRed)
            title("Blue Wins! Press any key to return to the menu.")
        else
            title("It's a draw! Press any key to return to the menu.")
        end
        getKeyboardInput(scene);
        close;
    end
    
end

function valid = checkIfCanMove(row,col, board_size, board)
%This function checks whether or not a splat has a valid move. Using two
%for loops, it checks every square within two spaces of the splat.
    empty_square = 1;
    valid = false;
     for rowOff = -2:2
        for colOff = -2:2
            curRow = row + rowOff;
            curCol = col + colOff;
            %For every square checked, it first makes sure the square is
            %within the bounds of the grid, and if it is, checks if the
            %square is empty. If any of the squares checked meet this
            %requirement, valid is set to true, so the function will return
            %true.
            if(curRow <= board_size && curRow >= 1 && curCol <= board_size && curCol >= 1)
                if(board(curRow,curCol) == empty_square)
                    valid = true;
                end
            end
        end
     end

end
function hasMove = hasValidMove(board,board_size,colorNum)
%Checks if a player has a valid move. Uses two for loops with row and col as indexes to check every
%grid space, and if the space is the same value as colorNum (meaning it
%contains a splat of the specified color),
% it uses the checkIfCanMove function to determine if that splat can move.
% If any of the splats can move, hasMove will be set to true and the
% function will return true.
  
    hasMove = false;
    for row = 1:board_size
        for col = 1:board_size 
                if(board(row,col) == colorNum && checkIfCanMove(row,col,board_size,board))
                    hasMove = true;
                    
                end
        end
    end
            
end
function [firstClickRow, firstClickCol, secondClickRow, secondClickCol] = getAIClicks(board, board_size)
%Checks all possible valid moves, and perform the one which leads to the 
%greatest increase in the AI's color.
%The first value in bestMove is the increase in the AI's color.
    blue_splat = 3;
%Loops through all squares using row and col as indexes. 
    bestMove = [0,1,1,1,1];
    for row = 1:board_size
        for col = 1:board_size
            if(board(row,col) == blue_splat)
            %If the space is a blue splat, loop through all squares within
            %two spaces of that splat using rowOff and colOff as indexes, and evaluate the strength of each
            %move using the evaluateStrength function.
                 for rowOff = -2:2
                      for colOff = -2:2
                           curRow = row + rowOff;
                           curCol = col + colOff;
                           if(curRow <= board_size && curRow >= 1 && curCol <= board_size && curCol >= 1)
                                if(board(curRow,curCol) == 1)
                                     %The evaluate strength function takes
                                     %in a final parameter specifying
                                     %whether the move is a jump or not. If
                                     %the move is 1 space away from the
                                     %original square, pass in false to
                                     %evaluateStrength, otherwise pass in
                                     %true.
                                     if(abs(rowOff) <= 1 && abs(colOff) <= 1)
                                         curStrength = evaluateStrength(board,board_size,curRow,curCol,false);
                                     else
                                         curStrength = evaluateStrength(board,board_size,curRow,curCol,true);
                                     end
                                     %If the strength of the current move
                                     %is greater than the strength of the
                                     %current best move, update bestMove to
                                     %contain the current strength and
                                     %move.
                                     if(curStrength >= bestMove(1))
                                         bestMove = [curStrength,row,col,curRow,curCol];
                                     end
                                end
                           end
                      end
                 end
            end
        end
    end
    firstClickRow = bestMove(2);
    firstClickCol = bestMove(3);
    secondClickRow = bestMove(4);
    secondClickCol = bestMove(5);
    
end
function strength = evaluateStrength(board, board_size, row, col, isJump)
     strength = 1;
     if(isJump)
         strength = 0;
     end
     for rowOff = -1:1
        for colOff = -1:1
             curRow = row + rowOff;
             curCol = col + colOff;
             if(curRow <= board_size && curRow >= 1 && curCol <= board_size && curCol >= 1)
                  if(board(curRow,curCol) == 2)
                      strength = strength + 1;
                  end
             end
         end
     end
end

