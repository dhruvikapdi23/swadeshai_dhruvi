const { isValidUser } = require('../config/users');

const USER_HEADER = 'x-user-id';

/** Validates X-User-Id against hardcoded users. */
function requireUser(req, res, next) {
  const userId = req.header(USER_HEADER);

  if (!userId) {
    return res.status(401).json({ error: 'Missing X-User-Id header' });
  }

  if (!isValidUser(userId)) {
    return res.status(401).json({ error: 'Invalid user id' });
  }

  req.userId = userId;
  return next();
}

/** Optional user header — attaches userId when present and valid. */
function optionalUser(req, _res, next) {
  const userId = req.header(USER_HEADER);
  if (userId && isValidUser(userId)) {
    req.userId = userId;
  }
  next();
}

module.exports = { requireUser, optionalUser, USER_HEADER };
