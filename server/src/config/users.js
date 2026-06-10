/** Hardcoded demo users — matches Flutter auth feature. */
const USERS = {
  'user-1': { id: 'user-1', name: 'Alex Kumar', email: 'alex@quickslot.demo' },
  'user-2': { id: 'user-2', name: 'Priya Sharma', email: 'priya@quickslot.demo' },
  'user-3': { id: 'user-3', name: 'Rahul Mehta', email: 'rahul@quickslot.demo' },
};

function isValidUser(userId) {
  return Boolean(USERS[userId]);
}

function getUser(userId) {
  return USERS[userId] ?? null;
}

module.exports = { USERS, isValidUser, getUser };
