#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams");

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
  if [[ $YEAR != "year" ]]
  then
    #Attempt to add both winner and opponent onto the team.
    HAS_FOUND=$($PSQL "SELECT * from teams where name = '$WINNER'");
    #Check whether it does not contain any items from teams database.
    if [[ -z $HAS_FOUND ]]
      then
         RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')");
    fi
    #Check whether it does not contain any items from teams database.
    HAS_FOUND=$($PSQL "SELECT * from teams where name = '$OPPONENT'");
    if [[ -z $HAS_FOUND ]]
      then   
       RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')");    
    fi    
    #Then get the two identifiers obtained from the team database (winner and opponent) and incorporate the ids to add to games.
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
	#Add the game's results into the database.
    RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$TEAM_ID', '$TEAM_ID2', $WINNER_GOAL, $OPPONENT_GOAL)")

  fi
done