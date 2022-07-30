List<String> discussionSteps = [
  '1. Discussion start from the designated player to his right until everybody had his say.',
  '2. Progress to the "Voting" phase.',
  'If the designated player is dead, we start from the one on his right.',
];

List<String> voteSteps = [
  '1. Voting start from the player that started talking during the discussion phase.',
  '2. The most voted player/s should defend themselves during the next phase : "Defense".'
];

List<String> defenseSteps = [
  'In case of one player:',
  '1. The accused player must convince other players that he is a villager.',
  'In case of multiple players: ',
  '1. While everybody else are asleep, the captain should choose which player shall talk first.',
  '2. The accused players must defend themselves.',
  '3. The village should vote one out.',
  '4. If one player has been voted out, he shall have a chance to defend himself, otherwise we move to the "Execution" step.',
];

List<String> executionSteps = [
  'In case of one player:',
  '1. Voting start from the player right of the accused one.',
  'In case of multiple players: ',
  '1. The voting start from the player to right of the last one talking.',
  'If the vote is positive, the player will be executed.',
  'If the vote is negative, the player survive another day.',
  'If the vote is null (0), the captain decides his fate.',
  'If two or more players have the same vote (in case of multiple players), the captain decides what to do: kill someone or spare.',
];
